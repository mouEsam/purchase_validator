import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

var errorMap = {
  21000: 'The App Store could not read the JSON object you provided.',
  21002: 'The data in the receipt-data property was malformed.',
  21003: 'The receipt could not be authenticated.',
  21004:
      'The shared secret you provided does not match the shared secret on file for your account.',
  21005: 'The receipt server is not currently available.',
  21006:
      'This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response.',
  21007:
      'This receipt is a sandbox receipt, but it was sent to the production service for verification.',
  21008:
      'This receipt is a production receipt, but it was sent to the sandbox service for verification.',
  2: 'The receipt is valid, but purchased nothing.'
};

// ignore: camel_case_types
class REC_KEYS {
  static const String IN_APP = 'in_app';
  static const String STATUS = 'status';
  static const String RECEIPT = 'receipt';
  static const String LRI = 'latest_receipt_info';
  static const String BUNDLE_ID = 'bundle_id';
  static const String BID = 'bid';
  static const String TRANSACTION_ID = 'transaction_id';
  static const String ORIGINAL_TRANSACTION_ID = 'original_transaction_id';
  static const String PRODUCT_ID = 'product_id';
  static const String QUANTITY = 'quantity';
  static const String ITEM_ID = 'item_id';
  static const String ORIGINAL_PURCHASE_DATE_MS = 'original_purchase_date_ms';
  static const String EXPIRES_DATE_MS = 'expires_date_ms';
  static const String EXPIRES_DATE = 'expires_date';
  static const String EXPIRATION_DATE = 'expiration_date';
  static const String EXPIRATION_DATE_MS = 'expiration_date_ms';
  static const String EXPIRATION_INTENT = 'expiration_intent';
  static const String CANCELLATION_DATE = 'cancellation_date';
  static const String CANCELLATION_DATE_MS = 'cancellation_date_ms';
  static const String PURCHASE_DATE_MS = 'purchase_date_ms';
  static const String IS_TRIAL = 'is_trial';
  static const String IS_TRIAL_PERIOD = 'is_trial_period';
}

const l = [
  'bundle_id',
  'item_id',
  'original_transaction_id',
  'transaction_id',
  'product_id',
  'original_purchase_date_ms',
  'purchase_date_ms',
  'quantity',
  'expiration_date',
  'is_trial',
  'cancellation_date_ms',
];

const APP_SECRET = '75d054dc21f94408a3deb3c4c5fd45de';
const path = '/verifyReceipt';
const prodPath = 'https://buy.itunes.apple.com$path';
const sandboxPath = 'https://sandbox.itunes.apple.com$path';

final bool appleExcludeOldTransactions = false;
final bool ignoreCanceled = false;
final bool ignoreExpired = false;

Map<String, dynamic> parse(Map<String, dynamic> response) {
  return response.map((key, value) {
    final d = double.tryParse(value);
    return MapEntry(key, d ?? value);
  });
}

bool toBool(val) {
  return val == 'true' ? true : false;
}

bool isExpired(Map<String, dynamic>? receipt) {
  if (receipt != null && receipt[REC_KEYS.EXPIRES_DATE] != null) {
    var exp = DateTime.tryParse(receipt[REC_KEYS.EXPIRES_DATE]);
    if (exp != null || exp!.isBefore(DateTime.now())) {
      return true;
    }
    return false;
  }
  return false;
}

int? getSubscriptionExpireDate(Map<String, dynamic>? data) {
  if (data == null) {
    return 0;
  }
  if (data[REC_KEYS.EXPIRES_DATE_MS]) {
    return int.tryParse(data[REC_KEYS.EXPIRES_DATE_MS]);
  }
  if (data[REC_KEYS.EXPIRES_DATE]) {
    return DateTime.tryParse(data[REC_KEYS.EXPIRES_DATE])
        ?.millisecondsSinceEpoch;
  }
  if (data[REC_KEYS.EXPIRATION_DATE]) {
    return DateTime.tryParse(data[REC_KEYS.EXPIRATION_DATE])
        ?.millisecondsSinceEpoch;
  }
  if (data[REC_KEYS.EXPIRATION_INTENT]) {
    return int.tryParse(data[REC_KEYS.EXPIRATION_INTENT]);
  }
  return 0;
}

Future<List<Map<String, dynamic>>> getPurchaseInfo(String receipt) async {
  final purchase = await _validateReceipt(receipt);
  var data = [];
  if (purchase[REC_KEYS.RECEIPT][REC_KEYS.IN_APP] != null) {
    final now = DateTime.now();
    var tids = [];
    final receipt = purchase[REC_KEYS.RECEIPT];
    final list = receipt[REC_KEYS.IN_APP] as List;
    var lri = purchase[REC_KEYS.LRI] ?? receipt[REC_KEYS.LRI];
    if (lri != null && lri is List) {
      list.addAll(lri);
    }
    /*
        we sort list by purchase_date_ms to make it easier
        to weed out duplicates (items with the same original_transaction_id)
        purchase_date_ms DESC
        */
    list.sort((a, b) {
      return int.parse(b[REC_KEYS.PURCHASE_DATE_MS])
          .compareTo(int.parse(a[REC_KEYS.PURCHASE_DATE_MS]));
    });
    for (var i = 0, len = list.length; i < len; i++) {
      var item = list[i];
      var tid = item['original_' + REC_KEYS.TRANSACTION_ID];
      var exp = getSubscriptionExpireDate(item) ?? 0;

      if (ignoreCanceled &&
          item[REC_KEYS.CANCELLATION_DATE] != null &&
          item[REC_KEYS.CANCELLATION_DATE].length > 0 &&
          /* if a subscription has been cancelled,
                we need to check if the receipt has expired or not...
                if it is not subscription (exp is 0 in that case), we ignore right away...
                */
          (exp == 0 || now.millisecondsSinceEpoch - exp >= 0)) {
        continue;
      }

      if (ignoreExpired && exp != 0 && now.millisecondsSinceEpoch - exp >= 0) {
        // we are told to ignore expired item and it is expired
        continue;
      }
      if (tids.contains(tid)) {
        /* avoid duplicate and keep the latest
                there are cases where we could have
                the same "time" so we evaludate <= instead of < alone */
        continue;
      }
      tids.add(tid);
      item = parse(item);
      // transaction ID should be a string:
      // https://developer.apple.com/documentation/storekit/skpaymenttransaction/1411288-transactionidentifier
      item[REC_KEYS.TRANSACTION_ID] = item[REC_KEYS.TRANSACTION_ID].toString();

      // originalTransactionId should also be a string
      if (item[REC_KEYS.ORIGINAL_TRANSACTION_ID] != null) {
        item[REC_KEYS.ORIGINAL_TRANSACTION_ID] =
            item[REC_KEYS.ORIGINAL_TRANSACTION_ID].toString();
      }

      // we need to stick to the name isTrial
      item[REC_KEYS.IS_TRIAL] = toBool(item[REC_KEYS.IS_TRIAL_PERIOD]);

      item[REC_KEYS.BUNDLE_ID] =
          receipt[REC_KEYS.BUNDLE_ID] ?? receipt[REC_KEYS.BID];
      item[REC_KEYS.EXPIRATION_DATE] = exp;
      data.add(item);
    }
  } else {
    // old and will be deprecated by Apple
    var receipt = purchase[REC_KEYS.LRI] ?? purchase[REC_KEYS.RECEIPT];
    data.add({
      REC_KEYS.BUNDLE_ID: receipt[REC_KEYS.BUNDLE_ID] ?? receipt[REC_KEYS.BID],
      REC_KEYS.ITEM_ID: receipt[REC_KEYS.ITEM_ID],
      REC_KEYS.ORIGINAL_TRANSACTION_ID:
          receipt[REC_KEYS.ORIGINAL_TRANSACTION_ID],
      REC_KEYS.TRANSACTION_ID: receipt[REC_KEYS.TRANSACTION_ID],
      REC_KEYS.PRODUCT_ID: receipt[REC_KEYS.PRODUCT_ID],
      REC_KEYS.ORIGINAL_PURCHASE_DATE_MS:
          receipt[REC_KEYS.ORIGINAL_PURCHASE_DATE_MS],
      REC_KEYS.PURCHASE_DATE_MS: receipt[REC_KEYS.PURCHASE_DATE_MS],
      REC_KEYS.QUANTITY: int.parse(receipt[REC_KEYS.QUANTITY]),
      REC_KEYS.EXPIRATION_DATE: getSubscriptionExpireDate(receipt),
      REC_KEYS.IS_TRIAL: toBool(receipt[REC_KEYS.IS_TRIAL_PERIOD]),
      REC_KEYS.CANCELLATION_DATE_MS: receipt[REC_KEYS.CANCELLATION_DATE_MS] ?? 0
    });
    return data as FutureOr<List<Map<String, dynamic>>>;
  }
  return data as FutureOr<List<Map<String, dynamic>>>;
}

Future<Map<String, dynamic>> _validateReceipt(String receipt) async {
  final content = {
    'receipt-data': receipt,
    'password': APP_SECRET,
    'exclude-old-transactions': appleExcludeOldTransactions,
  };
  var validationResult = await _sendValidationRequest(content);
  if (validationResult![REC_KEYS.STATUS] == 21007) {
    validationResult = await (_sendValidationRequest(content, true));
  }
  if (validationResult![REC_KEYS.STATUS] > 0 &&
      validationResult[REC_KEYS.STATUS] != 21007 &&
      validationResult[REC_KEYS.STATUS] != 21002) {
    if (validationResult[REC_KEYS.STATUS] == 21006 &&
        !isExpired(validationResult)) {
      /* valid subscription receipt,
                    but cancelled and it has not been expired
                    status code is 21006 for both expired receipt and cancelled receipt...
                    */
      // force status to be 0
      validationResult[REC_KEYS.STATUS] = 0;
    }
  }
  return validationResult;
}

Future<Map<String, dynamic>?> _sendValidationRequest(
    Map<String, dynamic> content,
    [bool sandbox = false]) async {
  final url = sandbox ? sandboxPath : prodPath;
  const jsonType = 'application/json';
  final result = await http.post(Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: jsonType,
        HttpHeaders.acceptHeader: jsonType
      },
      body: jsonEncode(content));
  final json = jsonDecode(result.body);
  return json;
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'models/apple/apple_receipt.dart';
import 'models/apple/apple_validation_response.dart';
import 'models/apple/apple_validation_result.dart';

export 'models/apple/apple_receipt.dart';
export 'models/apple/apple_validation_result.dart';

const errorMap = {
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
      'This receipt is a production receipt, but it was sent to the sandbox service for verification.'
};

const path = '/verifyReceipt';
const prodPath = 'https://buy.itunes.apple.com$path';
const sandboxPath = 'https://sandbox.itunes.apple.com$path';

class ApplePurchaseValidator {
  final String _appSecret;
  final bool appleExcludeOldTransactions;
  final bool ignoreCanceled;
  final bool ignoreExpired;

  const ApplePurchaseValidator(
      this._appSecret,
      this.appleExcludeOldTransactions,
      this.ignoreCanceled,
      this.ignoreExpired);

  Future<AppleValidationResult> getPurchaseInfo(String receipt) async {
    final purchase = await _validateReceipt(receipt);
    final result = <AppleReceipt>[];
    if (purchase.receipt?.inApp?.isNotEmpty ?? false) {
      final receipts = purchase.receipt.inApp
          .map((receiptResponse) => AppleReceipt.fromResponse(receiptResponse))
          .toList();
      receipts.sort((a, b) {
        return a.purchaseDateMs.compareTo(b.purchaseDateMs);
      });
      final tIds = <String>[];
      final now = DateTime.now();
      for (final receipt in receipts) {
        final tId = receipt.originalTransactionId;
        final exp = receipt.expirationDateMs ?? 0;
        final expired = now.millisecondsSinceEpoch - exp >= 0;
        if (ignoreCanceled &&
            receipt.cancellationDate != null &&
            /* if a subscription has been cancelled,
                we need to check if the receipt has expired or not...
                if it is not subscription (exp is 0 in that case), we ignore right away...
                */
            (exp == 0 || expired)) {
          continue;
        }
        if (ignoreExpired &&
            exp != 0 &&
            now.millisecondsSinceEpoch - exp >= 0) {
          // we are told to ignore expired item and it is expired
          continue;
        }
        if (tIds.contains(tId)) {
          /* avoid duplicate and keep the latest
                there are cases where we could have
                the same "time" so we evaludate <= instead of < alone */
          continue;
        }
        tIds.add(tId);
        result.add(receipt);
      }
    } else if (purchase.latestReceiptInfo != null) {
      final receipt = AppleReceipt.fromResponse(purchase.latestReceiptInfo);
      result.add(receipt);
    }
    // ### If the IAP was not purchased then the "in_app" field would be missing.
    else if (purchase.receipt != null) {
      final receipt = AppleReceipt.fromReceipt(purchase.receipt);
      result.add(receipt);
    }
    return AppleValidationResult(
        result, purchase.status, errorMap[purchase.status]);
  }

  Future<AppleValidationResponse> _validateReceipt(String receipt) async {
    final content = {
      'receipt-data': receipt,
      'password': _appSecret,
      'exclude-old-transactions': appleExcludeOldTransactions,
    };
    var validationResult = await _sendValidationRequest(content);
    if (validationResult.status == 21007) {
      validationResult = await _sendValidationRequest(content, true);
    }
    if (validationResult.status > 0 &&
        validationResult.status != 21007 &&
        validationResult.status != 21002) {
      if (validationResult.status == 21006 && !validationResult.isExpired) {
        /* valid subscription receipt,
                    but cancelled and it has not been expired
                    status code is 21006 for both expired receipt and cancelled receipt...
                    */
        // force status to be 0
        validationResult = validationResult.copyWith(status: 0);
      }
    }
    return validationResult;
  }

  Future<AppleValidationResponse> _sendValidationRequest(
      Map<String, dynamic> content,
      [bool sandbox = false]) async {
    final url = sandbox ? sandboxPath : prodPath;
    const jsonType = 'application/json';
    final result = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: jsonType,
          HttpHeaders.acceptHeader: jsonType
        },
        body: jsonEncode(content));
    print(result.body);
    final json = jsonDecode(result.body);
    return AppleValidationResponse.fromJson(json);
  }
}

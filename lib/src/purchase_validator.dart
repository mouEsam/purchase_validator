import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchase_validator/src/models/validation_result.dart';

import './apple_purchase_validator.dart' as apple;
import './google_purchase_validator.dart' as google;

class PurchaseValidator {
  final apple.ApplePurchaseValidator appleValidator;
  final google.GooglePurchaseValidator googleValidator;

  PurchaseValidator._(this.appleValidator, this.googleValidator);

  static Future<PurchaseValidator> create(
      String googleKeyAssetPath, String appleAppSecret) async {
    final appleValidator =
        apple.ApplePurchaseValidator(appleAppSecret, false, false, false);
    final googleValidator =
        await google.GooglePurchaseValidator.create(googleKeyAssetPath);
    return PurchaseValidator._(appleValidator, googleValidator);
  }

  Future<ValidationResult> getReceipt(IAPSource source, String productId,
      String receipt, String transactionId) {
    if (source == IAPSource.AppStore) {
      return _getReceiptApple(receipt);
    } else {
      return _getReceiptGoogle(productId, receipt);
    }
  }

  Future<apple.AppleValidationResult> _getReceiptApple(String receipt) {
    return appleValidator.getPurchaseInfo(receipt);
  }

  Future<google.GoogleValidationResult> _getReceiptGoogle(
      String productId, String receipt) {
    return googleValidator.getPurchaseInfo(productId, receipt);
  }

  Future<bool> validate(IAPSource source, String productId, String receipt,
      String transactionId) {
    if (source == IAPSource.AppStore) {
      return _validateApple(receipt, transactionId);
    } else {
      return _validateGoogle(productId, receipt, transactionId);
    }
  }

  Future<bool> _validateApple(String receipt, String transactionId) async {
    var valid = false;
    final info = await appleValidator.getPurchaseInfo(receipt);
    if (info.status == 0 && info.data != null) {
      final transaction = info.data.firstWhere(
          (element) => element.transactionId == transactionId,
          orElse: () => null);
      valid = transaction != null && transaction.cancellationDateMs == null;
    }
    return valid;
  }

  Future<bool> _validateGoogle(
      String productId, String receipt, String transactionId) async {
    var valid = false;
    final info = await googleValidator.getPurchaseInfo(productId, receipt);
    valid = info.status == 0 &&
        info.data != null &&
        info.data.purchaseState != google.PurchaseState.Canceled;
    return valid;
  }
}

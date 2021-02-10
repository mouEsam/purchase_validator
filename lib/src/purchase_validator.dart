import 'package:purchase_validator/src/models/validation_result.dart';

import './apple_purchase_validator.dart' as apple;
import './google_purchase_validator.dart' as google;

enum PurchaseSource {
  AppStore,
  PlayStore,
}

class PurchaseValidator {
  final apple.ApplePurchaseValidator appleValidator;
  final google.GooglePurchaseValidator googleValidator;

  PurchaseValidator._(this.appleValidator, this.googleValidator);

  static Future<PurchaseValidator> create(
      String googleKeyAssetPath, String appleAppSecret,
      [String googlePackageName]) async {
    final appleValidator =
        apple.ApplePurchaseValidator(appleAppSecret, false, false, false);
    final googleValidator = await google.GooglePurchaseValidator.create(
        googleKeyAssetPath, googlePackageName);
    return PurchaseValidator._(appleValidator, googleValidator);
  }

  Future<ValidationResult> getReceipt(PurchaseSource source, String productId,
      String receipt, String transactionId) {
    try {
      if (source == PurchaseSource.AppStore) {
        return _getReceiptApple(receipt);
      } else {
        return _getReceiptGoogle(productId, receipt);
      }
    } catch (e, s) {
      print(e);
      print(s);
      return Future.value(null);
    }
  }

  Future<apple.AppleValidationResult> _getReceiptApple(String receipt) {
    return appleValidator.getPurchaseInfo(receipt);
  }

  Future<google.GoogleValidationResult> _getReceiptGoogle(
      String productId, String receipt) {
    return googleValidator.getPurchaseInfo(productId, receipt);
  }

  Future<ValidationState> validate(PurchaseSource source, String productId,
      String receipt, String transactionId) {
    try {
      if (source == PurchaseSource.AppStore) {
        return _validateApple(receipt, transactionId);
      } else {
        return _validateGoogle(productId, receipt, transactionId);
      }
    } catch (e, s) {
      print(e);
      print(s);
      return Future.value(ValidationState.Unknown);
    }
  }

  Future<ValidationState> _validateApple(
      String receipt, String transactionId) async {
    ValidationState validationState = ValidationState.Unknown;
    final info = await appleValidator.getPurchaseInfo(receipt);
    if (info.status == 0 && info.data != null) {
      final transaction = info.data.firstWhere(
          (element) => element.transactionId == transactionId,
          orElse: () => null);
      final valid =
          transaction != null && transaction.cancellationDateMs == null;
      validationState = valid ? ValidationState.Valid : ValidationState.Invalid;
    } else if ([21002, 21004, 21005, 21009, 21010].contains(info.status)) {
      validationState = ValidationState.Unknown;
    } else {
      validationState = ValidationState.Invalid;
    }
    return validationState;
  }

  Future<ValidationState> _validateGoogle(
      String productId, String receipt, String transactionId) async {
    ValidationState validationState = ValidationState.Unknown;
    var valid = false;
    final info = await googleValidator.getPurchaseInfo(productId, receipt);
    valid = info.status == 0 &&
        info.data != null &&
        info.data.purchaseState != google.PurchaseState.Canceled;
    validationState = valid ? ValidationState.Valid : ValidationState.Invalid;
    return validationState;
  }
}

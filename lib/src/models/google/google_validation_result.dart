import '../validation_result.dart';
import 'google_validation.dart';

class GoogleValidationResult extends ValidationResult<GooglePurchaseInfo?> {
  const GoogleValidationResult(
      GooglePurchaseInfo? receipt, int status, String? errorMessage)
      : super(receipt, status, errorMessage);
}

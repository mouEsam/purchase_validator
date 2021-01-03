import '../validation_result.dart';
import 'apple_receipt.dart';

class AppleValidationResult extends ValidationResult<List<AppleReceipt>> {
  const AppleValidationResult(
      List<AppleReceipt> receipts, int status, String errorMessage)
      : super(receipts, status, errorMessage);
}

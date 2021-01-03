import 'package:equatable/equatable.dart';
import 'package:purchase_validator/src/apple_purchase_validator.dart';
import 'package:purchase_validator/src/google_purchase_validator.dart';

abstract class ValidationResult<T> extends Equatable {
  final T data;
  final int status;
  final String errorMessage;

  const ValidationResult(this.data, this.status, this.errorMessage);

  List<AppleReceipt> get appleReceipts =>
      data is List<AppleReceipt> ? data as List<AppleReceipt> : null;
  GooglePurchaseInfo get googleReceipt =>
      data is GooglePurchaseInfo ? data as GooglePurchaseInfo : null;

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [data, status, errorMessage];
}

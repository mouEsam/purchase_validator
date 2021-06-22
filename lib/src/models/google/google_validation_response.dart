import 'package:json_annotation/json_annotation.dart';

part 'google_validation_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class GoogleValidationResponse extends GooglePurchaseResource {
  GoogleValidationResponse({
    String? kind,
    String? purchaseTimeMillis,
    int? purchaseState,
    int? consumptionState,
    String? developerPayload,
    String? orderId,
    int? purchaseType,
    int? acknowledgementState,
    String? purchaseToken,
    String? productId,
    int? quantity,
    String? obfuscatedExternalAccountId,
    String? obfuscatedExternalProfileId,
    String? regionCode,
    this.error,
  }) : super(
          kind: kind,
          purchaseTimeMillis: purchaseTimeMillis,
          purchaseState: purchaseState,
          consumptionState: consumptionState,
          developerPayload: developerPayload,
          orderId: orderId,
          purchaseType: purchaseType,
          acknowledgementState: acknowledgementState,
          purchaseToken: purchaseToken,
          productId: productId,
          quantity: quantity,
          obfuscatedExternalAccountId: obfuscatedExternalAccountId,
          obfuscatedExternalProfileId: obfuscatedExternalProfileId,
          regionCode: regionCode,
        );

  final GoogleValidationResponseError? error;

  factory GoogleValidationResponse.fromJson(Map<String, dynamic> json) =>
      _$GoogleValidationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleValidationResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class GoogleValidationResponseError {
  GoogleValidationResponseError({
    this.code,
    this.message,
    this.status,
    this.errors,
  });

  final int? code;
  final String? message;
  final String? status;
  final List<ErrorElement?>? errors;

  factory GoogleValidationResponseError.fromJson(Map<String, dynamic> json) =>
      _$GoogleValidationResponseErrorFromJson(json);
  Map<String, dynamic> toJson() => _$GoogleValidationResponseErrorToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class ErrorElement {
  ErrorElement({
    this.message,
    this.domain,
    this.reason,
    this.location,
    this.locationType,
  });

  final String? message;
  final String? domain;
  final String? reason;
  final String? location;
  final String? locationType;

  factory ErrorElement.fromJson(Map<String, dynamic> json) =>
      _$ErrorElementFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorElementToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class GooglePurchaseResource {
  GooglePurchaseResource({
    this.kind,
    this.purchaseTimeMillis,
    this.purchaseState,
    this.consumptionState,
    this.developerPayload,
    this.orderId,
    this.purchaseType,
    this.acknowledgementState,
    this.purchaseToken,
    this.productId,
    this.quantity,
    this.obfuscatedExternalAccountId,
    this.obfuscatedExternalProfileId,
    this.regionCode,
  });

  final String? kind;
  final String? purchaseTimeMillis;
  final int? purchaseState;
  final int? consumptionState;
  final String? developerPayload;
  final String? orderId;
  final int? purchaseType;
  final int? acknowledgementState;
  final String? purchaseToken;
  final String? productId;
  final int? quantity;
  final String? obfuscatedExternalAccountId;
  final String? obfuscatedExternalProfileId;
  final String? regionCode;

  factory GooglePurchaseResource.fromJson(Map<String, dynamic> json) =>
      _$GooglePurchaseResourceFromJson(json);
  Map<String, dynamic> toJson() => _$GooglePurchaseResourceToJson(this);
}

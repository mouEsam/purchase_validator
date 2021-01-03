// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_validation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoogleValidationResponse _$GoogleValidationResponseFromJson(
    Map<String, dynamic> json) {
  return GoogleValidationResponse(
    kind: json['kind'] as String,
    purchaseTimeMillis: json['purchaseTimeMillis'] as String,
    purchaseState: json['purchaseState'] as int,
    consumptionState: json['consumptionState'] as int,
    developerPayload: json['developerPayload'] as String,
    orderId: json['orderId'] as String,
    purchaseType: json['purchaseType'] as int,
    acknowledgementState: json['acknowledgementState'] as int,
    purchaseToken: json['purchaseToken'] as String,
    productId: json['productId'] as String,
    quantity: json['quantity'] as int,
    obfuscatedExternalAccountId: json['obfuscatedExternalAccountId'] as String,
    obfuscatedExternalProfileId: json['obfuscatedExternalProfileId'] as String,
    regionCode: json['regionCode'] as String,
    error: json['error'] == null
        ? null
        : GoogleValidationResponseError.fromJson(
            json['error'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GoogleValidationResponseToJson(
        GoogleValidationResponse instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'purchaseTimeMillis': instance.purchaseTimeMillis,
      'purchaseState': instance.purchaseState,
      'consumptionState': instance.consumptionState,
      'developerPayload': instance.developerPayload,
      'orderId': instance.orderId,
      'purchaseType': instance.purchaseType,
      'acknowledgementState': instance.acknowledgementState,
      'purchaseToken': instance.purchaseToken,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'obfuscatedExternalAccountId': instance.obfuscatedExternalAccountId,
      'obfuscatedExternalProfileId': instance.obfuscatedExternalProfileId,
      'regionCode': instance.regionCode,
      'error': instance.error,
    };

GoogleValidationResponseError _$GoogleValidationResponseErrorFromJson(
    Map<String, dynamic> json) {
  return GoogleValidationResponseError(
    code: json['code'] as int,
    message: json['message'] as String,
    status: json['status'] as String,
    errors: (json['errors'] as List)
        ?.map((e) =>
            e == null ? null : ErrorElement.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GoogleValidationResponseErrorToJson(
        GoogleValidationResponseError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'status': instance.status,
      'errors': instance.errors,
    };

ErrorElement _$ErrorElementFromJson(Map<String, dynamic> json) {
  return ErrorElement(
    message: json['message'] as String,
    domain: json['domain'] as String,
    reason: json['reason'] as String,
    location: json['location'] as String,
    locationType: json['locationType'] as String,
  );
}

Map<String, dynamic> _$ErrorElementToJson(ErrorElement instance) =>
    <String, dynamic>{
      'message': instance.message,
      'domain': instance.domain,
      'reason': instance.reason,
      'location': instance.location,
      'locationType': instance.locationType,
    };

GooglePurchaseResource _$GooglePurchaseResourceFromJson(
    Map<String, dynamic> json) {
  return GooglePurchaseResource(
    kind: json['kind'] as String,
    purchaseTimeMillis: json['purchaseTimeMillis'] as String,
    purchaseState: json['purchaseState'] as int,
    consumptionState: json['consumptionState'] as int,
    developerPayload: json['developerPayload'] as String,
    orderId: json['orderId'] as String,
    purchaseType: json['purchaseType'] as int,
    acknowledgementState: json['acknowledgementState'] as int,
    purchaseToken: json['purchaseToken'] as String,
    productId: json['productId'] as String,
    quantity: json['quantity'] as int,
    obfuscatedExternalAccountId: json['obfuscatedExternalAccountId'] as String,
    obfuscatedExternalProfileId: json['obfuscatedExternalProfileId'] as String,
    regionCode: json['regionCode'] as String,
  );
}

Map<String, dynamic> _$GooglePurchaseResourceToJson(
        GooglePurchaseResource instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'purchaseTimeMillis': instance.purchaseTimeMillis,
      'purchaseState': instance.purchaseState,
      'consumptionState': instance.consumptionState,
      'developerPayload': instance.developerPayload,
      'orderId': instance.orderId,
      'purchaseType': instance.purchaseType,
      'acknowledgementState': instance.acknowledgementState,
      'purchaseToken': instance.purchaseToken,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'obfuscatedExternalAccountId': instance.obfuscatedExternalAccountId,
      'obfuscatedExternalProfileId': instance.obfuscatedExternalProfileId,
      'regionCode': instance.regionCode,
    };

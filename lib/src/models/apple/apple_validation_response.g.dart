// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_validation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppleValidationResponse _$AppleValidationResponseFromJson(
    Map<String, dynamic> json) {
  return AppleValidationResponse(
    environment: json['environment'] as String,
    isRetryable: json['is-retryable'] as bool,
    status: json['status'] as int,
    latestReceipt: json['latest_receipt'] as String,
    latestReceiptInfo: json['latest_receipt_info'] == null
        ? null
        : LatestReceiptInfo.fromJson(
            json['latest_receipt_info'] as Map<String, dynamic>),
    pendingRenewalInfo: json['pending_renewal_info'] == null
        ? null
        : PendingRenewalInfo.fromJson(
            json['pending_renewal_info'] as Map<String, dynamic>),
    receipt: json['receipt'] == null
        ? null
        : Receipt.fromJson(json['receipt'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AppleValidationResponseToJson(
        AppleValidationResponse instance) =>
    <String, dynamic>{
      'environment': instance.environment,
      'is-retryable': instance.isRetryable,
      'status': instance.status,
      'latest_receipt': instance.latestReceipt,
      'latest_receipt_info': instance.latestReceiptInfo,
      'pending_renewal_info': instance.pendingRenewalInfo,
      'receipt': instance.receipt,
    };

LatestReceiptInfo _$LatestReceiptInfoFromJson(Map<String, dynamic> json) {
  return LatestReceiptInfo(
    cancellationDate: json['cancellation_date'] as String,
    cancellationDateMs: json['cancellation_date_ms'] as String,
    cancellationDatePst: json['cancellation_date_pst'] as String,
    cancellationReason: json['cancellation_reason'] as String,
    expiresDate: json['expires_date'] as String,
    expiresDateMs: json['expires_date_ms'] as String,
    expiresDatePst: json['expires_date_pst'] as String,
    inAppOwnershipType: json['in_app_ownership_type'] as String,
    isInIntroOfferPeriod: json['is_in_intro_offer_period'] as String,
    isTrialPeriod: json['is_trial_period'] as String,
    isUpgraded: json['is_upgraded'] as String,
    offerCodeRefName: json['offer_code_ref_name'] as String,
    originalPurchaseDate: json['original_purchase_date'] as String,
    originalPurchaseDateMs: json['original_purchase_date_ms'] as String,
    originalPurchaseDatePst: json['original_purchase_date_pst'] as String,
    originalTransactionId: json['original_transaction_id'] as String,
    productId: json['product_id'] as String,
    promotionalOfferId: json['promotional_offer_id'] as String,
    purchaseDate: json['purchase_date'] as String,
    purchaseDateMs: json['purchase_date_ms'] as String,
    purchaseDatePst: json['purchase_date_pst'] as String,
    quantity: json['quantity'] as String,
    subscriptionGroupIdentifier:
        json['subscription_group_identifier'] as String,
    webOrderLineItemId: json['web_order_line_item_id'] as String,
    transactionId: json['transaction_id'] as String,
  );
}

Map<String, dynamic> _$LatestReceiptInfoToJson(LatestReceiptInfo instance) =>
    <String, dynamic>{
      'cancellation_date': instance.cancellationDate,
      'cancellation_date_ms': instance.cancellationDateMs,
      'cancellation_date_pst': instance.cancellationDatePst,
      'cancellation_reason': instance.cancellationReason,
      'expires_date': instance.expiresDate,
      'expires_date_ms': instance.expiresDateMs,
      'expires_date_pst': instance.expiresDatePst,
      'in_app_ownership_type': instance.inAppOwnershipType,
      'is_in_intro_offer_period': instance.isInIntroOfferPeriod,
      'is_trial_period': instance.isTrialPeriod,
      'is_upgraded': instance.isUpgraded,
      'offer_code_ref_name': instance.offerCodeRefName,
      'original_purchase_date': instance.originalPurchaseDate,
      'original_purchase_date_ms': instance.originalPurchaseDateMs,
      'original_purchase_date_pst': instance.originalPurchaseDatePst,
      'original_transaction_id': instance.originalTransactionId,
      'product_id': instance.productId,
      'promotional_offer_id': instance.promotionalOfferId,
      'purchase_date': instance.purchaseDate,
      'purchase_date_ms': instance.purchaseDateMs,
      'purchase_date_pst': instance.purchaseDatePst,
      'quantity': instance.quantity,
      'subscription_group_identifier': instance.subscriptionGroupIdentifier,
      'web_order_line_item_id': instance.webOrderLineItemId,
      'transaction_id': instance.transactionId,
    };

PendingRenewalInfo _$PendingRenewalInfoFromJson(Map<String, dynamic> json) {
  return PendingRenewalInfo(
    autoRenewProductId: json['auto_renew_product_id'] as String,
    autoRenewStatus: json['auto_renew_status'] as String,
    expirationIntent: json['expiration_intent'] as String,
    gracePeriodExpiresDate: json['grace_period_expires_date'] as String,
    gracePeriodExpiresDateMs: json['grace_period_expires_date_ms'] as String,
    gracePeriodExpiresDatePst: json['grace_period_expires_date_pst'] as String,
    isInBillingRetryPeriod: json['is_in_billing_retry_period'] as String,
    offerCodeRefName: json['offer_code_ref_name'] as String,
    originalTransactionId: json['original_transaction_id'] as String,
    priceConsentStatus: json['price_consent_status'] as String,
    productId: json['product_id'] as String,
  );
}

Map<String, dynamic> _$PendingRenewalInfoToJson(PendingRenewalInfo instance) =>
    <String, dynamic>{
      'auto_renew_product_id': instance.autoRenewProductId,
      'auto_renew_status': instance.autoRenewStatus,
      'expiration_intent': instance.expirationIntent,
      'grace_period_expires_date': instance.gracePeriodExpiresDate,
      'grace_period_expires_date_ms': instance.gracePeriodExpiresDateMs,
      'grace_period_expires_date_pst': instance.gracePeriodExpiresDatePst,
      'is_in_billing_retry_period': instance.isInBillingRetryPeriod,
      'offer_code_ref_name': instance.offerCodeRefName,
      'original_transaction_id': instance.originalTransactionId,
      'price_consent_status': instance.priceConsentStatus,
      'product_id': instance.productId,
    };

Receipt _$ReceiptFromJson(Map<String, dynamic> json) {
  return Receipt(
    adamId: json['adam_id'] as int,
    appItemId: json['app_item_id'] as int,
    applicationVersion: json['application_version'] as String,
    bundleId: json['bundle_id'] as String,
    downloadId: json['download_id'] as int,
    expirationDate: json['expiration_date'] as String,
    expirationDateMs: json['expiration_date_ms'] as String,
    expirationDatePst: json['expiration_date_pst'] as String,
    inApp: (json['in_app'] as List)
        ?.map((e) => e == null
            ? null
            : LatestReceiptInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    originalApplicationVersion: json['original_application_version'] as String,
    originalPurchaseDate: json['original_purchase_date'] as String,
    originalPurchaseDateMs: json['original_purchase_date_ms'] as String,
    originalPurchaseDatePst: json['original_purchase_date_pst'] as String,
    preorderDate: json['preorder_date'] as String,
    preorderDateMs: json['preorder_date_ms'] as String,
    preorderDatePst: json['preorder_date_pst'] as String,
    receiptCreationDate: json['receipt_creation_date'] as String,
    receiptCreationDateMs: json['receipt_creation_date_ms'] as String,
    receiptCreationDatePst: json['receipt_creation_date_pst'] as String,
    receiptType: json['receipt_type'] as String,
    requestDate: json['request_date'] as String,
    requestDateMs: json['request_date_ms'] as String,
    requestDatePst: json['request_date_pst'] as String,
    versionExternalIdentifier: json['version_external_identifier'] as int,
  );
}

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'adam_id': instance.adamId,
      'app_item_id': instance.appItemId,
      'application_version': instance.applicationVersion,
      'bundle_id': instance.bundleId,
      'download_id': instance.downloadId,
      'expiration_date': instance.expirationDate,
      'expiration_date_ms': instance.expirationDateMs,
      'expiration_date_pst': instance.expirationDatePst,
      'in_app': instance.inApp,
      'original_application_version': instance.originalApplicationVersion,
      'original_purchase_date': instance.originalPurchaseDate,
      'original_purchase_date_ms': instance.originalPurchaseDateMs,
      'original_purchase_date_pst': instance.originalPurchaseDatePst,
      'preorder_date': instance.preorderDate,
      'preorder_date_ms': instance.preorderDateMs,
      'preorder_date_pst': instance.preorderDatePst,
      'receipt_creation_date': instance.receiptCreationDate,
      'receipt_creation_date_ms': instance.receiptCreationDateMs,
      'receipt_creation_date_pst': instance.receiptCreationDatePst,
      'receipt_type': instance.receiptType,
      'request_date': instance.requestDate,
      'request_date_ms': instance.requestDateMs,
      'request_date_pst': instance.requestDatePst,
      'version_external_identifier': instance.versionExternalIdentifier,
    };

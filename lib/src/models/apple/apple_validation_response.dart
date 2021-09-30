import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'apple_validation_response.g.dart';

List<LatestReceiptInfo>? _ifSingleToMultipleReceipt(json) {
  if (json is Map<String, dynamic>) {
    return [LatestReceiptInfo.fromJson(json)];
  } else if (json is List) {
    return json
        .map((e) => _ifSingleToMultipleReceipt(e))
        .whereType<List<LatestReceiptInfo>>()
        .expand((element) => element)
        .toList();
  }
}

List<PendingRenewalInfo>? _ifSingleToMultipleRenewal(json) {
  if (json is Map<String, dynamic>) {
    return [PendingRenewalInfo.fromJson(json)];
  } else if (json is List) {
    return json
        .map((e) => _ifSingleToMultipleReceipt(e))
        .whereType<List<PendingRenewalInfo>>()
        .expand((element) => element)
        .toList();
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AppleValidationResponse {
  const AppleValidationResponse({
    this.environment,
    this.isRetryable,
    this.status,
    this.latestReceipt,
    this.latestReceiptInfo,
    this.pendingRenewalInfo,
    this.receipt,
  });

  final String? environment;
  @JsonKey(name: 'is-retryable')
  final bool? isRetryable;
  final int? status;
  final String? latestReceipt;
  @JsonKey(fromJson: _ifSingleToMultipleReceipt)
  final List<LatestReceiptInfo>? latestReceiptInfo;
  @JsonKey(fromJson: _ifSingleToMultipleRenewal)
  final List<PendingRenewalInfo>? pendingRenewalInfo;
  final Receipt? receipt;

  LatestReceiptInfo? get latestReceiptItem =>
      latestReceiptInfo?.isNotEmpty == true ? latestReceiptInfo!.last : null;

  bool get isExpired {
    final latest = latestReceiptItem;
    if (latest != null && latest.expiresDate != null) {
      var exp = DateTime.tryParse(latest.expiresDate!);
      if (exp != null || exp!.isBefore(DateTime.now())) {
        return true;
      }
      return false;
    }
    return false;
  }

  AppleValidationResponse copyWith({
    String? environment,
    bool? isRetryable,
    int? status,
    String? latestReceipt,
    List<LatestReceiptInfo>? latestReceiptInfo,
    List<PendingRenewalInfo>? pendingRenewalInfo,
    Receipt? receipt,
  }) =>
      AppleValidationResponse(
        environment: environment ?? this.environment,
        isRetryable: isRetryable ?? this.isRetryable,
        status: status ?? this.status,
        latestReceipt: latestReceipt ?? this.latestReceipt,
        latestReceiptInfo: latestReceiptInfo ?? this.latestReceiptInfo,
        pendingRenewalInfo: pendingRenewalInfo ?? this.pendingRenewalInfo,
        receipt: receipt ?? this.receipt,
      );

  factory AppleValidationResponse.fromJson(Map<String, dynamic> json) =>
      _$AppleValidationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AppleValidationResponseToJson(this);
}

abstract class BaseReceipt {
  String? get originalTransactionId;
  String? get transactionId;
  String? get productId;
  int get amount;
  int? get originalPurchaseDateMS;
  int? get purchaseDateMS;
  int? get expirationDateMS;
  int? get cancellationDateMS;
  bool get isTrial;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LatestReceiptInfo extends Equatable implements BaseReceipt {
  const LatestReceiptInfo({
    this.cancellationDate,
    this.cancellationDateMs,
    this.cancellationDatePst,
    this.cancellationReason,
    this.expiresDate,
    this.expiresDateMs,
    this.expiresDatePst,
    this.inAppOwnershipType,
    this.isInIntroOfferPeriod,
    this.isTrialPeriod,
    this.isUpgraded,
    this.offerCodeRefName,
    this.originalPurchaseDate,
    this.originalPurchaseDateMs,
    this.originalPurchaseDatePst,
    this.originalTransactionId,
    this.productId,
    this.promotionalOfferId,
    this.purchaseDate,
    this.purchaseDateMs,
    this.purchaseDatePst,
    this.quantity,
    this.subscriptionGroupIdentifier,
    this.webOrderLineItemId,
    this.transactionId,
  });

  final String? cancellationDate;
  final String? cancellationDateMs;
  final String? cancellationDatePst;
  final String? cancellationReason;
  final String? expiresDate;
  final String? expiresDateMs;
  final String? expiresDatePst;
  final String? inAppOwnershipType;
  final String? isInIntroOfferPeriod;
  final String? isTrialPeriod;
  final String? isUpgraded;
  final String? offerCodeRefName;
  final String? originalPurchaseDate;
  final String? originalPurchaseDateMs;
  final String? originalPurchaseDatePst;
  @override
  final String? originalTransactionId;
  @override
  final String? productId;
  final String? promotionalOfferId;
  final String? purchaseDate;
  final String? purchaseDateMs;
  final String? purchaseDatePst;
  final String? quantity;
  final String? subscriptionGroupIdentifier;
  final String? webOrderLineItemId;
  @override
  final String? transactionId;

  @override
  int? get originalPurchaseDateMS =>
      _appleDateTime(originalPurchaseDateMs, originalPurchaseDate);

  @override
  int get amount => int.tryParse(quantity!) ?? 1;

  @override
  int? get cancellationDateMS =>
      _appleDateTime(cancellationDateMs, cancellationDate);

  @override
  int? get expirationDateMS => _appleDateTime(expiresDateMs, expiresDate);

  @override
  bool get isTrial => isTrialPeriod != null || _toBool(isTrialPeriod);

  @override
  int? get purchaseDateMS => _appleDateTime(purchaseDateMs, purchaseDate);

  factory LatestReceiptInfo.fromJson(Map<String, dynamic> json) =>
      _$LatestReceiptInfoFromJson(json);
  Map<String, dynamic> toJson() => _$LatestReceiptInfoToJson(this);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        cancellationDate,
        cancellationDateMs,
        cancellationDatePst,
        cancellationReason,
        expiresDate,
        expiresDateMs,
        expiresDatePst,
        inAppOwnershipType,
        isInIntroOfferPeriod,
        isTrialPeriod,
        isUpgraded,
        offerCodeRefName,
        originalPurchaseDate,
        originalPurchaseDateMs,
        originalPurchaseDatePst,
        originalTransactionId,
        productId,
        promotionalOfferId,
        purchaseDate,
        purchaseDateMs,
        purchaseDatePst,
        quantity,
        subscriptionGroupIdentifier,
        webOrderLineItemId,
        transactionId,
      ];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PendingRenewalInfo {
  const PendingRenewalInfo({
    this.autoRenewProductId,
    this.autoRenewStatus,
    this.expirationIntent,
    this.gracePeriodExpiresDate,
    this.gracePeriodExpiresDateMs,
    this.gracePeriodExpiresDatePst,
    this.isInBillingRetryPeriod,
    this.offerCodeRefName,
    this.originalTransactionId,
    this.priceConsentStatus,
    this.productId,
  });

  final String? autoRenewProductId;
  final String? autoRenewStatus;
  final String? expirationIntent;
  final String? gracePeriodExpiresDate;
  final String? gracePeriodExpiresDateMs;
  final String? gracePeriodExpiresDatePst;
  final String? isInBillingRetryPeriod;
  final String? offerCodeRefName;
  final String? originalTransactionId;
  final String? priceConsentStatus;
  final String? productId;

  factory PendingRenewalInfo.fromJson(Map<String, dynamic> json) =>
      _$PendingRenewalInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PendingRenewalInfoToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Receipt extends Equatable {
  const Receipt({
    this.adamId,
    this.appItemId,
    this.applicationVersion,
    this.bundleId,
    this.downloadId,
    this.expirationDate,
    this.expirationDateMs,
    this.expirationDatePst,
    this.inApp,
    this.originalApplicationVersion,
    this.originalPurchaseDate,
    this.originalPurchaseDateMs,
    this.originalPurchaseDatePst,
    this.preorderDate,
    this.preorderDateMs,
    this.preorderDatePst,
    this.receiptCreationDate,
    this.receiptCreationDateMs,
    this.receiptCreationDatePst,
    this.receiptType,
    this.requestDate,
    this.requestDateMs,
    this.requestDatePst,
    this.versionExternalIdentifier,
  });

  final int? adamId;
  final int? appItemId;
  final String? applicationVersion;
  final String? bundleId;
  final int? downloadId;
  final String? expirationDate;
  final String? expirationDateMs;
  final String? expirationDatePst;
  final List<LatestReceiptInfo?>? inApp;
  final String? originalApplicationVersion;
  final String? originalPurchaseDate;
  final String? originalPurchaseDateMs;
  final String? originalPurchaseDatePst;
  final String? preorderDate;
  final String? preorderDateMs;
  final String? preorderDatePst;
  final String? receiptCreationDate;
  final String? receiptCreationDateMs;
  final String? receiptCreationDatePst;
  final String? receiptType;
  final String? requestDate;
  final String? requestDateMs;
  final String? requestDatePst;
  final int? versionExternalIdentifier;

  factory Receipt.fromJson(Map<String, dynamic> json) =>
      _$ReceiptFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptToJson(this);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        adamId,
        appItemId,
        applicationVersion,
        bundleId,
        downloadId,
        expirationDate,
        expirationDateMs,
        expirationDatePst,
        inApp,
        originalApplicationVersion,
        originalPurchaseDate,
        originalPurchaseDateMs,
        originalPurchaseDatePst,
        preorderDate,
        preorderDateMs,
        preorderDatePst,
        receiptCreationDate,
        receiptCreationDateMs,
        receiptCreationDatePst,
        receiptType,
        requestDate,
        requestDateMs,
        requestDatePst,
        versionExternalIdentifier
      ];
}

int? _appleDateTime(String? inMillis, String? iso8601) {
  int? result;
  if (inMillis != null) {
    result = int.tryParse(inMillis);
  }
  if (iso8601 != null) {
    result = DateTime.tryParse(iso8601)?.millisecondsSinceEpoch;
  }
  return result;
}

bool _toBool(val) {
  return val == 'true' ? true : false;
}

import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';

import 'apple_validation_response.dart';

enum InAppOwnershipType { FAMILY_SHARED, PURCHASED }

extension on InAppOwnershipType {
  // ignore: missing_return
  String get stringRepresentation {
    switch (this) {
      case InAppOwnershipType.PURCHASED:
        return 'PURCHASED';
      case InAppOwnershipType.FAMILY_SHARED:
        return 'FAMILY_SHARED';
    }
  }
}

extension on String {
  InAppOwnershipType? get inAppOwnershipType => InAppOwnershipType.values
      .firstWhereOrNull((element) => element.stringRepresentation == this);
}

class AppleReceipt extends Equatable {
  const AppleReceipt._(
      {this.cancellationDate,
      this.expirationDate,
      this.inAppOwnershipType,
      this.isInIntroOfferPeriod,
      this.isTrial,
      this.isUpgraded,
      this.offerCodeRefName,
      this.originalPurchaseDate,
      this.originalTransactionId,
      this.productId,
      this.promotionalOfferId,
      this.purchaseDate,
      this.quantity,
      this.subscriptionGroupIdentifier,
      this.webOrderLineItemId,
      this.transactionId});

  final DateTime? cancellationDate;
  final DateTime? expirationDate;
  final InAppOwnershipType? inAppOwnershipType;
  final bool? isInIntroOfferPeriod;
  final bool? isTrial;
  final bool? isUpgraded;
  final String? offerCodeRefName;
  final DateTime? originalPurchaseDate;
  final String? originalTransactionId;
  final String? productId;
  final String? promotionalOfferId;
  final DateTime? purchaseDate;
  final int? quantity;
  final String? subscriptionGroupIdentifier;
  final String? webOrderLineItemId;
  final String? transactionId;

  int? get purchaseDateMs => purchaseDate?.millisecondsSinceEpoch;
  int? get originalPurchaseDateMs =>
      originalPurchaseDate?.millisecondsSinceEpoch;
  int? get cancellationDateMs => cancellationDate?.millisecondsSinceEpoch;
  int? get expirationDateMs => expirationDate?.millisecondsSinceEpoch;

  factory AppleReceipt.fromReceipt(Receipt receipt) {
    print(receipt);
    print(receipt.toJson()..removeWhere((key, value) => value == null));
    final originalPurchaseDateMs = _appleDateTime(
        receipt.originalPurchaseDateMs, receipt.originalPurchaseDate);
    final originalPurchaseDate = originalPurchaseDateMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(originalPurchaseDateMs);
    final expirationDateMs =
        _appleDateTime(receipt.expirationDateMs, receipt.expirationDate);
    final expirationDate = expirationDateMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(expirationDateMs);
    return AppleReceipt._(
      originalPurchaseDate: originalPurchaseDate,
      expirationDate: expirationDate,
    );
  }

  factory AppleReceipt.fromResponse(LatestReceiptInfo receiptInfo) {
    final originalPurchaseDateMs = _appleDateTime(
        receiptInfo.originalPurchaseDateMs, receiptInfo.originalPurchaseDate);
    final originalPurchaseDate = originalPurchaseDateMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(originalPurchaseDateMs);
    final quantity = int.tryParse(receiptInfo.quantity!) ?? 1;
    final cancellationDateMs = _appleDateTime(
        receiptInfo.cancellationDateMs, receiptInfo.cancellationDate);
    final cancellationDate = cancellationDateMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(cancellationDateMs);
    final expirationDateMs =
        _appleDateTime(receiptInfo.expiresDateMs, receiptInfo.expiresDate);
    final expirationDate = expirationDateMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(expirationDateMs);
    final isTrial = _toBool(receiptInfo.isTrialPeriod);
    final isUpgraded = _toBool(receiptInfo.isUpgraded);
    final isInIntroOfferPeriod = _toBool(receiptInfo.isInIntroOfferPeriod);
    final purchaseDateMs =
        _appleDateTime(receiptInfo.purchaseDateMs, receiptInfo.purchaseDate);
    final purchaseDate = purchaseDateMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(purchaseDateMs);

    return AppleReceipt._(
        cancellationDate: cancellationDate,
        expirationDate: expirationDate,
        inAppOwnershipType: receiptInfo.inAppOwnershipType?.inAppOwnershipType,
        isInIntroOfferPeriod: isInIntroOfferPeriod,
        isTrial: isTrial,
        isUpgraded: isUpgraded,
        offerCodeRefName: receiptInfo.offerCodeRefName,
        originalPurchaseDate: originalPurchaseDate,
        originalTransactionId: receiptInfo.originalTransactionId,
        productId: receiptInfo.productId,
        promotionalOfferId: receiptInfo.promotionalOfferId,
        purchaseDate: purchaseDate,
        quantity: quantity,
        subscriptionGroupIdentifier: receiptInfo.subscriptionGroupIdentifier,
        webOrderLineItemId: receiptInfo.webOrderLineItemId,
        transactionId: receiptInfo.transactionId);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        cancellationDate,
        expirationDate,
        inAppOwnershipType,
        isInIntroOfferPeriod,
        isTrial,
        isUpgraded,
        offerCodeRefName,
        originalPurchaseDate,
        originalTransactionId,
        productId,
        promotionalOfferId,
        purchaseDate,
        quantity,
        subscriptionGroupIdentifier,
        webOrderLineItemId,
        transactionId
      ];
}

int? _appleDateTime(String? inMillis, String? iso8601) {
  int? result;
  if (inMillis != null) {
    result = int.tryParse(inMillis);
  } else if (iso8601 != null) {
    result = DateTime.tryParse(iso8601)?.millisecondsSinceEpoch;
  }
  return result;
}

bool _toBool(val) {
  return val == 'true' ? true : false;
}

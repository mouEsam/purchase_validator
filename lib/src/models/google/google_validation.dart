import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'google_validation_response.dart';

enum PurchaseState { Purchased, Canceled, Pending }

extension on PurchaseState {
  // ignore: missing_return
  int get id {
    switch (this) {
      case PurchaseState.Purchased:
        return 0;
      case PurchaseState.Canceled:
        return 1;
      case PurchaseState.Pending:
        return 2;
    }
  }
}

class PurchaseStateConverter implements JsonConverter<PurchaseState?, int?> {
  const PurchaseStateConverter();
  @override
  PurchaseState? fromJson(int? json) {
    return json?.purchaseState;
  }

  @override
  int? toJson(PurchaseState? object) {
    return object?.id;
  }
}

enum PurchaseType { Normal, Test, Promo, Rewarded }

extension on PurchaseType {
  int? get id {
    switch (this) {
      case PurchaseType.Test:
        return 0;
      case PurchaseType.Promo:
        return 1;
      case PurchaseType.Rewarded:
        return 2;
      default:
        return null;
    }
  }
}

class PurchaseTypeConverter implements JsonConverter<PurchaseType, int?> {
  const PurchaseTypeConverter();
  @override
  PurchaseType fromJson(int? json) {
    return json?.purchaseType ?? PurchaseType.Normal;
  }

  @override
  int? toJson(PurchaseType object) {
    return object.id;
  }
}

enum ConsumptionState { NotConsumed, Consumed }

extension on ConsumptionState {
  // ignore: missing_return
  int get id {
    switch (this) {
      case ConsumptionState.NotConsumed:
        return 0;
      case ConsumptionState.Consumed:
        return 1;
    }
  }
}

class ConsumptionStateConverter
    implements JsonConverter<ConsumptionState?, int?> {
  const ConsumptionStateConverter();
  @override
  ConsumptionState? fromJson(int? json) {
    return json?.consumptionState;
  }

  @override
  int? toJson(ConsumptionState? object) {
    return object?.id;
  }
}

enum AcknowledgementState { NotAcknowledged, Acknowledged }

extension on AcknowledgementState {
  // ignore: missing_return
  int get id {
    switch (this) {
      case AcknowledgementState.NotAcknowledged:
        return 0;
      case AcknowledgementState.Acknowledged:
        return 1;
    }
  }
}

class AcknowledgementStateConverter
    implements JsonConverter<AcknowledgementState?, int?> {
  const AcknowledgementStateConverter();
  @override
  AcknowledgementState? fromJson(int? json) {
    return json?.acknowledgementState;
  }

  @override
  int? toJson(AcknowledgementState? object) {
    return object?.id;
  }
}

extension on int {
  PurchaseState? get purchaseState =>
      PurchaseState.values.firstWhereOrNull((element) => element.id == this);
  ConsumptionState? get consumptionState =>
      ConsumptionState.values.firstWhereOrNull((element) => element.id == this);
  PurchaseType get purchaseType =>
      PurchaseType.values.firstWhere((element) => element.id == this,
          orElse: () => PurchaseType.Normal);
  AcknowledgementState? get acknowledgementState => AcknowledgementState.values
      .firstWhereOrNull((element) => element.id == this);
}

class GooglePurchaseInfo extends Equatable {
  GooglePurchaseInfo._({
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

  factory GooglePurchaseInfo.fromResponse(GooglePurchaseResource response) {
    return GooglePurchaseInfo._(
      kind: response.kind,
      purchaseState: response.purchaseState?.purchaseState,
      purchaseType: response.purchaseType?.purchaseType,
      acknowledgementState: response.acknowledgementState?.acknowledgementState,
      consumptionState: response.consumptionState?.consumptionState,
      developerPayload: response.developerPayload,
      obfuscatedExternalAccountId: response.obfuscatedExternalAccountId,
      obfuscatedExternalProfileId: response.obfuscatedExternalProfileId,
      orderId: response.orderId,
      productId: response.productId,
      purchaseTimeMillis: response.purchaseTimeMillis,
      purchaseToken: response.purchaseToken,
      quantity: response.quantity,
      regionCode: response.regionCode,
    );
  }

  final String? kind;
  final String? purchaseTimeMillis;
  final PurchaseState? purchaseState;
  final ConsumptionState? consumptionState;
  final String? developerPayload;
  final String? orderId;
  final PurchaseType? purchaseType;
  final AcknowledgementState? acknowledgementState;
  final String? purchaseToken;
  final String? productId;
  final int? quantity;
  final String? obfuscatedExternalAccountId;
  final String? obfuscatedExternalProfileId;
  final String? regionCode;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        kind,
        purchaseTimeMillis,
        purchaseState,
        consumptionState,
        developerPayload,
        orderId,
        purchaseType,
        acknowledgementState,
        purchaseToken,
        productId,
        quantity,
        obfuscatedExternalAccountId,
        obfuscatedExternalProfileId,
        regionCode,
      ];
}

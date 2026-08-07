// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    _PaymentMethodModel(
      selectedMethod: json['selectedMethod'] as String,
      cardNumberMasked: json['cardNumberMasked'] as String,
      expiryDate: json['expiryDate'] as String,
      cvvMasked: json['cvvMasked'] as String,
      vehicleName: json['vehicleName'] as String,
      vehicleTier: json['vehicleTier'] as String,
      vehicleImagePath: json['vehicleImagePath'] as String,
      baseFare: (json['baseFare'] as num).toDouble(),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      taxes: (json['taxes'] as num).toDouble(),
      grandTotal: (json['grandTotal'] as num).toDouble(),
      currencySymbol: json['currencySymbol'] as String,
    );

Map<String, dynamic> _$PaymentMethodModelToJson(_PaymentMethodModel instance) =>
    <String, dynamic>{
      'selectedMethod': instance.selectedMethod,
      'cardNumberMasked': instance.cardNumberMasked,
      'expiryDate': instance.expiryDate,
      'cvvMasked': instance.cvvMasked,
      'vehicleName': instance.vehicleName,
      'vehicleTier': instance.vehicleTier,
      'vehicleImagePath': instance.vehicleImagePath,
      'baseFare': instance.baseFare,
      'serviceFee': instance.serviceFee,
      'taxes': instance.taxes,
      'grandTotal': instance.grandTotal,
      'currencySymbol': instance.currencySymbol,
    };

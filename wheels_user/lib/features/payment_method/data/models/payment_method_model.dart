import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/payment_method_entity.dart';

part 'payment_method_model.freezed.dart';
part 'payment_method_model.g.dart';

@freezed
abstract class PaymentMethodModel with _$PaymentMethodModel {
  const factory PaymentMethodModel({
    required String selectedMethod,
    required String cardNumberMasked,
    required String expiryDate,
    required String cvvMasked,
    required String vehicleName,
    required String vehicleTier,
    required String vehicleImagePath,
    required double baseFare,
    required double serviceFee,
    required double taxes,
    required double grandTotal,
    required String currencySymbol,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);
}

extension PaymentMethodModelX on PaymentMethodModel {
  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      selectedMethod: selectedMethod,
      cardNumberMasked: cardNumberMasked,
      expiryDate: expiryDate,
      cvvMasked: cvvMasked,
      vehicleName: vehicleName,
      vehicleTier: vehicleTier,
      vehicleImagePath: vehicleImagePath,
      baseFare: baseFare,
      serviceFee: serviceFee,
      taxes: taxes,
      grandTotal: grandTotal,
      currencySymbol: currencySymbol,
    );
  }
}

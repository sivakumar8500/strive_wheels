class PaymentMethodEntity {
  final String selectedMethod;
  final String cardNumberMasked;
  final String expiryDate;
  final String cvvMasked;
  final String vehicleName;
  final String vehicleTier;
  final String vehicleImagePath;
  final double baseFare;
  final double serviceFee;
  final double taxes;
  final double grandTotal;
  final String currencySymbol;

  const PaymentMethodEntity({
    required this.selectedMethod,
    required this.cardNumberMasked,
    required this.expiryDate,
    required this.cvvMasked,
    required this.vehicleName,
    required this.vehicleTier,
    required this.vehicleImagePath,
    required this.baseFare,
    required this.serviceFee,
    required this.taxes,
    required this.grandTotal,
    required this.currencySymbol,
  });
}

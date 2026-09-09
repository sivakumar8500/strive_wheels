import '../../../../core/constants/app_assets.dart';
import '../models/payment_method_model.dart';

abstract class PaymentMethodLocalDataSource {
  Future<PaymentMethodModel> getPaymentMethodDetails([String vehicleId = 'v1']);
}

class PaymentMethodLocalDataSourceImpl implements PaymentMethodLocalDataSource {
  const PaymentMethodLocalDataSourceImpl();

  @override
  Future<PaymentMethodModel> getPaymentMethodDetails([String vehicleId = 'v1']) async {
    switch (vehicleId) {
      case 'v2':
        return const PaymentMethodModel(
          selectedMethod: 'card',
          cardNumberMasked: '•••• •••• •••• 4242',
          expiryDate: 'MM/YY',
          cvvMasked: '•••',
          vehicleName: 'Force Traveler',
          vehicleTier: 'Passenger Van • Group Travel',
          vehicleImagePath: AppAssets.vehicleForceTraveler,
          baseFare: 140.00,
          serviceFee: 10.50,
          taxes: 15.20,
          grandTotal: 165.70,
          currencySymbol: '\$',
        );
      case 'v3':
        return const PaymentMethodModel(
          selectedMethod: 'card',
          cardNumberMasked: '•••• •••• •••• 4242',
          expiryDate: 'MM/YY',
          cvvMasked: '•••',
          vehicleName: 'Mini Bus',
          vehicleTier: 'Coach Class • Air Conditioned',
          vehicleImagePath: AppAssets.vehicleMiniBus,
          baseFare: 220.00,
          serviceFee: 15.00,
          taxes: 20.50,
          grandTotal: 255.50,
          currencySymbol: '\$',
        );
      case 'v4':
        return const PaymentMethodModel(
          selectedMethod: 'card',
          cardNumberMasked: '•••• •••• •••• 4242',
          expiryDate: 'MM/YY',
          cvvMasked: '•••',
          vehicleName: 'Range Rover Autobiography',
          vehicleTier: 'Ultra Luxury SUV • Private Driver',
          vehicleImagePath: AppAssets.vehicleRangeRover,
          baseFare: 280.00,
          serviceFee: 20.00,
          taxes: 25.00,
          grandTotal: 325.00,
          currencySymbol: '\$',
        );
      case 'v1':
      default:
        return const PaymentMethodModel(
          selectedMethod: 'card',
          cardNumberMasked: '•••• •••• •••• 4242',
          expiryDate: 'MM/YY',
          cvvMasked: '•••',
          vehicleName: 'Luxe S-Class',
          vehicleTier: 'Elite Tier • Premium Comfort',
          vehicleImagePath: AppAssets.vehicleMercedes,
          baseFare: 142.00,
          serviceFee: 8.50,
          taxes: 12.45,
          grandTotal: 162.95,
          currencySymbol: '\$',
        );
    }
  }
}

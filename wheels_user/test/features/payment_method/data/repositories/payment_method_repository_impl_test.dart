import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/payment_method/data/datasources/payment_method_local_datasource.dart';
import 'package:wheels_user/features/payment_method/data/models/payment_method_model.dart';
import 'package:wheels_user/features/payment_method/data/repositories/payment_method_repository_impl.dart';

class MockPaymentMethodLocalDataSource extends Mock
    implements PaymentMethodLocalDataSource {}

void main() {
  late PaymentMethodRepositoryImpl repository;
  late MockPaymentMethodLocalDataSource mockLocalDataSource;

  const tModel = PaymentMethodModel(
    selectedMethod: 'card',
    cardNumberMasked: '•••• •••• •••• 4242',
    expiryDate: 'MM/YY',
    cvvMasked: '•••',
    vehicleName: 'Luxe S-Class',
    vehicleTier: 'Elite Tier • Premium Comfort',
    vehicleImagePath: 'assets/images/vehicle_mercedes.png',
    baseFare: 142.00,
    serviceFee: 8.50,
    taxes: 12.45,
    grandTotal: 162.95,
    currencySymbol: '\$',
  );

  setUp(() {
    mockLocalDataSource = MockPaymentMethodLocalDataSource();
    repository = PaymentMethodRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test('should return PaymentMethodEntity when localDataSource returns model',
      () async {
    when(() => mockLocalDataSource.getPaymentMethodDetails(any()))
        .thenAnswer((_) async => tModel);

    final result = await repository.getPaymentMethodDetails('v1');

    expect(result.vehicleName, 'Luxe S-Class');
    verify(() => mockLocalDataSource.getPaymentMethodDetails('v1')).called(1);
  });
}

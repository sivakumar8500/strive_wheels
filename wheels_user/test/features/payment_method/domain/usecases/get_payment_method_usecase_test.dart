import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/payment_method/domain/entities/payment_method_entity.dart';
import 'package:wheels_user/features/payment_method/domain/repositories/payment_method_repository.dart';
import 'package:wheels_user/features/payment_method/domain/usecases/get_payment_method_usecase.dart';

class MockPaymentMethodRepository extends Mock
    implements PaymentMethodRepository {}

void main() {
  late GetPaymentMethodUseCase usecase;
  late MockPaymentMethodRepository mockRepository;

  const tEntity = PaymentMethodEntity(
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
    mockRepository = MockPaymentMethodRepository();
    usecase = GetPaymentMethodUseCase(mockRepository);
  });

  test('should return PaymentMethodEntity from repository', () async {
    when(() => mockRepository.getPaymentMethodDetails(any()))
        .thenAnswer((_) async => tEntity);

    final result = await usecase('v1');

    expect(result, tEntity);
    verify(() => mockRepository.getPaymentMethodDetails('v1')).called(1);
  });
}

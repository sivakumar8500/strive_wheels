import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/payment_method/domain/entities/payment_method_entity.dart';
import 'package:wheels_user/features/payment_method/domain/usecases/get_payment_method_usecase.dart';
import 'package:wheels_user/features/payment_method/presentation/bloc/payment_method_bloc.dart';
import 'package:wheels_user/features/payment_method/presentation/bloc/payment_method_event.dart';
import 'package:wheels_user/features/payment_method/presentation/bloc/payment_method_state.dart';

class MockGetPaymentMethodUseCase extends Mock
    implements GetPaymentMethodUseCase {}

void main() {
  late PaymentMethodBloc bloc;
  late MockGetPaymentMethodUseCase mockGetPaymentMethodUseCase;

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
    mockGetPaymentMethodUseCase = MockGetPaymentMethodUseCase();
    bloc = PaymentMethodBloc(getPaymentMethodUseCase: mockGetPaymentMethodUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is PaymentMethodState with isLoading true', () {
    expect(bloc.state.isLoading, isTrue);
  });

  blocTest<PaymentMethodBloc, PaymentMethodState>(
    'emits [isLoading true, isLoading false with paymentDetails] on LoadPaymentMethodEvent',
    build: () {
      when(() => mockGetPaymentMethodUseCase(any())).thenAnswer((_) async => tEntity);
      return bloc;
    },
    act: (PaymentMethodBloc b) => b.add(const LoadPaymentMethodEvent('v1')),
    expect: () => [
      isA<PaymentMethodState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<PaymentMethodState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.paymentDetails, 'paymentDetails', tEntity),
    ],
  );

  blocTest<PaymentMethodBloc, PaymentMethodState>(
    'updates selectedMethod on SelectPaymentOptionEvent',
    build: () => bloc,
    act: (PaymentMethodBloc b) => b.add(const SelectPaymentOptionEvent('upi')),
    expect: () => [
      isA<PaymentMethodState>()
          .having((s) => s.selectedMethod, 'selectedMethod', 'upi'),
    ],
  );

  blocTest<PaymentMethodBloc, PaymentMethodState>(
    'emits isPaymentSuccess true on SubmitPaymentEvent',
    build: () => bloc,
    act: (PaymentMethodBloc b) => b.add(const SubmitPaymentEvent()),
    expect: () => [
      isA<PaymentMethodState>()
          .having((s) => s.isPaymentSuccess, 'isPaymentSuccess', isTrue),
    ],
  );
}

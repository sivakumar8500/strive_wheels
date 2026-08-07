import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/payment_method/domain/entities/payment_method_entity.dart';
import 'package:wheels_user/features/payment_method/presentation/bloc/payment_method_bloc.dart';
import 'package:wheels_user/features/payment_method/presentation/bloc/payment_method_event.dart';
import 'package:wheels_user/features/payment_method/presentation/bloc/payment_method_state.dart';
import 'package:wheels_user/features/payment_method/presentation/pages/payment_method_page.dart';

class MockPaymentMethodBloc
    extends MockBloc<PaymentMethodEvent, PaymentMethodState>
    implements PaymentMethodBloc {}

void main() {
  late MockPaymentMethodBloc mockBloc;

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

  setUpAll(() {
    registerFallbackValue(const LoadPaymentMethodEvent('v1'));
    registerFallbackValue(const SubmitPaymentEvent());
  });

  setUp(() {
    mockBloc = MockPaymentMethodBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<PaymentMethodBloc>.value(
        value: mockBloc,
        child: const PaymentMethodPage(),
      ),
    );
  }

  testWidgets('renders Payment Method options, security card, ride summary, and Pay button',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const PaymentMethodState(
      isLoading: false,
      paymentDetails: tEntity,
      selectedMethod: 'card',
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Payment Method'), findsOneWidget);
    expect(find.text('Apple Pay'), findsOneWidget);
    expect(find.text('UPI'), findsOneWidget);
    expect(find.text('Credit or Debit Card'), findsOneWidget);
    expect(find.text('SSL Secure Connection'), findsOneWidget);
    expect(find.text('Luxe S-Class'), findsOneWidget);
    expect(find.text('\$162.95'), findsOneWidget);
    expect(find.text('Pay & Confirm Ride'), findsOneWidget);
  });

  testWidgets('tapping Pay & Confirm Ride button fires SubmitPaymentEvent',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const PaymentMethodState(
      isLoading: false,
      paymentDetails: tEntity,
      selectedMethod: 'card',
    ));

    await tester.pumpWidget(buildTestWidget());

    final payButton = find.text('Pay & Confirm Ride');
    await tester.ensureVisible(payButton);
    await tester.tap(payButton);
    await tester.pump();

    verify(() => mockBloc.add(const SubmitPaymentEvent())).called(1);
  });
}

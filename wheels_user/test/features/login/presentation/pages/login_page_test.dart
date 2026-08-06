import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/core/di/injection_container.dart';
import 'package:wheels_user/features/login/presentation/bloc/login_bloc.dart';
import 'package:wheels_user/features/login/presentation/bloc/login_event.dart';
import 'package:wheels_user/features/login/presentation/bloc/login_state.dart';
import 'package:wheels_user/features/login/presentation/pages/login_page.dart';
import 'package:wheels_user/features/otp/presentation/bloc/otp_bloc.dart';
import 'package:wheels_user/features/otp/presentation/bloc/otp_event.dart';
import 'package:wheels_user/features/otp/presentation/bloc/otp_state.dart';
import 'package:wheels_user/features/otp/presentation/pages/otp_verification_page.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockOtpBloc extends MockBloc<OtpEvent, OtpState> implements OtpBloc {}

void main() {
  late MockLoginBloc mockLoginBloc;
  late MockOtpBloc mockOtpBloc;

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    mockOtpBloc = MockOtpBloc();

    if (!sl.isRegistered<OtpBloc>()) {
      sl.registerFactoryParam<OtpBloc, String, dynamic>(
        (param1, _) => mockOtpBloc,
      );
    }

    when(() => mockOtpBloc.state).thenReturn(
      const OtpState(fullPhoneNumber: '+919876543210'),
    );
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<LoginBloc>.value(
        value: mockLoginBloc,
        child: const LoginPage(),
      ),
    );
  }

  testWidgets('LoginPage renders title, subtitle, input field, and button',
      (WidgetTester tester) async {
    when(() => mockLoginBloc.state).thenReturn(const LoginState());

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Book rides in seconds.'), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(
      find.byWidgetPredicate((widget) =>
          widget is RichText &&
          widget.text.toPlainText().contains('Terms & Conditions')),
      findsOneWidget,
    );
  });

  testWidgets('entering phone number triggers PhoneNumberChangedEvent',
      (WidgetTester tester) async {
    when(() => mockLoginBloc.state).thenReturn(const LoginState());

    await tester.pumpWidget(buildTestableWidget());

    await tester.enterText(find.byType(TextField), '9876543210');
    verify(() => mockLoginBloc.add(const PhoneNumberChangedEvent('9876543210')))
        .called(1);
  });

  testWidgets('tapping Continue button triggers SubmitLoginEvent when enabled',
      (WidgetTester tester) async {
    when(() => mockLoginBloc.state).thenReturn(
      const LoginState(
        phoneNumber: '9876543210',
        isPhoneNumberValid: true,
      ),
    );

    await tester.pumpWidget(buildTestableWidget());

    await tester.tap(find.text('Continue'));
    verify(() => mockLoginBloc.add(const SubmitLoginEvent())).called(1);
  });

  testWidgets('navigates to OtpVerificationPage on login success',
      (WidgetTester tester) async {
    whenListen(
      mockLoginBloc,
      Stream.fromIterable([
        const LoginState(
          countryCode: '+91',
          phoneNumber: '9876543210',
          isSuccess: true,
        ),
      ]),
      initialState: const LoginState(),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(OtpVerificationPage), findsOneWidget);
  });
}

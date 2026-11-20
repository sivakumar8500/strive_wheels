import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/core/di/injection_container.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_event.dart';
import 'package:wheels_user/features/notifications/presentation/bloc/notification_state.dart';
import 'package:wheels_user/features/notifications/presentation/pages/notification_permission_page.dart';
import 'package:wheels_user/features/otp/presentation/bloc/otp_bloc.dart';
import 'package:wheels_user/features/otp/presentation/bloc/otp_event.dart';
import 'package:wheels_user/features/otp/presentation/bloc/otp_state.dart';
import 'package:wheels_user/features/otp/presentation/pages/otp_verification_page.dart';

class MockOtpBloc extends MockBloc<OtpEvent, OtpState> implements OtpBloc {}

class MockNotificationBloc
    extends MockBloc<NotificationEvent, NotificationState>
    implements NotificationBloc {}

void main() {
  late MockOtpBloc mockOtpBloc;
  late MockNotificationBloc mockNotificationBloc;

  setUp(() {
    mockOtpBloc = MockOtpBloc();
    mockNotificationBloc = MockNotificationBloc();

    if (!sl.isRegistered<NotificationBloc>()) {
      sl.registerFactory<NotificationBloc>(() => mockNotificationBloc);
    }

    when(() => mockNotificationBloc.state)
        .thenReturn(const NotificationState());
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<OtpBloc>.value(
        value: mockOtpBloc,
        child: const OtpVerificationPage(),
      ),
    );
  }

  testWidgets('OtpVerificationPage renders title, phone number, resend timer, and Verify button',
      (WidgetTester tester) async {
    when(() => mockOtpBloc.state).thenReturn(
      const OtpState(fullPhoneNumber: '+919876543210', countdownSeconds: 11),
    );

    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Verify Your Number'), findsOneWidget);
    expect(find.text("We've sent a verification code to"), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('+91 98765 43210')), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('Edit')), findsOneWidget);
    expect(find.text('00:11'), findsOneWidget);
    expect(find.text('Resend Code'), findsOneWidget);
    expect(find.text('Verify'), findsOneWidget);
  });

  testWidgets('tapping Edit pops current page', (WidgetTester tester) async {
    when(() => mockOtpBloc.state).thenReturn(
      const OtpState(fullPhoneNumber: '+919876543210'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<OtpBloc>.value(
                      value: mockOtpBloc,
                      child: const OtpVerificationPage(),
                    ),
                  ),
                );
              },
              child: const Text('Push'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Push'));
    await tester.pumpAndSettle();

    expect(find.text('Verify Your Number'), findsOneWidget);

    final richTextFinder = find.byWidgetPredicate(
      (w) => w is RichText && w.text.toPlainText().contains('Edit'),
    );
    final richText = tester.widget<RichText>(richTextFinder.first);
    final textSpan = richText.text as TextSpan;
    final editSpan = textSpan.children!.last as TextSpan;
    (editSpan.recognizer as TapGestureRecognizer).onTap!();
    await tester.pumpAndSettle();

    expect(find.text('Push'), findsOneWidget);
  });

  testWidgets('navigates to NotificationPermissionPage on OTP verification success',
      (WidgetTester tester) async {
    whenListen(
      mockOtpBloc,
      Stream.fromIterable([
        const OtpState(fullPhoneNumber: '+919876543210', isSuccess: true),
      ]),
      initialState: const OtpState(fullPhoneNumber: '+919876543210'),
    );

    await tester.pumpWidget(buildTestableWidget());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(NotificationPermissionPage), findsOneWidget);
  });
}

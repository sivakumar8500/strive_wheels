import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/constants/app_strings.dart';
import 'package:wheels_rider/core/di/injection_container.dart' as di;
import 'package:wheels_rider/features/auth/presentation/bloc/login_bloc.dart';
import 'package:wheels_rider/features/auth/presentation/bloc/login_event.dart';
import 'package:wheels_rider/features/auth/presentation/bloc/login_state.dart';
import 'package:wheels_rider/features/auth/presentation/pages/login_page.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

void main() {
  late MockLoginBloc mockLoginBloc;

  setUpAll(() {
    di.sl.allowReassignment = true;
  });

  setUp(() {
    mockLoginBloc = MockLoginBloc();
    di.sl.registerFactory<LoginBloc>(() => mockLoginBloc);
    when(() => mockLoginBloc.state).thenReturn(const LoginInitial());
  });

  tearDown(() {
    di.sl.reset();
  });

  Widget buildWidget() {
    return const MaterialApp(
      home: LoginPage(),
    );
  }

  testWidgets('LoginPage renders correctly with initial disabled continue button',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget());

    expect(find.text(AppStrings.welcomeBack), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('Entering 10 digits enables continue button without losing focus or clearing',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildWidget());

    final textField = find.byType(TextField);
    await tester.enterText(textField, '9876543210');
    await tester.pumpAndSettle();

    expect(find.text('9876543210'), findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });
}

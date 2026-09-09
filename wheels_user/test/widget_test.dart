import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_user/core/constants/app_strings.dart';
import 'package:wheels_user/core/di/injection_container.dart';
import 'package:wheels_user/main.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
  });

  testWidgets('App first time launch displays OnboardingPage',
      (WidgetTester tester) async {
    await initDependencyInjection();
    await tester.pumpWidget(const WheelsUserApp());
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);
  });

  testWidgets('App subsequent launch displays SplashPage and navigates to AuthPage',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'is_first_time_launch': false});
    await initDependencyInjection();
    await tester.pumpWidget(const WheelsUserApp());
    expect(find.text(AppStrings.appName), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.welcomeBack), findsOneWidget);
  });
}

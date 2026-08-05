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
    await tester.pumpWidget(const WheelsUserApp(isFirstTime: true));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.onboardingTitle1), findsOneWidget);
  });

  testWidgets('App subsequent launch displays SplashPage',
      (WidgetTester tester) async {
    await initDependencyInjection();
    await tester.pumpWidget(const WheelsUserApp(isFirstTime: false));
    expect(find.text(AppStrings.appName), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}

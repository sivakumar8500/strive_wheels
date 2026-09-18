import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_user/core/di/injection_container.dart';
import 'package:wheels_user/main.dart';
import 'package:wheels_user/features/splash/presentation/pages/splash_page.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await sl.reset();
  });

  testWidgets('App launch displays SplashPage with app name',
      (WidgetTester tester) async {
    await initDependencyInjection();
    await tester.pumpWidget(const WheelsUserApp());
    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text('Wheels'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });
}

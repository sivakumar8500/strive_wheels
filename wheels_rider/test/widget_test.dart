import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/core/constants/app_strings.dart';
import 'package:wheels_rider/core/di/injection_container.dart';
import 'package:wheels_rider/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('WheelsRiderApp launches splash screen', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await initDependencyInjection();

    await tester.pumpWidget(const WheelsRiderApp());
    expect(find.text(AppStrings.appName), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/constants/app_strings.dart';
import 'package:wheels_user/core/di/injection_container.dart';
import 'package:wheels_user/main.dart';

void main() {
  testWidgets('App main smoke test', (WidgetTester tester) async {
    await initDependencyInjection();
    await tester.pumpWidget(const WheelsUserApp());
    expect(find.text(AppStrings.appName), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });
}

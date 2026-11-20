import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/features/driver_search/presentation/widgets/safety_feature_carousel_widget.dart';

void main() {
  Widget buildTestWidget() {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SafetyFeatureCarouselWidget(),
        ),
      ),
    );
  }

  testWidgets('SafetyFeatureCarouselWidget renders carousel items and auto scrolls',
      (tester) async {
    await tester.pumpWidget(buildTestWidget());

    // First card should be visible
    expect(find.text('100% Verified Captains'), findsOneWidget);
    expect(find.text('SAFETY FIRST'), findsOneWidget);

    // Auto scroll after duration
    await tester.pump(const Duration(milliseconds: 3900));
    await tester.pumpAndSettle();

    // Second card should be visible
    expect(find.text('Live GPS & Emergency SOS'), findsOneWidget);
    expect(find.text('24x7 MONITORING'), findsOneWidget);

    // Next card
    await tester.pump(const Duration(milliseconds: 3900));
    await tester.pumpAndSettle();
    expect(find.text('Clean & Sanitized Fleet'), findsOneWidget);

    // 4th card
    await tester.pump(const Duration(milliseconds: 3900));
    await tester.pumpAndSettle();
    expect(find.text('Guaranteed Upfront Pricing'), findsOneWidget);
  });
}

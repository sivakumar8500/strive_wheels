import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/widgets/live_journey_progress_bar.dart';

void main() {
  Widget createWidgetUnderTest({
    required String statusText,
    required String etaText,
    String? badgeText,
    double progressPercent = 0.45,
    String? startLocation,
    String? dropLocation,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: LiveJourneyProgressBar(
          statusText: statusText,
          etaText: etaText,
          badgeText: badgeText,
          progressPercent: progressPercent,
          startLocation: startLocation,
          dropLocation: dropLocation,
        ),
      ),
    );
  }

  testWidgets('LiveJourneyProgressBar renders status, eta, badge, and route locations', (tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(
        statusText: 'Driver arriving',
        etaText: '12 min',
        badgeText: 'T 4032',
        progressPercent: 0.45,
        startLocation: '245 Market St',
        dropLocation: 'SFO Airport',
      ),
    );

    expect(find.text('Driver arriving'), findsOneWidget);
    expect(find.text('12 min'), findsOneWidget);
    expect(find.text('T 4032'), findsOneWidget);
    expect(find.text('245 Market St'), findsOneWidget);
    expect(find.text('SFO Airport'), findsOneWidget);
  });
}

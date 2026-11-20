import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/core/widgets/live_journey_progress_bar.dart';

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
        statusText: 'Driving to Drop',
        etaText: '8 min',
        badgeText: 'TRIP',
        progressPercent: 0.60,
        startLocation: 'Banjara Hills',
        dropLocation: 'Hitec City',
      ),
    );

    expect(find.text('Driving to Drop'), findsOneWidget);
    expect(find.text('8 min'), findsOneWidget);
    expect(find.text('TRIP'), findsOneWidget);
    expect(find.text('Banjara Hills'), findsOneWidget);
    expect(find.text('Hitec City'), findsOneWidget);
  });
}

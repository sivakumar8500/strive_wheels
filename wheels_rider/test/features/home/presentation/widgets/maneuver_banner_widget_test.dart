import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wheels_rider/core/services/navigation_service.dart';
import 'package:wheels_rider/features/home/presentation/widgets/maneuver_banner_widget.dart';

void main() {
  testWidgets('ManeuverBannerWidget renders turn instruction, distance, and road name', (tester) async {
    bool overviewTapped = false;
    bool muteTapped = false;

    const step = NavigationStep(
      instruction: 'Turn left onto Market St',
      roadName: 'Market St',
      distanceMeters: 350.0,
      durationSeconds: 30.0,
      maneuverType: ManeuverType.turnLeft,
      location: LatLng(17.4126, 78.3498),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ManeuverBannerWidget(
            currentStep: step,
            distanceToStepMeters: 350.0,
            isMuted: false,
            onToggleMute: () => muteTapped = true,
            onOverviewTap: () => overviewTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('350 m'), findsOneWidget);
    expect(find.text('Market St'), findsOneWidget);
    expect(find.text('Turn left onto Market St'), findsOneWidget);
    expect(find.byIcon(Icons.turn_left_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.map_rounded));
    expect(overviewTapped, isTrue);

    await tester.tap(find.byIcon(Icons.volume_up_rounded));
    expect(muteTapped, isTrue);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wheels_user/core/services/navigation_service.dart';
import 'package:wheels_user/features/booking/presentation/widgets/maneuver_banner_widget.dart';

void main() {
  Widget buildWidget({
    NavigationStep? currentStep,
    double distanceToStepMeters = 250.0,
    bool isMuted = true,
    VoidCallback? onToggleMute,
    VoidCallback? onOverviewTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ManeuverBannerWidget(
          currentStep: currentStep,
          distanceToStepMeters: distanceToStepMeters,
          isMuted: isMuted,
          onToggleMute: onToggleMute ?? () {},
          onOverviewTap: onOverviewTap ?? () {},
        ),
      ),
    );
  }

  group('ManeuverBannerWidget Tests', () {
    testWidgets('renders fallback text when currentStep is null', (tester) async {
      await tester.pumpWidget(buildWidget(currentStep: null));

      expect(find.text('250 m'), findsOneWidget);
      expect(find.text('Head towards destination'), findsOneWidget);
      expect(find.text('Follow highlighted route'), findsOneWidget);
      expect(find.byIcon(Icons.straight_rounded), findsOneWidget);
    });

    testWidgets('renders turn left step with correct distance and road name', (tester) async {
      const step = NavigationStep(
        instruction: 'Turn left onto Market St',
        roadName: 'Market St',
        distanceMeters: 120,
        durationSeconds: 15,
        maneuverType: ManeuverType.turnLeft,
        location: LatLng(17.412, 78.349),
      );

      await tester.pumpWidget(buildWidget(
        currentStep: step,
        distanceToStepMeters: 120,
      ));

      expect(find.text('120 m'), findsOneWidget);
      expect(find.text('Market St'), findsOneWidget);
      expect(find.text('Turn left onto Market St'), findsOneWidget);
      expect(find.byIcon(Icons.turn_left_rounded), findsOneWidget);
    });

    testWidgets('formats kilometer distance correctly for > 1000m', (tester) async {
      const step = NavigationStep(
        instruction: 'Continue straight onto Main Expressway',
        roadName: 'Main Expressway',
        distanceMeters: 2400,
        durationSeconds: 120,
        maneuverType: ManeuverType.straight,
        location: LatLng(17.412, 78.349),
      );

      await tester.pumpWidget(buildWidget(
        currentStep: step,
        distanceToStepMeters: 2400,
      ));

      expect(find.text('2.4 km'), findsOneWidget);
      expect(find.text('Main Expressway'), findsOneWidget);
    });
  });
}

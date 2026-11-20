import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/features/home/presentation/widgets/navigation_bottom_panel_widget.dart';

void main() {
  testWidgets('NavigationBottomPanelWidget renders ETA, address, and action button', (tester) async {
    bool actionTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NavigationBottomPanelWidget(
            remainingMins: 14,
            remainingKm: 3.8,
            arrivalEta: '10:45 AM',
            destinationAddress: 'Gachibowli Flyover, Hyderabad',
            pickupAddress: 'Hitech City Metro, Hyderabad',
            isTripStarted: false,
            isLoading: false,
            onMainActionTap: () => actionTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('14 min'), findsOneWidget);
    expect(find.text('3.8 km'), findsOneWidget);
    expect(find.text('ETA 10:45 AM'), findsOneWidget);
    expect(find.text('Hitech City Metro, Hyderabad'), findsOneWidget);
    expect(find.text('ARRIVED AT PICKUP'), findsOneWidget);

    await tester.tap(find.text('ARRIVED AT PICKUP'));
    expect(actionTapped, isTrue);
  });

  testWidgets('NavigationBottomPanelWidget renders CANCEL RIDE button when onCancelRide is provided', (tester) async {
    bool cancelTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NavigationBottomPanelWidget(
            remainingMins: 14,
            remainingKm: 3.8,
            arrivalEta: '10:45 AM',
            destinationAddress: 'Gachibowli Flyover, Hyderabad',
            pickupAddress: 'Hitech City Metro, Hyderabad',
            isTripStarted: true,
            isLoading: false,
            onMainActionTap: () {},
            onRequestDrop: () {},
            onCancelRide: () => cancelTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('REQUEST DROP'), findsOneWidget);
    expect(find.text('CANCEL RIDE'), findsOneWidget);
    expect(find.text('COMPLETE TRIP'), findsOneWidget);

    await tester.tap(find.text('CANCEL RIDE'));
    expect(cancelTapped, isTrue);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wheels_user/features/booking/presentation/pages/map_location_picker_page.dart';

void main() {
  Widget buildTestWidget({
    bool isPickup = false,
    String? initialAddress,
    LatLng initialLatLng = const LatLng(17.4483, 78.3915),
  }) {
    return MaterialApp(
      home: MapLocationPickerPage(
        isPickup: isPickup,
        initialAddress: initialAddress,
        initialLatLng: initialLatLng,
      ),
    );
  }

  testWidgets('renders MapLocationPickerPage for Drop location with center pin, address and confirm button', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      isPickup: false,
      initialAddress: 'Mindspace IT Park, Hitech City, Hyderabad',
    ));

    expect(find.text('Set Drop Location'), findsOneWidget);
    expect(find.text('DROP HERE'), findsOneWidget);
    expect(find.text('CHOOSE DROP POINT'), findsOneWidget);
    expect(find.text('Confirm Drop Location'), findsOneWidget);
    expect(find.byKey(const Key('confirm_map_location_button')), findsOneWidget);
    expect(find.byKey(const Key('map_picker_locate_me_button')), findsOneWidget);
    expect(find.byKey(const Key('map_picker_back_button')), findsOneWidget);
  });

  testWidgets('renders MapLocationPickerPage for Pickup location with pickup text and confirm button', (tester) async {
    await tester.pumpWidget(buildTestWidget(
      isPickup: true,
      initialAddress: '604, Venkataramana Colony, KPHB',
    ));

    expect(find.text('Set Pickup Location'), findsOneWidget);
    expect(find.text('PICKUP HERE'), findsOneWidget);
    expect(find.text('CHOOSE PICKUP POINT'), findsOneWidget);
    expect(find.text('Confirm Pickup Location'), findsOneWidget);
  });

  testWidgets('tapping confirm location button pops with selected location result', (tester) async {
    Map<String, dynamic>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                result = await Navigator.of(context).push<Map<String, dynamic>>(
                  MaterialPageRoute(
                    builder: (_) => const MapLocationPickerPage(
                      isPickup: true,
                      initialAddress: 'Mindspace Building 5, Hyderabad',
                      initialLatLng: LatLng(17.4483, 78.3915),
                    ),
                  ),
                );
              },
              child: const Text('Open Picker'),
            );
          },
        ),
      ),
    );

    // Open Picker
    await tester.tap(find.text('Open Picker'));
    await tester.pumpAndSettle();

    // Tap confirm button
    await tester.tap(find.byKey(const Key('confirm_map_location_button')));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result?['address'], 'Mindspace Building 5, Hyderabad');
    expect(result?['latLng'], const LatLng(17.4483, 78.3915));
  });
}

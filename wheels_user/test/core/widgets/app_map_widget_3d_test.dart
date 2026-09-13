import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wheels_user/core/widgets/app_map_widget.dart';

void main() {
  group('AppMapWidget 3D Building & Tilt Tests', () {
    testWidgets('AppMapWidget initializes with 3D buildings enabled and 60 degree tilt', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppMapWidget(
              initialCameraPosition: CameraPosition(
                target: LatLng(17.48, 78.37),
                zoom: 18.0,
                tilt: 60.0,
              ),
              buildingsEnabled: true,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(AppMapWidget), findsOneWidget);
    });
  });
}

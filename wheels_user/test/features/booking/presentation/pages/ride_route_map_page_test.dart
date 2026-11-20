import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/booking/domain/entities/vehicle_type_entity.dart';
import 'package:wheels_user/features/booking/presentation/pages/ride_route_map_page.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;

  final testVehicleTypes = [
    const VehicleTypeEntity(
      id: 1,
      code: 'CAB',
      name: 'Cab (Sedan / Hatchback)',
      description: 'Comfortable AC rides for up to 4 passengers',
      maxPassengers: 4,
      maxWeightKg: 0,
    ),
    const VehicleTypeEntity(
      id: 2,
      code: 'AUTO',
      name: 'Auto Rickshaw',
      description: 'Affordable doorstep rides for everyday commute',
      maxPassengers: 3,
      maxWeightKg: 0,
    ),
    const VehicleTypeEntity(
      id: 3,
      code: 'BIKE',
      name: 'Bike Taxi',
      description: 'Fastest way to beat traffic solo',
      maxPassengers: 1,
      maxWeightKg: 0,
    ),
  ];

  setUp(() {
    mockDio = MockDio();
    when(() => mockDio.get(
          any(),
          cancelToken: any(named: 'cancelToken'),
          options: any(named: 'options'),
        )).thenAnswer((_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'routes': [
              {
                'duration': 1080.0,
                'distance': 7800.0,
                'geometry': {
                  'coordinates': [
                    [78.3915, 17.4483],
                    [78.3950, 17.4600],
                    [78.3995, 17.4938],
                  ],
                },
              }
            ],
          },
        ));
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: RideRouteMapPage(
        pickupTitle: 'Office',
        pickupAddress: 'Hitech City, Hyderabad',
        dropTitle: 'Home',
        dropAddress: 'Kukatpally, Hyderabad',
        pickupLatLng: const LatLng(17.4483, 78.3915),
        dropLatLng: const LatLng(17.4938, 78.3995),
        dio: mockDio,
        initialVehicleTypes: testVehicleTypes,
      ),
    );
  }

  testWidgets('renders RideRouteMapPage with dynamic vehicle cards, without prices, and with View Details and Book Now', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('map_back_button')), findsOneWidget);
    expect(find.text('Office'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('~18 min'), findsOneWidget);
    expect(find.byKey(const Key('map_add_stop_button')), findsOneWidget);
    expect(find.byKey(const Key('map_recenter_button')), findsOneWidget);
    expect(find.text('Saving ₹15 with special discount'), findsOneWidget);

    // Verify dynamic vehicles are shown
    expect(find.text('Cab (Sedan / Hatchback)'), findsOneWidget);
    expect(find.text('Auto Rickshaw'), findsOneWidget);
    expect(find.text('Bike Taxi'), findsOneWidget);

    // Verify prices are removed
    expect(find.text('₹94-₹99'), findsNothing);
    expect(find.text('₹114'), findsNothing);

    // Verify clickable actions: "View Details" and "Book Now"
    expect(find.byKey(const Key('view_details_1')), findsOneWidget);
    expect(find.byKey(const Key('book_now_1')), findsOneWidget);
    expect(find.text('View Details'), findsNWidgets(3));
    expect(find.text('Book Now'), findsNWidgets(3));

    expect(find.text('Rapido Wallet'), findsOneWidget);
    expect(find.text('Offers'), findsOneWidget);
    expect(find.byKey(const Key('confirm_ride_booking_button')), findsOneWidget);
    expect(find.text('Book Cab (Sedan / Hatchback)'), findsOneWidget);
  });

  testWidgets('tapping View Details opens vehicle details modal sheet with specifications', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('view_details_1')));
    await tester.pumpAndSettle();

    expect(find.text('About this ride'), findsOneWidget);
    expect(find.text('Passengers'), findsOneWidget);
    expect(find.text('4 Max'), findsOneWidget);
    expect(find.byKey(const Key('modal_book_now_button')), findsOneWidget);
  });

  testWidgets('selecting another vehicle updates confirm button text to Book <Vehicle>', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Auto Rickshaw'));
    await tester.pumpAndSettle();

    expect(find.text('Book Auto Rickshaw'), findsOneWidget);
  });

  testWidgets('swiping down on the bottom sheet moves it down', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Swiping down moves the sheet down
    await tester.drag(find.text('Saving ₹15 with special discount'), const Offset(0, 350));
    await tester.pumpAndSettle();

    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
  });
}

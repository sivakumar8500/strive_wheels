import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/booking/domain/entities/corporate_aligned_vehicle_entity.dart';
import 'package:wheels_user/features/booking/domain/entities/vehicle_type_entity.dart';
import 'package:wheels_user/features/booking/domain/usecases/get_corporate_aligned_vehicles_usecase.dart';
import 'package:wheels_user/features/booking/presentation/pages/ride_route_map_page.dart';

class MockDio extends Mock implements Dio {}
class MockGetCorporateAlignedVehiclesUseCase extends Mock implements GetCorporateAlignedVehiclesUseCase {}

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
    expect(find.byKey(const Key('street_view_mode_button')), findsOneWidget);
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

  testWidgets('Corporate Mode shows ONLY company attached vehicles and specific route, hiding standard vehicles', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final mockCorpUseCase = MockGetCorporateAlignedVehiclesUseCase();
    const testCorpVehicle = CorporateAlignedVehicleEntity(
      id: 101,
      companyId: 5,
      riderId: 20,
      vehicleId: 30,
      driverName: 'Corporate Driver Ramesh',
      vehicleName: 'Toyota Etios',
      licensePlate: 'TS09CORP01',
      vehicleTypeId: 1,
      vehicleTypeName: 'Cab',
      routeFrom: 'KPHB Colony',
      routeTo: 'Mindspace Tech Park',
      isAligned: true,
      alignmentLabel: 'Direct Route: KPHB Colony ➔ Mindspace Tech Park',
      seats: 4,
      availableSeats: 3,
      occupiedSeats: 1,
      availableSeatNumbers: [1, 2, 4],
    );

    when(() => mockCorpUseCase.call(
          pickupLat: any(named: 'pickupLat'),
          pickupLng: any(named: 'pickupLng'),
          dropAddress: any(named: 'dropAddress'),
          pickupAddress: any(named: 'pickupAddress'),
          dropLat: any(named: 'dropLat'),
          dropLng: any(named: 'dropLng'),
          companyId: any(named: 'companyId'),
        )).thenAnswer((_) async => [testCorpVehicle]);

    await tester.pumpWidget(
      MaterialApp(
        home: RideRouteMapPage(
          pickupTitle: 'KPHB Colony',
          pickupAddress: 'KPHB Colony, Hyderabad',
          dropTitle: 'Mindspace',
          dropAddress: 'Mindspace Tech Park, Hyderabad',
          pickupLatLng: const LatLng(17.4938, 78.3995),
          dropLatLng: const LatLng(17.4483, 78.3915),
          dio: mockDio,
          isCorporate: true,
          initialVehicleTypes: testVehicleTypes,
          getCorporateAlignedVehiclesUseCase: mockCorpUseCase,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Corporate banner and route aligned badge are shown
    expect(find.text('Route Aligned'), findsOneWidget);
    expect(find.text('Company Attached Vehicles'), findsOneWidget);
    expect(find.text('1 on Route'), findsOneWidget);

    // Verify SPECIFIC ROUTE is prominently shown on the corporate vehicle card
    expect(find.textContaining('KPHB Colony'), findsWidgets);
    expect(find.textContaining('Mindspace Tech Park'), findsWidgets);
    expect(find.text('Toyota Etios • TS09CORP01'), findsOneWidget);
    expect(find.text('Corporate Driver Ramesh'), findsOneWidget);
    expect(find.text('3/4 Seats Free'), findsOneWidget);

    // Verify standard commercial vehicles are HIDDEN in corporate mode
    expect(find.text('Auto Rickshaw'), findsNothing);
    expect(find.text('Bike Taxi'), findsNothing);
    expect(find.text('Rapido Wallet'), findsNothing);
    expect(find.text('Offers'), findsNothing);
    expect(find.byKey(const Key('confirm_ride_booking_button')), findsNothing);

    // Verify Corporate Action Button
    expect(find.byKey(const Key('confirm_corporate_ride_booking_button')), findsOneWidget);
    expect(find.textContaining('Book Route • Seat #'), findsOneWidget);
  });

  testWidgets('One-Way and Round-Trip modes show ONLY Car/Cab vehicles', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: RideRouteMapPage(
          pickupTitle: 'Office',
          pickupAddress: 'Hitech City, Hyderabad',
          dropTitle: 'Home',
          dropAddress: 'Kukatpally, Hyderabad',
          pickupLatLng: const LatLng(17.4483, 78.3915),
          dropLatLng: const LatLng(17.4938, 78.3995),
          bookingMode: 'ONE_WAY',
          dio: mockDio,
          initialVehicleTypes: testVehicleTypes,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Car/Cab is shown
    expect(find.text('Cab (Sedan / Hatchback)'), findsOneWidget);

    // Verify Bike and Auto are HIDDEN in ONE_WAY mode
    expect(find.text('Auto Rickshaw'), findsNothing);
    expect(find.text('Bike Taxi'), findsNothing);
  });
}

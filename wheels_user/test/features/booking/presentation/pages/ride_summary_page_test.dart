import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wheels_user/core/di/injection_container.dart';
import 'package:wheels_user/features/booking/domain/entities/fare_estimate_entity.dart';
import 'package:wheels_user/features/booking/domain/entities/vehicle_type_entity.dart';
import 'package:wheels_user/features/booking/domain/usecases/get_fare_estimate_usecase.dart';
import 'package:wheels_user/features/booking/presentation/pages/ride_summary_page.dart';

class MockGetFareEstimateUseCase extends Mock implements GetFareEstimateUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockGetFareEstimateUseCase mockFareUseCase;

  const cabVehicle = VehicleTypeEntity(
    id: 1,
    code: 'CAB',
    name: 'Cab (Sedan / Hatchback)',
    description: 'Up to 4 passengers',
    maxPassengers: 4,
    maxWeightKg: 0,
  );

  const bikeVehicle = VehicleTypeEntity(
    id: 2,
    code: 'BIKE',
    name: 'Bike Taxi',
    description: 'Solo ride',
    maxPassengers: 1,
    maxWeightKg: 0,
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    if (!sl.isRegistered<SharedPreferences>()) {
      sl.registerSingleton<SharedPreferences>(prefs);
    }
    mockFareUseCase = MockGetFareEstimateUseCase();
    when(() => mockFareUseCase.call(
          vehicleTypeId: any(named: 'vehicleTypeId'),
          pickupLat: any(named: 'pickupLat'),
          pickupLng: any(named: 'pickupLng'),
          dropLat: any(named: 'dropLat'),
          dropLng: any(named: 'dropLng'),
          distanceKm: any(named: 'distanceKm'),
          durationMins: any(named: 'durationMins'),
          serviceMode: any(named: 'serviceMode'),
          bookingMode: any(named: 'bookingMode'),
          tripType: any(named: 'tripType'),
          couponCode: any(named: 'couponCode'),
          isAc: any(named: 'isAc'),
          isOutstation: any(named: 'isOutstation'),
          vehicleAgeYears: any(named: 'vehicleAgeYears'),
          weather: any(named: 'weather'),
          trafficLevel: any(named: 'trafficLevel'),
          companyId: any(named: 'companyId'),
        )).thenAnswer((_) async => const FareEstimateEntity(
          serviceMode: 'NORMAL',
          vehicleTypeId: 1,
          estimatedDistanceKm: 39.3,
          estimatedDurationMins: 35,
          baseFare: 50,
          distanceCharge: 590,
          timeCharge: 70,
          waitingCharge: 0,
          discountAmount: 0,
          surgeMultiplier: 1.0,
          estimatedFare: 710,
        ));
    if (!sl.isRegistered<GetFareEstimateUseCase>()) {
      sl.registerSingleton<GetFareEstimateUseCase>(mockFareUseCase);
    }
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets(
      'bottom card shows halting, driver beta, allowance, and tolls ONLY for Car in ONE_WAY / ROUND_TRIP',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: RideSummaryPage(
          pickupTitle: 'Pickup',
          pickupAddress: 'Pickup Address',
          dropTitle: 'Drop',
          dropAddress: 'Drop Address',
          pickupLatLng: LatLng(17.4483, 78.3915),
          dropLatLng: LatLng(17.4938, 78.3995),
          selectedVehicle: cabVehicle,
          bookingMode: 'ONE_WAY',
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Verify outstation terms for Car on ONE_WAY trip are shown
    expect(find.text('Take number halting (per day 3 free)'), findsOneWidget);
    expect(find.text('Driver beta'), findsOneWidget);
    expect(find.text('Driver alwence'), findsOneWidget);
    expect(find.text('Toll charges'), findsOneWidget);
    expect(find.text('Terms and conditions'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets(
      'bottom card HIDES halting, driver beta, allowance, and tolls for Bike in ONE_WAY',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: RideSummaryPage(
          pickupTitle: 'Pickup',
          pickupAddress: 'Pickup Address',
          dropTitle: 'Drop',
          dropAddress: 'Drop Address',
          pickupLatLng: LatLng(17.4483, 78.3915),
          dropLatLng: LatLng(17.4938, 78.3995),
          selectedVehicle: bikeVehicle,
          bookingMode: 'ONE_WAY',
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Verify outstation car terms are HIDDEN for Bike
    expect(find.text('Take number halting (per day 3 free)'), findsNothing);
    expect(find.text('Driver beta'), findsNothing);
    expect(find.text('Driver alwence'), findsNothing);
    expect(find.text('Toll charges'), findsNothing);
    expect(find.text('Terms and conditions'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });

  testWidgets(
      'bottom card HIDES halting, driver beta, allowance, and tolls for Car in INSTANT mode',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: RideSummaryPage(
          pickupTitle: 'Pickup',
          pickupAddress: 'Pickup Address',
          dropTitle: 'Drop',
          dropAddress: 'Drop Address',
          pickupLatLng: LatLng(17.4483, 78.3915),
          dropLatLng: LatLng(17.4938, 78.3995),
          selectedVehicle: cabVehicle,
          bookingMode: 'INSTANT',
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Verify outstation car terms are HIDDEN for INSTANT ride
    expect(find.text('Take number halting (per day 3 free)'), findsNothing);
    expect(find.text('Driver beta'), findsNothing);
    expect(find.text('Driver alwence'), findsNothing);
    expect(find.text('Toll charges'), findsNothing);
    expect(find.text('Terms and conditions'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}

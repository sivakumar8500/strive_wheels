import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/vehicle_details/domain/entities/vehicle_details_entity.dart';
import 'package:wheels_user/features/vehicle_details/presentation/bloc/vehicle_details_bloc.dart';
import 'package:wheels_user/features/vehicle_details/presentation/bloc/vehicle_details_event.dart';
import 'package:wheels_user/features/vehicle_details/presentation/bloc/vehicle_details_state.dart';
import 'package:wheels_user/features/vehicle_details/presentation/pages/vehicle_details_page.dart';

class MockVehicleDetailsBloc
    extends MockBloc<VehicleDetailsEvent, VehicleDetailsState>
    implements VehicleDetailsBloc {}

void main() {
  late MockVehicleDetailsBloc mockBloc;

  const tDetails = VehicleDetailsEntity(
    id: 'v4',
    vehicleName: 'Range Rover Autobiography',
    operatorName: 'SilverStar Luxury Rentals',
    isEcoFriendly: true,
    isTopRated: true,
    capacity: '6 Seats',
    luggage: '4 Large',
    amenities: 'Free Wi-Fi',
    climate: 'Quad Zone',
    driverName: 'Michael Henderson',
    driverRating: '4.9',
    driverTrips: '240trips',
    driverBio:
        'Elite-tier driver. English, German, and French speaker. Concierge-trained for executive transport.',
    estimatedDuration: '42 mins est.',
    pickupLocation: 'Zurich Airport (ZRH)',
    dropoffLocation: 'Baur au Lac Hotel',
    price: '₹1,850',
    imagePath: 'assets/images/vehicle_range_rover.jpg',
  );

  setUpAll(() {
    registerFallbackValue(const LoadVehicleDetailsEvent('v4'));
    registerFallbackValue(const ConfirmVehicleBookingEvent('v4'));
  });

  setUp(() {
    mockBloc = MockVehicleDetailsBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<VehicleDetailsBloc>.value(
        value: mockBloc,
        child: const VehicleDetailsPage(vehicleId: 'v4'),
      ),
    );
  }

  testWidgets('renders vehicle name, specs, driver info, and booking button',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const VehicleDetailsState(
      isLoading: false,
      vehicleDetails: tDetails,
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Range Rover Autobiography'), findsOneWidget);
    expect(find.text('Operated by SilverStar Luxury Rentals'), findsOneWidget);
    expect(find.text('6 Seats'), findsOneWidget);
    expect(find.text('4 Large'), findsOneWidget);
    expect(find.text('Free Wi-Fi'), findsOneWidget);
    expect(find.text('Quad Zone'), findsOneWidget);
    expect(find.text('Michael Henderson'), findsOneWidget);
    expect(find.text('Pick-up: Zurich Airport (ZRH)'), findsOneWidget);
  });

  testWidgets('tapping booking button fires ConfirmVehicleBookingEvent',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const VehicleDetailsState(
      isLoading: false,
      vehicleDetails: tDetails,
    ));

    await tester.pumpWidget(buildTestWidget());

    final bookingButtonFinder =
        find.text('Book Range Rover Autobiography (₹1,850)');
    await tester.ensureVisible(bookingButtonFinder);
    await tester.tap(bookingButtonFinder);
    await tester.pump();

    verify(() => mockBloc.add(const ConfirmVehicleBookingEvent('v4'))).called(1);
  });
}

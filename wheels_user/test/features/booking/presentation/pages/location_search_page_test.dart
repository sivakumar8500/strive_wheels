import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/booking/domain/entities/recent_journey_entity.dart';
import 'package:wheels_user/features/booking/domain/entities/vehicle_option_entity.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_event.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_state.dart';
import 'package:wheels_user/features/booking/presentation/pages/location_search_page.dart';

class MockBookingBloc extends MockBloc<BookingEvent, BookingState>
    implements BookingBloc {}

void main() {
  late MockBookingBloc mockBloc;

  const tJourneys = [
    RecentJourneyEntity(
      id: '1',
      title: 'JFK International Airport',
      origin: 'From Lower Manhattan',
      timestamp: '2 days ago',
      iconType: 'history',
    ),
  ];

  const tVehicles = [
    VehicleOptionEntity(
      id: 'v1',
      name: 'Mercedes E-Class',
      specs: '4 Seats · AC · Automatic',
      price: '₹450',
      rating: '4.9 (48)',
      eta: '4 min',
      imagePath: 'assets/images/mercedes_car.png',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const LoadBookingDataEvent());
    registerFallbackValue(const SearchVehiclesEvent());
  });

  setUp(() {
    mockBloc = MockBookingBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<BookingBloc>.value(
        value: mockBloc,
        child: const LocationSearchPage(),
      ),
    );
  }

  testWidgets('renders loading indicator when state is loading', (tester) async {
    when(() => mockBloc.state).thenReturn(const BookingState(isLoading: true));

    await tester.pumpWidget(buildTestWidget());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders pickup, destination, ride type pills, and Search Vehicles button when loaded', (tester) async {
    when(() => mockBloc.state).thenReturn(const BookingState(
      isLoading: false,
      pickupLocation: '5th Avenue, NYC',
      destination: 'Where to?',
      recentJourneys: tJourneys,
      availableVehicles: tVehicles,
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Pickup Location'), findsOneWidget);
    expect(find.text('5th Avenue, NYC'), findsOneWidget);
    expect(find.text('Destination'), findsOneWidget);
    expect(find.text('Where to?'), findsOneWidget);
    expect(find.text('Instant'), findsOneWidget);
    expect(find.text('One Way'), findsOneWidget);
    expect(find.text('Round Trip'), findsOneWidget);
    expect(find.text('Recent Journeys'), findsOneWidget);
    expect(find.text('JFK International Airport'), findsOneWidget);
    expect(find.text('Search Vehicles'), findsOneWidget);
  });

  testWidgets('tapping Search Vehicles button fires SearchVehiclesEvent', (tester) async {
    when(() => mockBloc.state).thenReturn(const BookingState(
      isLoading: false,
      recentJourneys: tJourneys,
      availableVehicles: tVehicles,
    ));

    await tester.pumpWidget(buildTestWidget());

    await tester.ensureVisible(find.byKey(const Key('search_vehicles_button')));
    await tester.tap(find.byKey(const Key('search_vehicles_button')));
    await tester.pump();

    verify(() => mockBloc.add(const SearchVehiclesEvent())).called(1);
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/trip_overview/domain/entities/trip_overview_entity.dart';
import 'package:wheels_user/features/trip_overview/presentation/bloc/trip_overview_bloc.dart';
import 'package:wheels_user/features/trip_overview/presentation/bloc/trip_overview_event.dart';
import 'package:wheels_user/features/trip_overview/presentation/bloc/trip_overview_state.dart';
import 'package:wheels_user/features/trip_overview/presentation/pages/trip_overview_page.dart';

class MockTripOverviewBloc
    extends MockBloc<TripOverviewEvent, TripOverviewState>
    implements TripOverviewBloc {}

void main() {
  late MockTripOverviewBloc mockBloc;

  const tEntity = TripOverviewEntity(
    pickupLocation: 'St. Regis Residences, Downtown Dubai',
    destination: 'Dubai International Airport (DXB) Terminal 3',
    tripType: 'One Way',
    distanceText: '14.2 km (Approx 18 mins)',
    vehicleName: 'Executive Luxury Sedan',
    vehicleSeats: '4 Seats',
    vehicleLuggage: '3 Luggage',
    vehicleAmenity: 'Complimentary Wi-Fi',
    vehicleImagePath: 'assets/images/vehicle_mercedes.png',
    walletBalance: 142.50,
    baseFare: 85.00,
    distanceCharge: 12.50,
    serviceSurcharge: 5.00,
    taxesFees: 5.12,
    grandTotal: 107.62,
    currency: 'USD',
  );

  setUpAll(() {
    registerFallbackValue(const LoadTripOverviewEvent());
    registerFallbackValue(const ConfirmFinalBookingEvent());
  });

  setUp(() {
    mockBloc = MockTripOverviewBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<TripOverviewBloc>.value(
        value: mockBloc,
        child: const TripOverviewPage(),
      ),
    );
  }

  testWidgets('renders Trip Overview card, vehicle info, fare breakdown, and confirm button',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const TripOverviewState(
      isLoading: false,
      tripOverview: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Trip Overview'), findsOneWidget);
    expect(find.text('St. Regis Residences, Downtown Dubai'), findsOneWidget);
    expect(find.text('Executive Luxury Sedan'), findsOneWidget);
    expect(find.text('Fare Breakdown'), findsOneWidget);
    expect(find.text('\$107.62'), findsOneWidget);
    expect(find.text('Confirm Booking  ➔'), findsOneWidget);
  });

  testWidgets('tapping Confirm Booking button fires ConfirmFinalBookingEvent',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const TripOverviewState(
      isLoading: false,
      tripOverview: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    final confirmButton = find.text('Confirm Booking  ➔');
    await tester.ensureVisible(confirmButton);
    await tester.tap(confirmButton);
    await tester.pump();

    verify(() => mockBloc.add(const ConfirmFinalBookingEvent())).called(1);
  });
}

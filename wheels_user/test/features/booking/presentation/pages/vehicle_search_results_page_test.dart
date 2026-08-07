import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/booking/domain/entities/vehicle_option_entity.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_event.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_state.dart';
import 'package:wheels_user/features/booking/presentation/pages/vehicle_search_results_page.dart';

class MockBookingBloc extends MockBloc<BookingEvent, BookingState>
    implements BookingBloc {}

void main() {
  late MockBookingBloc mockBloc;

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
    VehicleOptionEntity(
      id: 'v2',
      name: 'Tempo Traveler / Van',
      specs: '12 Seats · AC · Luggage',
      price: '₹850',
      rating: '4.8 (32)',
      eta: '8 min',
      imagePath: 'assets/images/tempo_van.png',
    ),
  ];

  setUpAll(() {
    registerFallbackValue(const BookVehicleNowEvent(
      vehicleId: 'v1',
      vehicleName: 'Mercedes E-Class',
    ));
  });

  setUp(() {
    mockBloc = MockBookingBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<BookingBloc>.value(
        value: mockBloc,
        child: const VehicleSearchResultsPage(),
      ),
    );
  }

  testWidgets('renders route summary header and vehicle cards', (tester) async {
    when(() => mockBloc.state).thenReturn(const BookingState(
      isLoading: false,
      pickupLocation: '5th Avenue, NYC',
      destination: 'Central Park',
      availableVehicles: tVehicles,
      isShowingVehicleResults: true,
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('5th Avenue'), findsOneWidget);
    expect(find.text('Central Park'), findsOneWidget);
    expect(find.text('Mercedes E-Class'), findsOneWidget);
    expect(find.text('Tempo Traveler / Van'), findsOneWidget);
    expect(find.text('₹450'), findsOneWidget);
    expect(find.text('₹850'), findsOneWidget);
  });

  testWidgets('tapping Book Now button fires BookVehicleNowEvent', (tester) async {
    when(() => mockBloc.state).thenReturn(const BookingState(
      isLoading: false,
      availableVehicles: tVehicles,
      isShowingVehicleResults: true,
    ));

    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.byKey(const Key('book_now_button_v1')));
    await tester.pump();

    verify(() => mockBloc.add(const BookVehicleNowEvent(
          vehicleId: 'v1',
          vehicleName: 'Mercedes E-Class',
        ))).called(1);
  });
}

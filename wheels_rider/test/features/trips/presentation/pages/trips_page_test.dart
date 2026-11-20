import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_rider/features/trips/domain/entities/trip_entity.dart';
import 'package:wheels_rider/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:wheels_rider/features/trips/presentation/bloc/trips_state.dart';
import 'package:wheels_rider/features/trips/presentation/pages/trips_page.dart';
import 'package:wheels_rider/core/widgets/animated_empty_state.dart';

class MockTripsBloc extends Mock implements TripsBloc {}

void main() {
  late MockTripsBloc mockTripsBloc;

  setUp(() {
    mockTripsBloc = MockTripsBloc();
    when(() => mockTripsBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockTripsBloc.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<TripsBloc>.value(
        value: mockTripsBloc,
        child: const TripsPage(),
      ),
    );
  }

  testWidgets('shows loading indicator when state is TripsLoading', (WidgetTester tester) async {
    when(() => mockTripsBloc.state).thenReturn(TripsLoading());
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows empty state when state is TripsLoaded and bookings are empty', (WidgetTester tester) async {
    final tTripEntity = TripEntity(
      totalMileage: 14280.0,
      totalRides: 1240,
      avgRating: 4.98,
      bookings: [],
    );
    when(() => mockTripsBloc.state).thenReturn(TripsLoaded(tTripEntity));
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('TOTAL MILEAGE'), findsOneWidget);
    expect(find.byType(AnimatedEmptyState), findsOneWidget);
  });

  testWidgets('shows data when state is TripsLoaded', (WidgetTester tester) async {
    final tBooking = BookingEntity(
      id: '1',
      clientName: 'Sarah Jenkins',
      clientRating: 5.0,
      tag: 'Corporate',
      price: 42.8,
      pickupLocation: 'A',
      dropoffLocation: 'B',
      timestamp: DateTime.parse('2023-01-01T00:00:00Z'),
      status: 'Completed',
    );
    final tTripEntity = TripEntity(
      totalMileage: 14280.0,
      totalRides: 1240,
      avgRating: 4.98,
      bookings: [tBooking],
    );
    when(() => mockTripsBloc.state).thenReturn(TripsLoaded(tTripEntity));
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Sarah Jenkins'), findsOneWidget);
    expect(find.text('Corporate'), findsWidgets);
  });
}

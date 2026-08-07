import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/schedule_ride/domain/entities/schedule_ride_entity.dart';
import 'package:wheels_user/features/schedule_ride/presentation/bloc/schedule_ride_bloc.dart';
import 'package:wheels_user/features/schedule_ride/presentation/bloc/schedule_ride_event.dart';
import 'package:wheels_user/features/schedule_ride/presentation/bloc/schedule_ride_state.dart';
import 'package:wheels_user/features/schedule_ride/presentation/pages/schedule_ride_page.dart';

class MockScheduleRideBloc
    extends MockBloc<ScheduleRideEvent, ScheduleRideState>
    implements ScheduleRideBloc {}

void main() {
  late MockScheduleRideBloc mockBloc;

  const tEntity = ScheduleRideEntity(
    pickupPoint: 'Harrods, 87–135 Brompton Rd',
    destination: 'The Ritz London, 150 Piccadilly',
    distanceKm: 18.2,
    durationMins: 42,
    fareAmount: 24.50,
    currencySymbol: '£',
    selectedDate: 'Fri 24',
    selectedTime: '10 : 45',
    isAm: true,
    instantNotification: true,
    checklistItems: ['Driver beta'],
  );

  setUpAll(() {
    registerFallbackValue(const LoadScheduleRideEvent());
    registerFallbackValue(const ConfirmScheduleEvent());
  });

  setUp(() {
    mockBloc = MockScheduleRideBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<ScheduleRideBloc>.value(
        value: mockBloc,
        child: const ScheduleRidePage(),
      ),
    );
  }

  testWidgets('renders schedule ride header, locations, time picker, and confirm button',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const ScheduleRideState(
      isLoading: false,
      rideDetails: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Schedule Ride'), findsOneWidget);
    expect(find.text('Harrods, 87–135 Brompton Rd'), findsOneWidget);
    expect(find.text('The Ritz London, 150 Piccadilly'), findsOneWidget);
    expect(find.text('Pick Date & Time'), findsOneWidget);
    expect(find.text('Confirm Schedule  ›'), findsOneWidget);
  });

  testWidgets('tapping Confirm Schedule button fires ConfirmScheduleEvent',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const ScheduleRideState(
      isLoading: false,
      rideDetails: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    final confirmButton = find.text('Confirm Schedule  ›');
    await tester.ensureVisible(confirmButton);
    await tester.tap(confirmButton);
    await tester.pump();

    verify(() => mockBloc.add(const ConfirmScheduleEvent())).called(1);
  });
}

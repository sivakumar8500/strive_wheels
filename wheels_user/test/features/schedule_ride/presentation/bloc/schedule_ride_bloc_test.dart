import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/schedule_ride/domain/entities/schedule_ride_entity.dart';
import 'package:wheels_user/features/schedule_ride/domain/usecases/get_schedule_ride_usecase.dart';
import 'package:wheels_user/features/schedule_ride/presentation/bloc/schedule_ride_bloc.dart';
import 'package:wheels_user/features/schedule_ride/presentation/bloc/schedule_ride_event.dart';
import 'package:wheels_user/features/schedule_ride/presentation/bloc/schedule_ride_state.dart';

class MockGetScheduleRideUseCase extends Mock
    implements GetScheduleRideUseCase {}

void main() {
  late ScheduleRideBloc bloc;
  late MockGetScheduleRideUseCase mockGetScheduleRideUseCase;

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

  setUp(() {
    mockGetScheduleRideUseCase = MockGetScheduleRideUseCase();
    bloc = ScheduleRideBloc(
      getScheduleRideUseCase: mockGetScheduleRideUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is ScheduleRideState with isLoading true', () {
    expect(bloc.state.isLoading, isTrue);
  });

  blocTest<ScheduleRideBloc, ScheduleRideState>(
    'emits [isLoading true, isLoading false with rideDetails] on LoadScheduleRideEvent',
    build: () {
      when(() => mockGetScheduleRideUseCase()).thenAnswer((_) async => tEntity);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadScheduleRideEvent()),
    expect: () => [
      isA<ScheduleRideState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<ScheduleRideState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.rideDetails, 'rideDetails', tEntity),
    ],
  );

  blocTest<ScheduleRideBloc, ScheduleRideState>(
    'updates selectedDate on SelectScheduleDateEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const SelectScheduleDateEvent('Sat 25')),
    expect: () => [
      isA<ScheduleRideState>()
          .having((s) => s.selectedDate, 'selectedDate', 'Sat 25'),
    ],
  );

  blocTest<ScheduleRideBloc, ScheduleRideState>(
    'emits isConfirmed true on ConfirmScheduleEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const ConfirmScheduleEvent()),
    expect: () => [
      isA<ScheduleRideState>()
          .having((s) => s.isConfirmed, 'isConfirmed', isTrue),
    ],
  );
}

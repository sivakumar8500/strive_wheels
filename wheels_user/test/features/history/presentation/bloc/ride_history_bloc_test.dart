import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/history/domain/entities/past_ride_item_entity.dart';
import 'package:wheels_user/features/history/domain/entities/ride_history_entity.dart';
import 'package:wheels_user/features/history/domain/usecases/get_ride_history_usecase.dart';
import 'package:wheels_user/features/history/presentation/bloc/ride_history_bloc.dart';
import 'package:wheels_user/features/history/presentation/bloc/ride_history_event.dart';
import 'package:wheels_user/features/history/presentation/bloc/ride_history_state.dart';

class MockGetRideHistoryUseCase extends Mock implements GetRideHistoryUseCase {}

void main() {
  late RideHistoryBloc bloc;
  late MockGetRideHistoryUseCase mockGetRideHistoryUseCase;

  const tEntity = RideHistoryEntity(
    monthlySummaryTitle: 'June ride summary',
    tripCountText: '12 trips',
    distanceText: '184 km this month',
    spentText: '₹2,486 spent',
    pastRides: [
      PastRideItemEntity(
        id: '1',
        title: 'Mindspace IT Park ➔ Home',
        dateAndVehicle: 'Yesterday · 6:42 PM · Bike',
        status: 'Completed',
        amount: '₹185',
        serviceType: 'Bike',
      ),
    ],
  );

  setUp(() {
    mockGetRideHistoryUseCase = MockGetRideHistoryUseCase();
    bloc = RideHistoryBloc(getRideHistoryUseCase: mockGetRideHistoryUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is RideHistoryState with isLoading true', () {
    expect(bloc.state.isLoading, isTrue);
  });

  blocTest<RideHistoryBloc, RideHistoryState>(
    'emits state with historyEntity when LoadRideHistoryEvent succeeds',
    build: () {
      when(() => mockGetRideHistoryUseCase())
          .thenAnswer((_) async => tEntity);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadRideHistoryEvent()),
    expect: () => [
      isA<RideHistoryState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<RideHistoryState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.historyEntity, 'historyEntity', tEntity),
    ],
    verify: (_) {
      verify(() => mockGetRideHistoryUseCase()).called(1);
    },
  );

  blocTest<RideHistoryBloc, RideHistoryState>(
    'updates selectedFilterIndex on FilterTripsTabEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const FilterTripsTabEvent(1)),
    expect: () => [
      isA<RideHistoryState>()
          .having((s) => s.selectedFilterIndex, 'selectedFilterIndex', 1),
    ],
  );

  blocTest<RideHistoryBloc, RideHistoryState>(
    'emits bookAgainMessage on BookAgainEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const BookAgainEvent(
      rideId: '1',
      rideTitle: 'Mindspace IT Park ➔ Home',
    )),
    expect: () => [
      isA<RideHistoryState>().having(
        (s) => s.bookAgainMessage,
        'bookAgainMessage',
        'Booking Mindspace IT Park ➔ Home again...',
      ),
    ],
  );

  blocTest<RideHistoryBloc, RideHistoryState>(
    'emits actionMessage on OpenFilterOptionsEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const OpenFilterOptionsEvent()),
    expect: () => [
      isA<RideHistoryState>().having(
        (s) => s.actionMessage,
        'actionMessage',
        'Filter options opened',
      ),
    ],
  );
}

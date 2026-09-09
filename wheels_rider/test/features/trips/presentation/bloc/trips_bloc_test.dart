import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/trips/domain/entities/trip_entity.dart';
import 'package:wheels_rider/features/trips/domain/usecases/get_trips_usecase.dart';
import 'package:wheels_rider/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:wheels_rider/features/trips/presentation/bloc/trips_event.dart';
import 'package:wheels_rider/features/trips/presentation/bloc/trips_state.dart';

class MockGetTripsUseCase extends Mock implements GetTripsUseCase {}

void main() {
  late TripsBloc bloc;
  late MockGetTripsUseCase mockGetTripsUseCase;

  setUp(() {
    mockGetTripsUseCase = MockGetTripsUseCase();
    bloc = TripsBloc(getTripsUseCase: mockGetTripsUseCase);
  });

  final tTripEntity = TripEntity(
    totalMileage: 14280.0,
    totalRides: 1240,
    avgRating: 4.98,
    bookings: [],
  );

  test('initial state should be TripsInitial', () {
    expect(bloc.state, isA<TripsInitial>());
  });

  blocTest<TripsBloc, TripsState>(
    'should emit [TripsLoading, TripsLoaded] when data is gotten successfully',
    build: () {
      when(() => mockGetTripsUseCase(any(), any())).thenAnswer((_) async => tTripEntity);
      return bloc;
    },
    act: (bloc) => bloc.add(GetTripsEvent()),
    expect: () => [
      isA<TripsLoading>(),
      isA<TripsLoaded>(),
    ],
  );

  blocTest<TripsBloc, TripsState>(
    'should emit [TripsLoading, TripsError] when getting data fails',
    build: () {
      when(() => mockGetTripsUseCase(any(), any())).thenThrow(Exception('Server Failure'));
      return bloc;
    },
    act: (bloc) => bloc.add(GetTripsEvent()),
    expect: () => [
      isA<TripsLoading>(),
      isA<TripsError>(),
    ],
  );
}

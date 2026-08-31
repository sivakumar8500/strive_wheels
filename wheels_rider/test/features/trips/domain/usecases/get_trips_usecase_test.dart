import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/trips/domain/entities/trip_entity.dart';
import 'package:wheels_rider/features/trips/domain/repositories/trips_repository.dart';
import 'package:wheels_rider/features/trips/domain/usecases/get_trips_usecase.dart';

class MockTripsRepository extends Mock implements TripsRepository {}

void main() {
  late GetTripsUseCase usecase;
  late MockTripsRepository mockRepository;

  setUp(() {
    mockRepository = MockTripsRepository();
    usecase = GetTripsUseCase(mockRepository);
  });

  final tTripEntity = TripEntity(
    totalMileage: 14280.0,
    totalRides: 1240,
    avgRating: 4.98,
    bookings: [],
  );

  test('should get trips from repository', () async {
    when(() => mockRepository.getTrips(any(), any())).thenAnswer((_) async => tTripEntity);
    final result = await usecase(50, 0);
    expect(result, equals(tTripEntity));
    verify(() => mockRepository.getTrips(50, 0));
    verifyNoMoreInteractions(mockRepository);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/trips/data/datasources/trips_remote_data_source.dart';
import 'package:wheels_rider/features/trips/data/models/trip_model.dart';
import 'package:wheels_rider/features/trips/data/repositories/trips_repository_impl.dart';
import 'package:wheels_rider/features/trips/domain/entities/trip_entity.dart';

class MockTripsRemoteDataSource extends Mock implements TripsRemoteDataSource {}

void main() {
  late TripsRepositoryImpl repository;
  late MockTripsRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockTripsRemoteDataSource();
    repository = TripsRepositoryImpl(mockRemoteDataSource);
  });

  final tTripModel = TripModel(
    totalMileage: 14280.0,
    totalRides: 1240,
    avgRating: 4.98,
    bookings: [],
  );

  test('should return trip entity on success', () async {
    when(() => mockRemoteDataSource.getTrips(any(), any())).thenAnswer((_) async => tTripModel);
    final result = await repository.getTrips(50, 0);
    expect(result, isA<TripEntity>());
  });

  test('should throw exception on failure', () async {
    when(() => mockRemoteDataSource.getTrips(any(), any())).thenThrow(Exception());
    expect(() => repository.getTrips(50, 0), throwsException);
  });
}

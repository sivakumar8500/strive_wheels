import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/booking/data/datasources/booking_local_datasource.dart';
import 'package:wheels_user/features/booking/data/models/recent_journey_model.dart';
import 'package:wheels_user/features/booking/data/models/vehicle_option_model.dart';
import 'package:wheels_user/features/booking/data/repositories/booking_repository_impl.dart';

class MockBookingLocalDataSource extends Mock
    implements BookingLocalDataSource {}

void main() {
  late BookingRepositoryImpl repository;
  late MockBookingLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockBookingLocalDataSource();
    repository = BookingRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tJourneys = [
    RecentJourneyModel(
      id: '1',
      title: 'JFK International Airport',
      origin: 'From Lower Manhattan',
      timestamp: '2 days ago',
      iconType: 'history',
    ),
  ];

  const tVehicles = [
    VehicleOptionModel(
      id: 'v1',
      name: 'Mercedes E-Class',
      specs: '4 Seats · AC · Automatic',
      price: '₹450',
      rating: '4.9 (48)',
      eta: '4 min',
      imagePath: 'assets/images/mercedes_car.png',
    ),
  ];

  test('should return recent journeys when local data source succeeds', () async {
    when(() => mockLocalDataSource.getRecentJourneys())
        .thenAnswer((_) async => tJourneys);

    final result = await repository.getRecentJourneys();

    expect(result.length, equals(1));
    expect(result.first.title, equals('JFK International Airport'));
    verify(() => mockLocalDataSource.getRecentJourneys()).called(1);
  });

  test('should return available vehicles when local data source succeeds', () async {
    when(() => mockLocalDataSource.getAvailableVehicles())
        .thenAnswer((_) async => tVehicles);

    final result = await repository.getAvailableVehicles();

    expect(result.length, equals(1));
    expect(result.first.name, equals('Mercedes E-Class'));
    verify(() => mockLocalDataSource.getAvailableVehicles()).called(1);
  });
}

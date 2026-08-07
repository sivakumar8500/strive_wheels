import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/trip_overview/data/datasources/trip_overview_local_datasource.dart';
import 'package:wheels_user/features/trip_overview/data/models/trip_overview_model.dart';
import 'package:wheels_user/features/trip_overview/data/repositories/trip_overview_repository_impl.dart';

class MockTripOverviewLocalDataSource extends Mock
    implements TripOverviewLocalDataSource {}

void main() {
  late TripOverviewRepositoryImpl repository;
  late MockTripOverviewLocalDataSource mockLocalDataSource;

  const tModel = TripOverviewModel(
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

  setUp(() {
    mockLocalDataSource = MockTripOverviewLocalDataSource();
    repository = TripOverviewRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test('should return TripOverviewEntity when localDataSource returns model',
      () async {
    when(() => mockLocalDataSource.getTripOverviewDetails(any()))
        .thenAnswer((_) async => tModel);

    final result = await repository.getTripOverviewDetails('v1');

    expect(result.vehicleName, 'Executive Luxury Sedan');
    verify(() => mockLocalDataSource.getTripOverviewDetails('v1')).called(1);
  });
}

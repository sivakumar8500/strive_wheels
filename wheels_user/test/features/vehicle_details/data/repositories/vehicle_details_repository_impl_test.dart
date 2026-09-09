import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/vehicle_details/data/datasources/vehicle_details_local_datasource.dart';
import 'package:wheels_user/features/vehicle_details/data/models/vehicle_details_model.dart';
import 'package:wheels_user/features/vehicle_details/data/repositories/vehicle_details_repository_impl.dart';

class MockVehicleDetailsLocalDataSource extends Mock
    implements VehicleDetailsLocalDataSource {}

void main() {
  late VehicleDetailsRepositoryImpl repository;
  late MockVehicleDetailsLocalDataSource mockLocalDataSource;

  const tModel = VehicleDetailsModel(
    id: 'v4',
    vehicleName: 'Range Rover Autobiography',
    operatorName: 'SilverStar Luxury Rentals',
    isEcoFriendly: true,
    isTopRated: true,
    capacity: '6 Seats',
    luggage: '4 Large',
    amenities: 'Free Wi-Fi',
    climate: 'Quad Zone',
    driverName: 'Michael Henderson',
    driverRating: '4.9',
    driverTrips: '240trips',
    driverBio: 'Elite-tier driver.',
    estimatedDuration: '42 mins est.',
    pickupLocation: 'Zurich Airport (ZRH)',
    dropoffLocation: 'Baur au Lac Hotel',
    price: '₹1,850',
    imagePath: 'assets/images/vehicle_range_rover.jpg',
  );

  setUp(() {
    mockLocalDataSource = MockVehicleDetailsLocalDataSource();
    repository = VehicleDetailsRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test('should return VehicleDetailsEntity when datasource is called', () async {
    when(() => mockLocalDataSource.getVehicleDetails(any()))
        .thenAnswer((_) async => tModel);

    final result = await repository.getVehicleDetails('v4');

    expect(result.vehicleName, 'Range Rover Autobiography');
    verify(() => mockLocalDataSource.getVehicleDetails('v4')).called(1);
  });
}

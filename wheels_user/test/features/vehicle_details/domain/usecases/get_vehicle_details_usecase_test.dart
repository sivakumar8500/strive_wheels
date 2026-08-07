import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/vehicle_details/domain/entities/vehicle_details_entity.dart';
import 'package:wheels_user/features/vehicle_details/domain/repositories/vehicle_details_repository.dart';
import 'package:wheels_user/features/vehicle_details/domain/usecases/get_vehicle_details_usecase.dart';

class MockVehicleDetailsRepository extends Mock
    implements VehicleDetailsRepository {}

void main() {
  late GetVehicleDetailsUseCase usecase;
  late MockVehicleDetailsRepository mockRepository;

  const tDetails = VehicleDetailsEntity(
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
    mockRepository = MockVehicleDetailsRepository();
    usecase = GetVehicleDetailsUseCase(mockRepository);
  });

  test('should return VehicleDetailsEntity from repository', () async {
    when(() => mockRepository.getVehicleDetails(any()))
        .thenAnswer((_) async => tDetails);

    final result = await usecase('v4');

    expect(result, tDetails);
    verify(() => mockRepository.getVehicleDetails('v4')).called(1);
  });
}

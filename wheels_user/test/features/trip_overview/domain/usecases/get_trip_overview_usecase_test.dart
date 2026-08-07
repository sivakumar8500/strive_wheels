import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/trip_overview/domain/entities/trip_overview_entity.dart';
import 'package:wheels_user/features/trip_overview/domain/repositories/trip_overview_repository.dart';
import 'package:wheels_user/features/trip_overview/domain/usecases/get_trip_overview_usecase.dart';

class MockTripOverviewRepository extends Mock
    implements TripOverviewRepository {}

void main() {
  late GetTripOverviewUseCase usecase;
  late MockTripOverviewRepository mockRepository;

  const tEntity = TripOverviewEntity(
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
    mockRepository = MockTripOverviewRepository();
    usecase = GetTripOverviewUseCase(mockRepository);
  });

  test('should return TripOverviewEntity from repository', () async {
    when(() => mockRepository.getTripOverviewDetails(any()))
        .thenAnswer((_) async => tEntity);

    final result = await usecase('v1');

    expect(result, tEntity);
    verify(() => mockRepository.getTripOverviewDetails('v1')).called(1);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/booking/domain/entities/corporate_aligned_vehicle_entity.dart';
import 'package:wheels_user/features/booking/domain/repositories/booking_repository.dart';
import 'package:wheels_user/features/booking/domain/usecases/get_corporate_aligned_vehicles_usecase.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late GetCorporateAlignedVehiclesUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetCorporateAlignedVehiclesUseCase(mockRepository);
  });

  const tVehicles = [
    CorporateAlignedVehicleEntity(
      id: 1,
      companyId: 1,
      riderId: 10,
      vehicleId: 5,
      driverName: 'Ramesh Kumar',
      driverPhone: '+919876543210',
      driverRating: 4.9,
      vehicleName: 'Toyota Innova',
      licensePlate: 'TS09AB1234',
      vehicleTypeId: 1,
      vehicleTypeName: 'Sedan',
      routeFrom: 'Kokapet',
      routeTo: 'Kukatpally',
      routeFromLat: 17.412,
      routeFromLng: 78.339,
      routeToLat: 17.493,
      routeToLng: 78.399,
      isAligned: true,
      alignmentLabel: 'Direct Route Match (Kokapet ➔ Kukatpally)',
      seats: 4,
    ),
  ];

  test('should return list of CorporateAlignedVehicleEntity from repository', () async {
    when(() => mockRepository.getCorporateAlignedVehicles(
          pickupLat: any(named: 'pickupLat'),
          pickupLng: any(named: 'pickupLng'),
          dropAddress: any(named: 'dropAddress'),
        )).thenAnswer((_) async => tVehicles);

    final result = await useCase(
      pickupLat: 17.412,
      pickupLng: 78.339,
      dropAddress: 'Kukatpally',
    );

    expect(result, equals(tVehicles));
    verify(() => mockRepository.getCorporateAlignedVehicles(
          pickupLat: 17.412,
          pickupLng: 78.339,
          dropAddress: 'Kukatpally',
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

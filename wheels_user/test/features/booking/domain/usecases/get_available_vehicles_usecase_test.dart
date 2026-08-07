import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/booking/domain/entities/vehicle_option_entity.dart';
import 'package:wheels_user/features/booking/domain/repositories/booking_repository.dart';
import 'package:wheels_user/features/booking/domain/usecases/get_available_vehicles_usecase.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late GetAvailableVehiclesUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetAvailableVehiclesUseCase(mockRepository);
  });

  const tVehicles = [
    VehicleOptionEntity(
      id: 'v1',
      name: 'Mercedes E-Class',
      specs: '4 Seats · AC · Automatic',
      price: '₹450',
      rating: '4.9 (48)',
      eta: '4 min',
      imagePath: 'assets/images/mercedes_car.png',
    ),
  ];

  test('should return list of VehicleOptionEntity from repository', () async {
    when(() => mockRepository.getAvailableVehicles())
        .thenAnswer((_) async => tVehicles);

    final result = await useCase();

    expect(result, equals(tVehicles));
    verify(() => mockRepository.getAvailableVehicles()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

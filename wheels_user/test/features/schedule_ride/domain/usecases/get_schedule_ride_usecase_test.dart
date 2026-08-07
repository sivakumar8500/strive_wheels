import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/schedule_ride/domain/entities/schedule_ride_entity.dart';
import 'package:wheels_user/features/schedule_ride/domain/repositories/schedule_ride_repository.dart';
import 'package:wheels_user/features/schedule_ride/domain/usecases/get_schedule_ride_usecase.dart';

class MockScheduleRideRepository extends Mock implements ScheduleRideRepository {}

void main() {
  late GetScheduleRideUseCase usecase;
  late MockScheduleRideRepository mockRepository;

  const tEntity = ScheduleRideEntity(
    pickupPoint: 'Harrods, 87–135 Brompton Rd',
    destination: 'The Ritz London, 150 Piccadilly',
    distanceKm: 18.2,
    durationMins: 42,
    fareAmount: 24.50,
    currencySymbol: '£',
    selectedDate: 'Fri 24',
    selectedTime: '10 : 45',
    isAm: true,
    instantNotification: true,
    checklistItems: ['Driver beta'],
  );

  setUp(() {
    mockRepository = MockScheduleRideRepository();
    usecase = GetScheduleRideUseCase(mockRepository);
  });

  test('should return ScheduleRideEntity from repository', () async {
    when(() => mockRepository.getScheduleRideDetails())
        .thenAnswer((_) async => tEntity);

    final result = await usecase();

    expect(result, tEntity);
    verify(() => mockRepository.getScheduleRideDetails()).called(1);
  });
}

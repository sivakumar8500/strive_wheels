import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/history/domain/entities/past_ride_item_entity.dart';
import 'package:wheels_user/features/history/domain/entities/ride_history_entity.dart';
import 'package:wheels_user/features/history/domain/repositories/ride_history_repository.dart';
import 'package:wheels_user/features/history/domain/usecases/get_ride_history_usecase.dart';

class MockRideHistoryRepository extends Mock implements RideHistoryRepository {}

void main() {
  late GetRideHistoryUseCase useCase;
  late MockRideHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockRideHistoryRepository();
    useCase = GetRideHistoryUseCase(mockRepository);
  });

  const tEntity = RideHistoryEntity(
    monthlySummaryTitle: 'June ride summary',
    tripCountText: '12 trips',
    distanceText: '184 km this month',
    spentText: '₹2,486 spent',
    pastRides: [
      PastRideItemEntity(
        id: '1',
        title: 'Mindspace IT Park ➔ Home',
        dateAndVehicle: 'Yesterday · 6:42 PM · Bike',
        status: 'Completed',
        amount: '₹185',
        serviceType: 'Bike',
      ),
    ],
  );

  test('should return RideHistoryEntity from repository', () async {
    // arrange
    when(() => mockRepository.getRideHistory())
        .thenAnswer((_) async => tEntity);

    // act
    final result = await useCase();

    // assert
    expect(result, equals(tEntity));
    verify(() => mockRepository.getRideHistory()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

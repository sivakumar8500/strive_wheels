import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/booking/domain/entities/recent_journey_entity.dart';
import 'package:wheels_user/features/booking/domain/repositories/booking_repository.dart';
import 'package:wheels_user/features/booking/domain/usecases/get_recent_journeys_usecase.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late GetRecentJourneysUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetRecentJourneysUseCase(mockRepository);
  });

  const tJourneys = [
    RecentJourneyEntity(
      id: '1',
      title: 'JFK International Airport',
      origin: 'From Lower Manhattan',
      timestamp: '2 days ago',
      iconType: 'history',
    ),
  ];

  test('should return list of RecentJourneyEntity from repository', () async {
    when(() => mockRepository.getRecentJourneys())
        .thenAnswer((_) async => tJourneys);

    final result = await useCase();

    expect(result, equals(tJourneys));
    verify(() => mockRepository.getRecentJourneys()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

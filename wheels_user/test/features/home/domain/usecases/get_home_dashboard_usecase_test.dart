import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:wheels_user/features/home/domain/repositories/home_repository.dart';
import 'package:wheels_user/features/home/domain/usecases/get_home_dashboard_usecase.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late GetHomeDashboardUseCase useCase;
  late MockHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetHomeDashboardUseCase(mockRepository);
  });

  const tEntity = HomeDashboardEntity(
    userName: 'JW',
    greetingTitle: 'Good Morning 👋',
    greetingSubtitle: 'Siri, ready for your next ride?',
    recentRideTitle: 'Office ➔ Home',
    recentRideDetails: 'Yesterday • Bike • ₹185',
  );

  test('should get HomeDashboardEntity from repository', () async {
    // arrange
    when(() => mockRepository.getHomeDashboard())
        .thenAnswer((_) async => tEntity);

    // act
    final result = await useCase();

    // assert
    expect(result, equals(tEntity));
    verify(() => mockRepository.getHomeDashboard()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

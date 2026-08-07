import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/driver_search/domain/entities/driver_search_entity.dart';
import 'package:wheels_user/features/driver_search/domain/repositories/driver_search_repository.dart';
import 'package:wheels_user/features/driver_search/domain/usecases/get_driver_search_usecase.dart';

class MockDriverSearchRepository extends Mock
    implements DriverSearchRepository {}

void main() {
  late GetDriverSearchUseCase usecase;
  late MockDriverSearchRepository mockRepository;

  const tEntity = DriverSearchEntity(
    statusTitle: 'Searching for nearby drivers...',
    statusSubtitle: 'Connecting you to the nearest premium vehicle.',
    estimatedConfirmationText: '5 - 30 mins',
    orderTime: '10:42 AM',
    scanRadiusText: 'Scanning 1.2km radius...',
    activeStepIndex: 1,
  );

  setUp(() {
    mockRepository = MockDriverSearchRepository();
    usecase = GetDriverSearchUseCase(mockRepository);
  });

  test('should return DriverSearchEntity from repository', () async {
    when(() => mockRepository.getDriverSearchDetails())
        .thenAnswer((_) async => tEntity);

    final result = await usecase();

    expect(result, tEntity);
    verify(() => mockRepository.getDriverSearchDetails()).called(1);
  });
}

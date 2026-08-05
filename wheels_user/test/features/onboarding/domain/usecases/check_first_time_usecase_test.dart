import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:wheels_user/features/onboarding/domain/usecases/check_first_time_usecase.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late MockOnboardingRepository mockRepository;
  late CheckFirstTimeUseCase useCase;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    useCase = CheckFirstTimeUseCase(mockRepository);
  });

  test('should return bool status from repository', () async {
    when(() => mockRepository.isFirstTime()).thenAnswer((_) async => true);

    final result = await useCase();

    expect(result, isTrue);
    verify(() => mockRepository.isFirstTime()).called(1);
  });
}

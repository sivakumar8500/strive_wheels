import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:wheels_user/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late MockOnboardingRepository mockRepository;
  late CompleteOnboardingUseCase useCase;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    useCase = CompleteOnboardingUseCase(mockRepository);
  });

  test('should call completeOnboarding on repository', () async {
    when(() => mockRepository.completeOnboarding()).thenAnswer((_) async {});

    await useCase();

    verify(() => mockRepository.completeOnboarding()).called(1);
  });
}

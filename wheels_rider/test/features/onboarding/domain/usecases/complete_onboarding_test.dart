import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:wheels_rider/features/onboarding/domain/usecases/complete_onboarding.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late CompleteOnboarding usecase;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    usecase = CompleteOnboarding(mockRepository);
  });

  test('should call completeOnboarding on repository', () async {
    when(() => mockRepository.completeOnboarding()).thenAnswer((_) async {});

    await usecase();

    verify(() => mockRepository.completeOnboarding()).called(1);
  });
}

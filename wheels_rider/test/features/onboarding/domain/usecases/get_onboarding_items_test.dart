import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/constants/app_strings.dart';
import 'package:wheels_rider/features/onboarding/domain/entities/onboarding_item.dart';
import 'package:wheels_rider/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:wheels_rider/features/onboarding/domain/usecases/get_onboarding_items.dart';

class MockOnboardingRepository extends Mock implements OnboardingRepository {}

void main() {
  late GetOnboardingItems usecase;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    usecase = GetOnboardingItems(mockRepository);
  });

  test('should return 2 onboarding items from repository', () {
    const items = [
      OnboardingItem(
        title: AppStrings.onboardingTitle1,
        subtitle: AppStrings.onboardingSubtitle1,
        imagePath: 'path1',
      ),
      OnboardingItem(
        title: AppStrings.onboardingTitle2,
        subtitle: AppStrings.onboardingSubtitle2,
        imagePath: 'path2',
      ),
    ];
    when(() => mockRepository.getOnboardingItems()).thenReturn(items);

    final result = usecase();

    expect(result.length, 2);
    expect(result[0].title, AppStrings.onboardingTitle1);
    expect(result[1].title, AppStrings.onboardingTitle2);
    verify(() => mockRepository.getOnboardingItems()).called(1);
  });
}

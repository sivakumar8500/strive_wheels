import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/onboarding_item.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  List<OnboardingItem> getOnboardingItems() {
    return const [
      OnboardingItem(
        title: AppStrings.onboardingTitle1,
        subtitle: AppStrings.onboardingSubtitle1,
        imagePath: AppAssets.onboarding1,
      ),
      OnboardingItem(
        title: AppStrings.onboardingTitle2,
        subtitle: AppStrings.onboardingSubtitle2,
        imagePath: AppAssets.onboarding2,
      ),
    ];
  }

  @override
  Future<void> completeOnboarding() async {
    await localDataSource.setOnboardingCompleted();
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return await localDataSource.isOnboardingCompleted();
  }
}

import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> isFirstTime() async {
    return await localDataSource.isFirstTime();
  }

  @override
  Future<void> completeOnboarding() async {
    await localDataSource.setFirstTimeCompleted();
  }
}

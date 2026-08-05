import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:wheels_user/features/onboarding/data/repositories/onboarding_repository_impl.dart';

class MockOnboardingLocalDataSource extends Mock
    implements OnboardingLocalDataSource {}

void main() {
  late MockOnboardingLocalDataSource mockDataSource;
  late OnboardingRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockOnboardingLocalDataSource();
    repository = OnboardingRepositoryImpl(localDataSource: mockDataSource);
  });

  group('OnboardingRepositoryImpl', () {
    test('should delegate isFirstTime to data source', () async {
      when(() => mockDataSource.isFirstTime()).thenAnswer((_) async => true);

      final result = await repository.isFirstTime();

      expect(result, isTrue);
      verify(() => mockDataSource.isFirstTime()).called(1);
    });

    test('should delegate completeOnboarding to data source', () async {
      when(() => mockDataSource.setFirstTimeCompleted())
          .thenAnswer((_) async {});

      await repository.completeOnboarding();

      verify(() => mockDataSource.setFirstTimeCompleted()).called(1);
    });
  });
}

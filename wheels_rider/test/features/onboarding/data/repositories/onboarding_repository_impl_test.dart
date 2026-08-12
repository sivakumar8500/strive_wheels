import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:wheels_rider/features/onboarding/data/repositories/onboarding_repository_impl.dart';

class MockOnboardingLocalDataSource extends Mock
    implements OnboardingLocalDataSource {}

void main() {
  late OnboardingRepositoryImpl repository;
  late MockOnboardingLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockOnboardingLocalDataSource();
    repository = OnboardingRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test('getOnboardingItems returns 2 items', () {
    final items = repository.getOnboardingItems();
    expect(items.length, 2);
  });

  test(
    'completeOnboarding calls localDataSource.setOnboardingCompleted',
    () async {
      when(
        () => mockLocalDataSource.setOnboardingCompleted(),
      ).thenAnswer((_) async {});

      await repository.completeOnboarding();

      verify(() => mockLocalDataSource.setOnboardingCompleted()).called(1);
    },
  );

  test(
    'isOnboardingCompleted calls localDataSource.isOnboardingCompleted',
    () async {
      when(
        () => mockLocalDataSource.isOnboardingCompleted(),
      ).thenAnswer((_) async => true);

      final result = await repository.isOnboardingCompleted();

      expect(result, isTrue);
      verify(() => mockLocalDataSource.isOnboardingCompleted()).called(1);
    },
  );
}

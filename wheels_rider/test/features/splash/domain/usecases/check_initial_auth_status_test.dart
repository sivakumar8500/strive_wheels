import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/splash/domain/repositories/splash_repository.dart';
import 'package:wheels_rider/features/splash/domain/usecases/check_initial_auth_status.dart';

class MockSplashRepository extends Mock implements SplashRepository {}

void main() {
  late CheckInitialAuthStatus usecase;
  late MockSplashRepository mockSplashRepository;

  setUp(() {
    mockSplashRepository = MockSplashRepository();
    usecase = CheckInitialAuthStatus(mockSplashRepository);
  });

  test('should return true when repository returns true', () async {
    when(
      () => mockSplashRepository.isUserAuthenticated(),
    ).thenAnswer((_) async => true);

    final result = await usecase();

    expect(result, isTrue);
    verify(() => mockSplashRepository.isUserAuthenticated()).called(1);
  });

  test('should return false when repository returns false', () async {
    when(
      () => mockSplashRepository.isUserAuthenticated(),
    ).thenAnswer((_) async => false);

    final result = await usecase();

    expect(result, isFalse);
    verify(() => mockSplashRepository.isUserAuthenticated()).called(1);
  });
}

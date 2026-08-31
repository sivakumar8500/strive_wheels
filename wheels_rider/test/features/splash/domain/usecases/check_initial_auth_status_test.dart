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

  test('should return InitialAuthData when repository is called', () async {
    when(() => mockSplashRepository.isUserAuthenticated()).thenAnswer((_) async => true);
    when(() => mockSplashRepository.getAuthStatus()).thenAnswer((_) async => 'approved');
    when(() => mockSplashRepository.getCurrentStep()).thenAnswer((_) async => 2);
    when(() => mockSplashRepository.getPhoneNumber()).thenAnswer((_) async => '1234567890');

    final result = await usecase();

    expect(result.isAuthenticated, isTrue);
    expect(result.authStatus, 'approved');
    expect(result.currentStep, 2);
    expect(result.phoneNumber, '1234567890');
    verify(() => mockSplashRepository.isUserAuthenticated()).called(1);
    verify(() => mockSplashRepository.getAuthStatus()).called(1);
    verify(() => mockSplashRepository.getCurrentStep()).called(1);
    verify(() => mockSplashRepository.getPhoneNumber()).called(1);
  });
}

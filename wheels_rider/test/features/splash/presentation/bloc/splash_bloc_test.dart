import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/splash/domain/usecases/check_initial_auth_status.dart';
import 'package:wheels_rider/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:wheels_rider/features/splash/presentation/bloc/splash_event.dart';
import 'package:wheels_rider/features/splash/presentation/bloc/splash_state.dart';

import 'package:wheels_rider/features/onboarding/domain/usecases/check_first_time_usecase.dart';

class MockCheckInitialAuthStatus extends Mock
    implements CheckInitialAuthStatus {}

class MockCheckFirstTimeUseCase extends Mock implements CheckFirstTimeUseCase {}

void main() {
  late MockCheckInitialAuthStatus mockCheckInitialAuthStatus;
  late MockCheckFirstTimeUseCase mockCheckFirstTimeUseCase;

  setUp(() {
    mockCheckInitialAuthStatus = MockCheckInitialAuthStatus();
    mockCheckFirstTimeUseCase = MockCheckFirstTimeUseCase();
  });

  group('SplashBloc Tests', () {
    test('initial state should be SplashInitial', () {
      final splashBloc = SplashBloc();
      expect(splashBloc.state, isA<SplashInitial>());
      splashBloc.close();
    });

    blocTest<SplashBloc, SplashState>(
      'emits [SplashLoading, SplashCompleted] when StartSplashEvent is added',
      build: () {
        when(() => mockCheckInitialAuthStatus()).thenAnswer((_) async => InitialAuthData(isAuthenticated: false));
        when(() => mockCheckFirstTimeUseCase()).thenAnswer((_) async => true);
        return SplashBloc(
          checkInitialAuthStatus: mockCheckInitialAuthStatus,
          checkFirstTimeUseCase: mockCheckFirstTimeUseCase,
        );
      },
      act: (bloc) => bloc.add(const StartSplashEvent()),
      wait: const Duration(seconds: 4),
      expect: () => [isA<SplashLoading>(), isA<SplashCompleted>()],
    );
  });
}

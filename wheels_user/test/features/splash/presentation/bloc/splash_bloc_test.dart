import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_event.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/onboarding/domain/usecases/check_first_time_usecase.dart';

class MockCheckFirstTimeUseCase extends Mock implements CheckFirstTimeUseCase {}

void main() {
  group('SplashBloc Tests', () {
    late SplashBloc splashBloc;
    late MockCheckFirstTimeUseCase mockCheckFirstTimeUseCase;

    setUp(() {
      mockCheckFirstTimeUseCase = MockCheckFirstTimeUseCase();
      when(() => mockCheckFirstTimeUseCase()).thenAnswer((_) async => true);
      splashBloc = SplashBloc(checkFirstTimeUseCase: mockCheckFirstTimeUseCase);
    });

    tearDown(() {
      splashBloc.close();
    });

    test('initial state should be SplashInitial', () {
      expect(splashBloc.state, isA<SplashInitial>());
    });

    blocTest<SplashBloc, SplashState>(
      'emits [SplashLoading, SplashCompleted] when StartSplashEvent is added',
      build: () {
        when(() => mockCheckFirstTimeUseCase()).thenAnswer((_) async => true);
        return SplashBloc(checkFirstTimeUseCase: mockCheckFirstTimeUseCase);
      },
      act: (bloc) => bloc.add(const StartSplashEvent()),
      wait: const Duration(seconds: 4),
      expect: () => [
        isA<SplashLoading>(),
        isA<SplashCompleted>(),
      ],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_event.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_state.dart';

void main() {
  group('SplashBloc Tests', () {
    late SplashBloc splashBloc;

    setUp(() {
      splashBloc = SplashBloc();
    });

    tearDown(() {
      splashBloc.close();
    });

    test('initial state should be SplashInitial', () {
      expect(splashBloc.state, isA<SplashInitial>());
    });

    blocTest<SplashBloc, SplashState>(
      'emits [SplashLoading, SplashCompleted] when StartSplashEvent is added',
      build: () => SplashBloc(),
      act: (bloc) => bloc.add(const StartSplashEvent()),
      wait: const Duration(seconds: 4),
      expect: () => [
        isA<SplashLoading>(),
        isA<SplashCompleted>(),
      ],
    );
  });
}

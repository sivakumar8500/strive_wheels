import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_event.dart';
import 'package:wheels_user/features/splash/presentation/bloc/splash_state.dart';

void main() {
  group('SplashBloc Tests', () {
    late SplashBloc splashBloc;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({'access_token': 'dummy_token'});
      prefs = await SharedPreferences.getInstance();
      splashBloc = SplashBloc(prefs);
    });

    tearDown(() {
      splashBloc.close();
    });

    test('initial state should be SplashInitial', () {
      expect(splashBloc.state, isA<SplashInitial>());
    });

    blocTest<SplashBloc, SplashState>(
      'emits [SplashLoading, SplashCompleted] when StartSplashEvent is added',
      build: () => SplashBloc(prefs),
      act: (bloc) => bloc.add(const StartSplashEvent()),
      wait: const Duration(seconds: 4),
      expect: () => [
        isA<SplashLoading>(),
        isA<SplashCompleted>(),
      ],
    );
  });
}

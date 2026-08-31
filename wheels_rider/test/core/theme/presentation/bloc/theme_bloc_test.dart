import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/theme/domain/usecases/get_theme_mode_usecase.dart';
import 'package:wheels_rider/core/theme/domain/usecases/set_theme_mode_usecase.dart';
import 'package:wheels_rider/core/theme/presentation/bloc/theme_bloc.dart';

class MockGetThemeModeUseCase extends Mock implements GetThemeModeUseCase {}

class MockSetThemeModeUseCase extends Mock implements SetThemeModeUseCase {}

void main() {
  late ThemeBloc themeBloc;
  late MockGetThemeModeUseCase mockGetThemeModeUseCase;
  late MockSetThemeModeUseCase mockSetThemeModeUseCase;

  setUp(() {
    mockGetThemeModeUseCase = MockGetThemeModeUseCase();
    mockSetThemeModeUseCase = MockSetThemeModeUseCase();
    themeBloc = ThemeBloc(
      getThemeModeUseCase: mockGetThemeModeUseCase,
      setThemeModeUseCase: mockSetThemeModeUseCase,
    );
  });

  tearDown(() {
    themeBloc.close();
  });

  group('ThemeBloc', () {
    test('initial state is ThemeMode.system', () {
      expect(themeBloc.state.themeMode, ThemeMode.system);
    });

    blocTest<ThemeBloc, ThemeState>(
      'emits updated themeMode when ThemeEvent.loadTheme is added',
      build: () {
        when(
          () => mockGetThemeModeUseCase(),
        ).thenAnswer((_) async => ThemeMode.dark);
        return themeBloc;
      },
      act: (bloc) => bloc.add(const ThemeEvent.loadTheme()),
      expect: () => const [ThemeState(themeMode: ThemeMode.dark)],
      verify: (_) {
        verify(() => mockGetThemeModeUseCase()).called(1);
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits changed themeMode when ThemeEvent.changeTheme is added',
      build: () {
        when(
          () => mockSetThemeModeUseCase(ThemeMode.light),
        ).thenAnswer((_) async {});
        return themeBloc;
      },
      act: (bloc) => bloc.add(const ThemeEvent.changeTheme(ThemeMode.light)),
      expect: () => const [ThemeState(themeMode: ThemeMode.light)],
      verify: (_) {
        verify(() => mockSetThemeModeUseCase(ThemeMode.light)).called(1);
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'toggles theme from system/light to dark when ThemeEvent.toggleTheme is added',
      build: () {
        when(
          () => mockSetThemeModeUseCase(ThemeMode.dark),
        ).thenAnswer((_) async {});
        return themeBloc;
      },
      act: (bloc) => bloc.add(const ThemeEvent.toggleTheme()),
      expect: () => const [ThemeState(themeMode: ThemeMode.dark)],
      verify: (_) {
        verify(() => mockSetThemeModeUseCase(ThemeMode.dark)).called(1);
      },
    );
  });
}

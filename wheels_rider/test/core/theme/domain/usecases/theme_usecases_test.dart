import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/theme/domain/repositories/theme_repository.dart';
import 'package:wheels_rider/core/theme/domain/usecases/get_theme_mode_usecase.dart';
import 'package:wheels_rider/core/theme/domain/usecases/set_theme_mode_usecase.dart';

class MockThemeRepository extends Mock implements ThemeRepository {}

void main() {
  late GetThemeModeUseCase getThemeModeUseCase;
  late SetThemeModeUseCase setThemeModeUseCase;
  late MockThemeRepository mockThemeRepository;

  setUp(() {
    mockThemeRepository = MockThemeRepository();
    getThemeModeUseCase = GetThemeModeUseCase(mockThemeRepository);
    setThemeModeUseCase = SetThemeModeUseCase(mockThemeRepository);
  });

  group('Theme UseCases', () {
    test('GetThemeModeUseCase should call repository.getThemeMode', () async {
      when(
        () => mockThemeRepository.getThemeMode(),
      ).thenAnswer((_) async => ThemeMode.light);

      final result = await getThemeModeUseCase();

      expect(result, ThemeMode.light);
      verify(() => mockThemeRepository.getThemeMode()).called(1);
    });

    test('SetThemeModeUseCase should call repository.setThemeMode', () async {
      when(
        () => mockThemeRepository.setThemeMode(ThemeMode.dark),
      ).thenAnswer((_) async {});

      await setThemeModeUseCase(ThemeMode.dark);

      verify(() => mockThemeRepository.setThemeMode(ThemeMode.dark)).called(1);
    });
  });
}

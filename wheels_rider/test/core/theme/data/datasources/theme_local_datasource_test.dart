import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_rider/core/theme/data/datasources/theme_local_datasource.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ThemeLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ThemeLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('ThemeLocalDataSourceImpl', () {
    test(
      'should return ThemeMode.light when saved string is "light"',
      () async {
        when(
          () => mockSharedPreferences.getString(
            ThemeLocalDataSourceImpl.themePreferenceKey,
          ),
        ).thenReturn('light');

        final result = await dataSource.getSavedThemeMode();

        expect(result, ThemeMode.light);
        verify(
          () => mockSharedPreferences.getString(
            ThemeLocalDataSourceImpl.themePreferenceKey,
          ),
        ).called(1);
      },
    );

    test('should return ThemeMode.dark when saved string is "dark"', () async {
      when(
        () => mockSharedPreferences.getString(
          ThemeLocalDataSourceImpl.themePreferenceKey,
        ),
      ).thenReturn('dark');

      final result = await dataSource.getSavedThemeMode();

      expect(result, ThemeMode.dark);
    });

    test(
      'should return ThemeMode.system when saved string is null or invalid',
      () async {
        when(
          () => mockSharedPreferences.getString(
            ThemeLocalDataSourceImpl.themePreferenceKey,
          ),
        ).thenReturn(null);

        final result = await dataSource.getSavedThemeMode();

        expect(result, ThemeMode.system);
      },
    );

    test(
      'should call setString with correct string when saveThemeMode is called',
      () async {
        when(
          () => mockSharedPreferences.setString(any(), any()),
        ).thenAnswer((_) async => true);

        await dataSource.saveThemeMode(ThemeMode.dark);

        verify(
          () => mockSharedPreferences.setString(
            ThemeLocalDataSourceImpl.themePreferenceKey,
            'dark',
          ),
        ).called(1);
      },
    );

    test('should call setString with "light" for ThemeMode.light', () async {
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      await dataSource.saveThemeMode(ThemeMode.light);

      verify(
        () => mockSharedPreferences.setString(
          ThemeLocalDataSourceImpl.themePreferenceKey,
          'light',
        ),
      ).called(1);
    });

    test('should call setString with "system" for ThemeMode.system', () async {
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      await dataSource.saveThemeMode(ThemeMode.system);

      verify(
        () => mockSharedPreferences.setString(
          ThemeLocalDataSourceImpl.themePreferenceKey,
          'system',
        ),
      ).called(1);
    });
  });
}

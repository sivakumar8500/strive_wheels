import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/theme/data/datasources/theme_local_datasource.dart';
import 'package:wheels_rider/core/theme/data/repositories/theme_repository_impl.dart';

class MockThemeLocalDataSource extends Mock implements ThemeLocalDataSource {}

void main() {
  late ThemeRepositoryImpl repository;
  late MockThemeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockThemeLocalDataSource();
    repository = ThemeRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('ThemeRepositoryImpl', () {
    test('should get theme mode from local data source', () async {
      when(
        () => mockLocalDataSource.getSavedThemeMode(),
      ).thenAnswer((_) async => ThemeMode.dark);

      final result = await repository.getThemeMode();

      expect(result, ThemeMode.dark);
      verify(() => mockLocalDataSource.getSavedThemeMode()).called(1);
    });

    test('should save theme mode to local data source', () async {
      when(
        () => mockLocalDataSource.saveThemeMode(ThemeMode.light),
      ).thenAnswer((_) async {});

      await repository.setThemeMode(ThemeMode.light);

      verify(
        () => mockLocalDataSource.saveThemeMode(ThemeMode.light),
      ).called(1);
    });
  });
}

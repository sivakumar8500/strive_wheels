import 'package:flutter/material.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_datasource.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<ThemeMode> getThemeMode() async {
    return await localDataSource.getSavedThemeMode();
  }

  @override
  Future<void> setThemeMode(ThemeMode themeMode) async {
    await localDataSource.saveThemeMode(themeMode);
  }
}

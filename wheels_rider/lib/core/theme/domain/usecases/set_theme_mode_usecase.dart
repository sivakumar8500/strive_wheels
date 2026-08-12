import 'package:flutter/material.dart';
import '../repositories/theme_repository.dart';

class SetThemeModeUseCase {
  final ThemeRepository repository;

  SetThemeModeUseCase(this.repository);

  Future<void> call(ThemeMode themeMode) async {
    await repository.setThemeMode(themeMode);
  }
}

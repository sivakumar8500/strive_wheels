import 'package:flutter/material.dart';
import '../repositories/theme_repository.dart';

class GetThemeModeUseCase {
  final ThemeRepository repository;

  GetThemeModeUseCase(this.repository);

  Future<ThemeMode> call() async {
    return await repository.getThemeMode();
  }
}

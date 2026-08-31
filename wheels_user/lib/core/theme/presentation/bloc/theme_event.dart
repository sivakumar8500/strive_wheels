import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_event.freezed.dart';

@freezed
class ThemeEvent with _$ThemeEvent {
  const factory ThemeEvent.loadTheme() = _LoadTheme;
  const factory ThemeEvent.changeTheme(ThemeMode themeMode) = _ChangeTheme;
  const factory ThemeEvent.toggleTheme() = _ToggleTheme;
}

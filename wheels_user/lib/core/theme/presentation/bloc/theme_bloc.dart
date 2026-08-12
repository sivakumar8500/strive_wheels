import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_theme_mode_usecase.dart';
import '../../domain/usecases/set_theme_mode_usecase.dart';
import 'theme_event.dart';
import 'theme_state.dart';

export 'theme_event.dart';
export 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeModeUseCase getThemeModeUseCase;
  final SetThemeModeUseCase setThemeModeUseCase;

  ThemeBloc({
    required this.getThemeModeUseCase,
    required this.setThemeModeUseCase,
  }) : super(ThemeState.initial()) {
    on<ThemeEvent>((event, emit) async {
      await event.map(
        loadTheme: (_) => _onLoadTheme(emit),
        changeTheme: (e) => _onChangeTheme(e.themeMode, emit),
        toggleTheme: (_) => _onToggleTheme(emit),
      );
    });
  }

  Future<void> _onLoadTheme(Emitter<ThemeState> emit) async {
    final themeMode = await getThemeModeUseCase();
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> _onChangeTheme(ThemeMode themeMode, Emitter<ThemeState> emit) async {
    await setThemeModeUseCase(themeMode);
    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> _onToggleTheme(Emitter<ThemeState> emit) async {
    final newMode = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeModeUseCase(newMode);
    emit(state.copyWith(themeMode: newMode));
  }
}

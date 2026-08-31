import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SharedPreferences _sharedPreferences;

  SplashBloc(this._sharedPreferences) : super(const SplashInitial()) {
    on<StartSplashEvent>(_onStartSplash);
  }

  Future<void> _onStartSplash(
    StartSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());
    // Simulate initialization delay / splash duration
    await Future.delayed(const Duration(seconds: 3));
    
    final token = _sharedPreferences.getString('access_token');
    final isAuthenticated = token != null && token.isNotEmpty;
    
    emit(SplashCompleted(isAuthenticated: isAuthenticated));
  }
}

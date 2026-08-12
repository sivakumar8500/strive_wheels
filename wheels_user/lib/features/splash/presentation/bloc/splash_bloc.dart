import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../onboarding/domain/usecases/check_first_time_usecase.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckFirstTimeUseCase checkFirstTimeUseCase;

  SplashBloc({required this.checkFirstTimeUseCase}) : super(const SplashInitial()) {
    on<StartSplashEvent>(_onStartSplash);
  }

  Future<void> _onStartSplash(
    StartSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashLoading());
    // Simulate initialization delay / splash duration
    await Future.delayed(const Duration(seconds: 3));
    final isFirstTime = await checkFirstTimeUseCase();
    emit(SplashCompleted(isFirstTime: isFirstTime));
  }
}

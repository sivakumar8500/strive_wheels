import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/check_initial_auth_status.dart';
import '../../../onboarding/domain/usecases/check_first_time_usecase.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckInitialAuthStatus? checkInitialAuthStatus;
  final CheckFirstTimeUseCase? checkFirstTimeUseCase;

  SplashBloc({this.checkInitialAuthStatus, this.checkFirstTimeUseCase})
    : super(SplashInitial()) {
    on<StartSplashEvent>(_onStartSplash);
  }

  Future<void> _onStartSplash(
    StartSplashEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 3));
    final isAuthenticated = await checkInitialAuthStatus?.call() ?? false;
    final isFirstTime = await checkFirstTimeUseCase?.call() ?? false;
    emit(
      SplashCompleted(
        isAuthenticated: isAuthenticated,
        isFirstTime: isFirstTime,
      ),
    );
  }
}

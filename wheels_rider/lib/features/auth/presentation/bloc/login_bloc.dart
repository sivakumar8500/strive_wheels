import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_with_phone_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginWithPhoneUseCase loginWithPhoneUseCase;

  LoginBloc({required this.loginWithPhoneUseCase})
    : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (event.phoneNumber.isEmpty || event.phoneNumber.length < 10) {
      emit(
        const LoginFailure(errorMessage: 'Please enter a valid mobile number'),
      );
      return;
    }

    emit(const LoginLoading());
    try {
      final success = await loginWithPhoneUseCase(event.phoneNumber);
      if (success) {
        emit(const LoginSuccess());
      } else {
        emit(
          const LoginFailure(errorMessage: 'Login failed. Please try again.'),
        );
      }
    } catch (e) {
      emit(LoginFailure(errorMessage: 'An error occurred: $e'));
    }
  }
}

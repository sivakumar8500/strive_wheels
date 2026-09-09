import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/login_request_entity.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SendOtpUseCase sendOtpUseCase;

  LoginBloc({required this.sendOtpUseCase}) : super(const LoginState()) {
    on<PhoneNumberChangedEvent>(_onPhoneNumberChanged);
    on<CountryCodeChangedEvent>(_onCountryCodeChanged);
    on<SubmitLoginEvent>(_onSubmitLogin);
  }

  void _onPhoneNumberChanged(
    PhoneNumberChangedEvent event,
    Emitter<LoginState> emit,
  ) {
    final phone = event.phoneNumber.trim();
    final isValid = phone.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone);
    emit(state.copyWith(
      phoneNumber: phone,
      isPhoneNumberValid: isValid,
      errorMessage: null,
    ));
  }

  void _onCountryCodeChanged(
    CountryCodeChangedEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      countryCode: event.countryCode,
    ));
  }

  Future<void> _onSubmitLogin(
    SubmitLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    if (!state.isPhoneNumberValid || state.isSubmitting) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final success = await sendOtpUseCase(
        LoginRequestEntity(
          countryCode: state.countryCode,
          phoneNumber: state.phoneNumber,
        ),
      );

      if (success) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to send OTP. Please try again.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'An unexpected error occurred.',
      ));
    }
  }
}

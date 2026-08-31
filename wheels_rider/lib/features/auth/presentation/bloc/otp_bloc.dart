import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/login_with_phone_usecase.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;
  final LoginWithPhoneUseCase loginWithPhoneUseCase; // for resend

  OtpBloc({required this.verifyOtpUseCase, required this.loginWithPhoneUseCase})
    : super(const OtpInitial()) {
    on<OtpCodeChanged>((event, emit) {
      if (state is OtpFailure) {
        emit(const OtpInitial());
      }
    });

    on<OtpSubmitted>((event, emit) async {
      emit(const OtpLoading());
      try {
        final authResult = await verifyOtpUseCase(event.phoneNumber, event.otpCode);
        emit(OtpSuccess(authResult: authResult));
      } catch (e) {
        emit(
          OtpFailure(errorMessage: e.toString().replaceAll('Exception: ', '')),
        );
      }
    });

    on<OtpResendRequested>((event, emit) async {
      emit(const OtpLoading());
      try {
        final success = await loginWithPhoneUseCase(event.phoneNumber);
        if (success) {
          emit(const OtpResendSuccess());
          emit(const OtpInitial());
        } else {
          emit(const OtpFailure(errorMessage: 'Failed to resend OTP.'));
        }
      } catch (e) {
        emit(
          OtpFailure(errorMessage: e.toString().replaceAll('Exception: ', '')),
        );
      }
    });
  }
}

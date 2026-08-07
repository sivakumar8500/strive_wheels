import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/otp_verification_entity.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  Timer? _timer;

  OtpBloc({
    required String fullPhoneNumber,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  }) : super(OtpState(fullPhoneNumber: fullPhoneNumber)) {
    on<OtpCodeChangedEvent>(_onOtpCodeChanged);
    on<SubmitOtpEvent>(_onSubmitOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<StartTimerEvent>(_onStartTimer);
    on<TimerTickEvent>(_onTimerTick);

    add(const StartTimerEvent());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onStartTimer(StartTimerEvent event, Emitter<OtpState> emit) {
    _timer?.cancel();
    emit(state.copyWith(countdownSeconds: 30));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = 30 - timer.tick;
      if (remaining <= 0) {
        timer.cancel();
        add(const TimerTickEvent(0));
      } else {
        add(TimerTickEvent(remaining));
      }
    });
  }

  void _onTimerTick(TimerTickEvent event, Emitter<OtpState> emit) {
    emit(state.copyWith(countdownSeconds: event.secondsRemaining));
  }

  void _onOtpCodeChanged(OtpCodeChangedEvent event, Emitter<OtpState> emit) {
    final code = event.code.trim();
    final isValid = code.length == 6 && RegExp(r'^[0-9]+$').hasMatch(code);
    emit(state.copyWith(
      otpCode: code,
      isOtpValid: isValid,
      errorMessage: null,
    ));
  }

  Future<void> _onSubmitOtp(SubmitOtpEvent event, Emitter<OtpState> emit) async {
    if (!state.isOtpValid || state.isSubmitting) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final success = await verifyOtpUseCase(
        OtpVerificationEntity(
          fullPhoneNumber: state.fullPhoneNumber,
          otpCode: state.otpCode,
        ),
      );

      if (success) {
        _timer?.cancel();
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Invalid OTP verification code.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'An unexpected error occurred.',
      ));
    }
  }

  Future<void> _onResendOtp(ResendOtpEvent event, Emitter<OtpState> emit) async {
    if (state.countdownSeconds > 0 || state.isResending) return;

    emit(state.copyWith(isResending: true, errorMessage: null));

    try {
      final success = await resendOtpUseCase(state.fullPhoneNumber);
      if (success) {
        emit(state.copyWith(isResending: false));
        add(const StartTimerEvent());
      } else {
        emit(state.copyWith(
          isResending: false,
          errorMessage: 'Failed to resend OTP. Please try again.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isResending: false,
        errorMessage: 'An unexpected error occurred.',
      ));
    }
  }
}

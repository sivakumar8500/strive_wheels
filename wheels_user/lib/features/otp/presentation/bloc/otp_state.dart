import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_state.freezed.dart';

@freezed
abstract class OtpState with _$OtpState {
  const OtpState._();

  const factory OtpState({
    required String fullPhoneNumber,
    @Default('') String otpCode,
    @Default(false) bool isOtpValid,
    @Default(30) int countdownSeconds,
    @Default(false) bool isSubmitting,
    @Default(false) bool isSuccess,
    @Default(false) bool isResending,
    String? errorMessage,
  }) = _OtpState;
}

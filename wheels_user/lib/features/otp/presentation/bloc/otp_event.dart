import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_event.freezed.dart';

@freezed
class OtpEvent with _$OtpEvent {
  const factory OtpEvent.otpCodeChanged(String code) = OtpCodeChangedEvent;
  const factory OtpEvent.submitOtp() = SubmitOtpEvent;
  const factory OtpEvent.resendOtp() = ResendOtpEvent;
  const factory OtpEvent.startTimer() = StartTimerEvent;
  const factory OtpEvent.timerTick(int secondsRemaining) = TimerTickEvent;
}

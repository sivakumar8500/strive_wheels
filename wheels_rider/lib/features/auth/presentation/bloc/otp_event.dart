import 'package:flutter/foundation.dart';

@immutable
abstract class OtpEvent {
  const OtpEvent();
}

class OtpCodeChanged extends OtpEvent {
  final String otpCode;

  const OtpCodeChanged(this.otpCode);
}

class OtpSubmitted extends OtpEvent {
  final String phoneNumber;
  final String otpCode;

  const OtpSubmitted({required this.phoneNumber, required this.otpCode});
}

class OtpResendRequested extends OtpEvent {
  final String phoneNumber;

  const OtpResendRequested(this.phoneNumber);
}

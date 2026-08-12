import 'package:flutter/foundation.dart';

@immutable
abstract class OtpState {
  const OtpState();
}

class OtpInitial extends OtpState {
  const OtpInitial();
}

class OtpLoading extends OtpState {
  const OtpLoading();
}

class OtpSuccess extends OtpState {
  const OtpSuccess();
}

class OtpFailure extends OtpState {
  final String errorMessage;

  const OtpFailure({required this.errorMessage});
}

class OtpResendSuccess extends OtpState {
  const OtpResendSuccess();
}

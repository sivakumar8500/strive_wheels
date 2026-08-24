import 'package:flutter/foundation.dart';
import '../../domain/repositories/auth_repository.dart';

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
  final AuthStatus authStatus;
  const OtpSuccess({required this.authStatus});
}

class OtpFailure extends OtpState {
  final String errorMessage;

  const OtpFailure({required this.errorMessage});
}

class OtpResendSuccess extends OtpState {
  const OtpResendSuccess();
}

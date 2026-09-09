import 'package:flutter/foundation.dart';
import '../../domain/entities/auth_result.dart';

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
  final AuthResult authResult;
  const OtpSuccess({required this.authResult});
}

class OtpFailure extends OtpState {
  final String errorMessage;

  const OtpFailure({required this.errorMessage});
}

class OtpResendSuccess extends OtpState {
  const OtpResendSuccess();
}


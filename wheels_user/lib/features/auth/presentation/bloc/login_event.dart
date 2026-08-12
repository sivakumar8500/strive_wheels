import 'package:flutter/foundation.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class LoginPhoneNumberChanged extends LoginEvent {
  final String phoneNumber;

  const LoginPhoneNumberChanged(this.phoneNumber);
}

class LoginSubmitted extends LoginEvent {
  final String phoneNumber;

  const LoginSubmitted(this.phoneNumber);
}

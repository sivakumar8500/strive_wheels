import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_event.freezed.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.phoneNumberChanged(String phoneNumber) = PhoneNumberChangedEvent;
  const factory LoginEvent.countryCodeChanged(String countryCode) = CountryCodeChangedEvent;
  const factory LoginEvent.submitLogin() = SubmitLoginEvent;
}

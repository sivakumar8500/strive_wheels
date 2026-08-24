import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_registration.freezed.dart';
part 'driver_registration.g.dart';

@freezed
abstract class DriverRegistration with _$DriverRegistration {
  const factory DriverRegistration({
    @JsonKey(name: 'registration_id') int? registrationId,
    String? status,
    @JsonKey(name: 'is_completed') bool? isCompleted,
    @JsonKey(name: 'current_step') int? currentStep,
  }) = _DriverRegistration;

  factory DriverRegistration.fromJson(Map<String, dynamic> json) => _$DriverRegistrationFromJson(json);
}

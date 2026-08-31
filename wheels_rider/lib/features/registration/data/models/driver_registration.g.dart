// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_registration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriverRegistration _$DriverRegistrationFromJson(Map<String, dynamic> json) =>
    _DriverRegistration(
      registrationId: (json['registration_id'] as num?)?.toInt(),
      status: json['status'] as String?,
      isCompleted: json['is_completed'] as bool?,
      currentStep: (json['current_step'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DriverRegistrationToJson(_DriverRegistration instance) =>
    <String, dynamic>{
      'registration_id': instance.registrationId,
      'status': instance.status,
      'is_completed': instance.isCompleted,
      'current_step': instance.currentStep,
    };

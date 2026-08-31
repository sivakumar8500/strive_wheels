// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_step_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegistrationStepResponse _$RegistrationStepResponseFromJson(
  Map<String, dynamic> json,
) => _RegistrationStepResponse(
  success: json['success'] as bool,
  data: RegistrationStepData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegistrationStepResponseToJson(
  _RegistrationStepResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_RegistrationStepData _$RegistrationStepDataFromJson(
  Map<String, dynamic> json,
) => _RegistrationStepData(
  registrationId: (json['registration_id'] as num).toInt(),
  status: json['status'] as String,
  currentStep: (json['current_step'] as num).toInt(),
  totalSteps: (json['total_steps'] as num).toInt(),
  progressPercentage: (json['progress_percentage'] as num).toDouble(),
  completedSteps: (json['completed_steps'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  nextStep: (json['next_step'] as num?)?.toInt(),
  message: json['message'] as String,
);

Map<String, dynamic> _$RegistrationStepDataToJson(
  _RegistrationStepData instance,
) => <String, dynamic>{
  'registration_id': instance.registrationId,
  'status': instance.status,
  'current_step': instance.currentStep,
  'total_steps': instance.totalSteps,
  'progress_percentage': instance.progressPercentage,
  'completed_steps': instance.completedSteps,
  'next_step': instance.nextStep,
  'message': instance.message,
};

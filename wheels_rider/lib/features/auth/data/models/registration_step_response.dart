import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_step_response.freezed.dart';
part 'registration_step_response.g.dart';

@freezed
abstract class RegistrationStepResponse with _$RegistrationStepResponse {
  const factory RegistrationStepResponse({
    required bool success,
    required RegistrationStepData data,
  }) = _RegistrationStepResponse;

  factory RegistrationStepResponse.fromJson(Map<String, dynamic> json) => _$RegistrationStepResponseFromJson(json);
}

@freezed
abstract class RegistrationStepData with _$RegistrationStepData {
  const factory RegistrationStepData({
    @JsonKey(name: 'registration_id') required int registrationId,
    required String status,
    @JsonKey(name: 'current_step') required int currentStep,
    @JsonKey(name: 'total_steps') required int totalSteps,
    @JsonKey(name: 'progress_percentage') required double progressPercentage,
    @JsonKey(name: 'completed_steps') required List<int> completedSteps,
    @JsonKey(name: 'next_step') int? nextStep,
    required String message,
  }) = _RegistrationStepData;

  factory RegistrationStepData.fromJson(Map<String, dynamic> json) => _$RegistrationStepDataFromJson(json);
}

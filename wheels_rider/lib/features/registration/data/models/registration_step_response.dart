import 'registration_data.dart';

class RegistrationStepResponse {
  final bool success;
  final String message;
  final RegistrationStepData? data;

  const RegistrationStepResponse({
    this.success = true,
    this.message = '',
    this.data,
  });

  factory RegistrationStepResponse.fromJson(Map<String, dynamic> json) {
    final topMessage = json['message'] as String? ?? '';
    RegistrationStepData? dataObj;
    if (json['data'] is Map<String, dynamic>) {
      dataObj = RegistrationStepData.fromJson(
        json['data'] as Map<String, dynamic>,
        fallbackMessage: topMessage,
      );
    } else if (json['data'] is Map) {
      dataObj = RegistrationStepData.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
        fallbackMessage: topMessage,
      );
    }
    return RegistrationStepResponse(
      success: json['success'] as bool? ?? true,
      message: topMessage,
      data: dataObj,
    );
  }
}

class RegistrationStepData {
  final int? registrationId;
  final String status;
  final int currentStep;
  final int totalSteps;
  final double progressPercentage;
  final List<int> completedSteps;
  final int? nextStep;
  final String message;
  final RegistrationData? registrationData;

  const RegistrationStepData({
    this.registrationId,
    this.status = 'IN_PROGRESS',
    this.currentStep = 1,
    this.totalSteps = 9,
    this.progressPercentage = 0.0,
    this.completedSteps = const [],
    this.nextStep,
    this.message = '',
    this.registrationData,
  });

  factory RegistrationStepData.fromJson(
    Map<String, dynamic> json, {
    String fallbackMessage = '',
  }) {
    final rawCompleted = json['completed_steps'];
    final completedList = rawCompleted is List
        ? rawCompleted.map((e) => int.tryParse(e.toString()) ?? 0).toList()
        : <int>[];

    final msg = (json['message'] as String?)?.isNotEmpty == true
        ? json['message'] as String
        : fallbackMessage;

    return RegistrationStepData(
      registrationId: json['registration_id'] as int?,
      status: json['status'] as String? ?? 'IN_PROGRESS',
      currentStep: json['current_step'] as int? ?? 1,
      totalSteps: json['total_steps'] as int? ?? 9,
      progressPercentage: (json['progress_percentage'] as num?)?.toDouble() ?? 0.0,
      completedSteps: completedList,
      nextStep: json['next_step'] as int?,
      message: msg,
      registrationData: RegistrationData.fromJson(json),
    );
  }
}

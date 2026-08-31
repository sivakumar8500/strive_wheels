import 'package:flutter/foundation.dart';
import '../../data/models/registration_data.dart';

enum RegistrationStatus { initial, loading, success, failure }

@immutable
class RegistrationState {
  final int currentStep;
  final RegistrationData data;
  final RegistrationStatus status;
  final String? errorMessage;

  const RegistrationState({
    required this.currentStep,
    required this.data,
    this.status = RegistrationStatus.initial,
    this.errorMessage,
  });

  factory RegistrationState.initial() {
    return const RegistrationState(
      currentStep: 2, // Default to Step 2 (Personal Info)
      data: RegistrationData(),
    );
  }

  RegistrationState copyWith({
    int? currentStep,
    RegistrationData? data,
    RegistrationStatus? status,
    String? errorMessage,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      data: data ?? this.data,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

import 'package:flutter/foundation.dart';
import '../../data/models/registration_data.dart';

@immutable
class RegistrationState {
  final int currentStep;
  final RegistrationData data;

  const RegistrationState({
    required this.currentStep,
    required this.data,
  });

  factory RegistrationState.initial() {
    return const RegistrationState(
      currentStep: 1, // Steps 1 to 10
      data: RegistrationData(),
    );
  }

  RegistrationState copyWith({
    int? currentStep,
    RegistrationData? data,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      data: data ?? this.data,
    );
  }
}

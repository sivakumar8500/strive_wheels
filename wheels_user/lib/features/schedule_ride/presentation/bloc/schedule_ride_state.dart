import '../../domain/entities/schedule_ride_entity.dart';

class ScheduleRideState {
  final bool isLoading;
  final ScheduleRideEntity? rideDetails;
  final String selectedDate;
  final bool isAm;
  final bool instantNotification;
  final bool isConfirmed;
  final String? errorMessage;

  const ScheduleRideState({
    this.isLoading = false,
    this.rideDetails,
    this.selectedDate = 'Fri 24',
    this.isAm = true,
    this.instantNotification = true,
    this.isConfirmed = false,
    this.errorMessage,
  });

  ScheduleRideState copyWith({
    bool? isLoading,
    ScheduleRideEntity? rideDetails,
    String? selectedDate,
    bool? isAm,
    bool? instantNotification,
    bool? isConfirmed,
    String? errorMessage,
  }) {
    return ScheduleRideState(
      isLoading: isLoading ?? this.isLoading,
      rideDetails: rideDetails ?? this.rideDetails,
      selectedDate: selectedDate ?? this.selectedDate,
      isAm: isAm ?? this.isAm,
      instantNotification: instantNotification ?? this.instantNotification,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      errorMessage: errorMessage,
    );
  }
}

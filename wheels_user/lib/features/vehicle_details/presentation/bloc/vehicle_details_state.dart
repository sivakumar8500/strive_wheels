import '../../domain/entities/vehicle_details_entity.dart';

class VehicleDetailsState {
  final bool isLoading;
  final VehicleDetailsEntity? vehicleDetails;
  final bool isBookingConfirmed;
  final String? actionMessage;
  final String? errorMessage;

  const VehicleDetailsState({
    this.isLoading = false,
    this.vehicleDetails,
    this.isBookingConfirmed = false,
    this.actionMessage,
    this.errorMessage,
  });

  VehicleDetailsState copyWith({
    bool? isLoading,
    VehicleDetailsEntity? vehicleDetails,
    bool? isBookingConfirmed,
    String? actionMessage,
    String? errorMessage,
  }) {
    return VehicleDetailsState(
      isLoading: isLoading ?? this.isLoading,
      vehicleDetails: vehicleDetails ?? this.vehicleDetails,
      isBookingConfirmed: isBookingConfirmed ?? this.isBookingConfirmed,
      actionMessage: actionMessage,
      errorMessage: errorMessage,
    );
  }
}

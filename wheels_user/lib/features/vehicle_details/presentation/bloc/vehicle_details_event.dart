abstract class VehicleDetailsEvent {
  const VehicleDetailsEvent();
}

class LoadVehicleDetailsEvent extends VehicleDetailsEvent {
  final String vehicleId;

  const LoadVehicleDetailsEvent(this.vehicleId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadVehicleDetailsEvent &&
          runtimeType == other.runtimeType &&
          vehicleId == other.vehicleId;

  @override
  int get hashCode => vehicleId.hashCode;
}

class ConfirmVehicleBookingEvent extends VehicleDetailsEvent {
  final String vehicleId;

  const ConfirmVehicleBookingEvent(this.vehicleId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfirmVehicleBookingEvent &&
          runtimeType == other.runtimeType &&
          vehicleId == other.vehicleId;

  @override
  int get hashCode => vehicleId.hashCode;
}

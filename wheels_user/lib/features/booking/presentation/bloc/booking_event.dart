abstract class BookingEvent {
  const BookingEvent();
}

class LoadBookingDataEvent extends BookingEvent {
  const LoadBookingDataEvent();
}

class ChangePickupLocationEvent extends BookingEvent {
  final String location;

  const ChangePickupLocationEvent(this.location);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangePickupLocationEvent &&
          runtimeType == other.runtimeType &&
          location == other.location;

  @override
  int get hashCode => location.hashCode;
}

class ChangeDestinationEvent extends BookingEvent {
  final String destination;

  const ChangeDestinationEvent(this.destination);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeDestinationEvent &&
          runtimeType == other.runtimeType &&
          destination == other.destination;

  @override
  int get hashCode => destination.hashCode;
}

class SelectRideTypeTabEvent extends BookingEvent {
  final int tabIndex; // 0: Instant, 1: One Way, 2: Round Trip

  const SelectRideTypeTabEvent(this.tabIndex);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectRideTypeTabEvent &&
          runtimeType == other.runtimeType &&
          tabIndex == other.tabIndex;

  @override
  int get hashCode => tabIndex.hashCode;
}

class SelectRecentJourneyEvent extends BookingEvent {
  final String journeyTitle;

  const SelectRecentJourneyEvent(this.journeyTitle);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectRecentJourneyEvent &&
          runtimeType == other.runtimeType &&
          journeyTitle == other.journeyTitle;

  @override
  int get hashCode => journeyTitle.hashCode;
}

class SearchVehiclesEvent extends BookingEvent {
  const SearchVehiclesEvent();
}

class SelectVehicleEvent extends BookingEvent {
  final String vehicleId;
  final String vehicleName;

  const SelectVehicleEvent({
    required this.vehicleId,
    required this.vehicleName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectVehicleEvent &&
          runtimeType == other.runtimeType &&
          vehicleId == other.vehicleId &&
          vehicleName == other.vehicleName;

  @override
  int get hashCode => vehicleId.hashCode ^ vehicleName.hashCode;
}

class BookVehicleNowEvent extends BookingEvent {
  final String vehicleId;
  final String vehicleName;

  const BookVehicleNowEvent({
    required this.vehicleId,
    required this.vehicleName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookVehicleNowEvent &&
          runtimeType == other.runtimeType &&
          vehicleId == other.vehicleId &&
          vehicleName == other.vehicleName;

  @override
  int get hashCode => vehicleId.hashCode ^ vehicleName.hashCode;
}

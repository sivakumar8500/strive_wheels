abstract class RideHistoryEvent {
  const RideHistoryEvent();
}

class LoadRideHistoryEvent extends RideHistoryEvent {
  const LoadRideHistoryEvent();
}

class FilterTripsTabEvent extends RideHistoryEvent {
  final int filterIndex; // 0: All trips, 1: Rides, 2: Deliveries

  const FilterTripsTabEvent(this.filterIndex);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterTripsTabEvent &&
          runtimeType == other.runtimeType &&
          filterIndex == other.filterIndex;

  @override
  int get hashCode => filterIndex.hashCode;
}

class BookAgainEvent extends RideHistoryEvent {
  final String rideId;
  final String rideTitle;

  const BookAgainEvent({
    required this.rideId,
    required this.rideTitle,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAgainEvent &&
          runtimeType == other.runtimeType &&
          rideId == other.rideId &&
          rideTitle == other.rideTitle;

  @override
  int get hashCode => rideId.hashCode ^ rideTitle.hashCode;
}

class OpenFilterOptionsEvent extends RideHistoryEvent {
  const OpenFilterOptionsEvent();
}

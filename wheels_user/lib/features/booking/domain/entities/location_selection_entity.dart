class LocationSelectionEntity {
  final String pickupLocation;
  final String destination;
  final int selectedRideTypeIndex; // 0: Instant, 1: One Way, 2: Round Trip

  const LocationSelectionEntity({
    required this.pickupLocation,
    required this.destination,
    required this.selectedRideTypeIndex,
  });
}

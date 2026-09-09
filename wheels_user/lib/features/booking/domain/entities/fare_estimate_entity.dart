class FareEstimateEntity {
  final String serviceMode;
  final int vehicleTypeId;
  final double estimatedDistanceKm;
  final int estimatedDurationMins;
  final double baseFare;
  final double distanceCharge;
  final double timeCharge;
  final double waitingCharge;
  final double discountAmount;
  final double surgeMultiplier;
  final double estimatedFare;

  const FareEstimateEntity({
    required this.serviceMode,
    required this.vehicleTypeId,
    required this.estimatedDistanceKm,
    required this.estimatedDurationMins,
    required this.baseFare,
    required this.distanceCharge,
    required this.timeCharge,
    required this.waitingCharge,
    required this.discountAmount,
    required this.surgeMultiplier,
    required this.estimatedFare,
  });
}

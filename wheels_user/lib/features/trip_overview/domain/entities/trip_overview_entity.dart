class TripOverviewEntity {
  final String pickupLocation;
  final String destination;
  final String tripType;
  final String distanceText;
  final String vehicleName;
  final String vehicleSeats;
  final String vehicleLuggage;
  final String vehicleAmenity;
  final String vehicleImagePath;
  final double walletBalance;
  final double baseFare;
  final double distanceCharge;
  final double serviceSurcharge;
  final double taxesFees;
  final double grandTotal;
  final String currency;

  const TripOverviewEntity({
    required this.pickupLocation,
    required this.destination,
    required this.tripType,
    required this.distanceText,
    required this.vehicleName,
    required this.vehicleSeats,
    required this.vehicleLuggage,
    required this.vehicleAmenity,
    required this.vehicleImagePath,
    required this.walletBalance,
    required this.baseFare,
    required this.distanceCharge,
    required this.serviceSurcharge,
    required this.taxesFees,
    required this.grandTotal,
    required this.currency,
  });
}

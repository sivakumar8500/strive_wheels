class CorporateWaypointEntity {
  final int bookingId;
  final String passengerName;
  final int? seatNumber;
  final String pickupAddress;
  final double pickupLat;
  final double pickupLng;
  final String dropAddress;
  final double dropLat;
  final double dropLng;
  final String status;

  const CorporateWaypointEntity({
    required this.bookingId,
    required this.passengerName,
    this.seatNumber,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropAddress,
    required this.dropLat,
    required this.dropLng,
    this.status = 'ACTIVE',
  });
}

class CorporateAlignedVehicleEntity {
  final int id;
  final int companyId;
  final int riderId;
  final int? vehicleId;
  final String driverName;
  final String? driverPhone;
  final double driverRating;
  final String vehicleName;
  final String licensePlate;
  final int vehicleTypeId;
  final String vehicleTypeName;
  final String routeFrom;
  final String routeTo;
  final double? routeFromLat;
  final double? routeFromLng;
  final double? routeToLat;
  final double? routeToLng;
  final bool isAligned;
  final String alignmentLabel;
  final int seats;
  final int availableSeats;
  final int occupiedSeats;
  final List<int> availableSeatNumbers;
  final List<CorporateWaypointEntity> waypoints;

  const CorporateAlignedVehicleEntity({
    required this.id,
    required this.companyId,
    required this.riderId,
    this.vehicleId,
    required this.driverName,
    this.driverPhone,
    this.driverRating = 4.9,
    required this.vehicleName,
    required this.licensePlate,
    required this.vehicleTypeId,
    required this.vehicleTypeName,
    required this.routeFrom,
    required this.routeTo,
    this.routeFromLat,
    this.routeFromLng,
    this.routeToLat,
    this.routeToLng,
    this.isAligned = false,
    required this.alignmentLabel,
    this.seats = 4,
    this.availableSeats = 4,
    this.occupiedSeats = 0,
    this.availableSeatNumbers = const [1, 2, 3, 4],
    this.waypoints = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CorporateAlignedVehicleEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          riderId == other.riderId &&
          companyId == other.companyId;

  @override
  int get hashCode => id.hashCode ^ riderId.hashCode ^ companyId.hashCode;
}

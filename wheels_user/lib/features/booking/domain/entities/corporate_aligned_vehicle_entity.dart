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

class VehicleTypeEntity {
  final int id;
  final String code;
  final String name;
  final String? description;
  final String? iconUrl;
  final int maxPassengers;
  final double maxWeightKg;
  final bool isActive;
  final String? createdAt;

  const VehicleTypeEntity({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.iconUrl,
    this.maxPassengers = 1,
    this.maxWeightKg = 0.0,
    this.isActive = true,
    this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleTypeEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code;

  @override
  int get hashCode => id.hashCode ^ code.hashCode;
}

import '../../domain/entities/corporate_aligned_vehicle_entity.dart';

class CorporateAlignedVehicleModel extends CorporateAlignedVehicleEntity {
  const CorporateAlignedVehicleModel({
    required super.id,
    required super.companyId,
    required super.riderId,
    super.vehicleId,
    required super.driverName,
    super.driverPhone,
    super.driverRating,
    required super.vehicleName,
    required super.licensePlate,
    required super.vehicleTypeId,
    required super.vehicleTypeName,
    required super.routeFrom,
    required super.routeTo,
    super.routeFromLat,
    super.routeFromLng,
    super.routeToLat,
    super.routeToLng,
    super.isAligned,
    required super.alignmentLabel,
    super.seats,
  });

  factory CorporateAlignedVehicleModel.fromJson(Map<String, dynamic> json) {
    return CorporateAlignedVehicleModel(
      id: json['id'] as int? ?? 0,
      companyId: json['company_id'] as int? ?? 0,
      riderId: json['rider_id'] as int? ?? 0,
      vehicleId: json['vehicle_id'] as int?,
      driverName: json['driver_name'] as String? ?? 'Assigned Corporate Driver',
      driverPhone: json['driver_phone'] as String?,
      driverRating: (json['driver_rating'] as num?)?.toDouble() ?? 4.9,
      vehicleName: json['vehicle_name'] as String? ?? 'Corporate Vehicle',
      licensePlate: json['license_plate'] as String? ?? 'TS09CORP',
      vehicleTypeId: json['vehicle_type_id'] as int? ?? 1,
      vehicleTypeName: json['vehicle_type_name'] as String? ?? 'Cab',
      routeFrom: json['route_from'] as String? ?? 'Office',
      routeTo: json['route_to'] as String? ?? 'Assigned Route',
      routeFromLat: (json['route_from_lat'] as num?)?.toDouble(),
      routeFromLng: (json['route_from_lng'] as num?)?.toDouble(),
      routeToLat: (json['route_to_lat'] as num?)?.toDouble(),
      routeToLng: (json['route_to_lng'] as num?)?.toDouble(),
      isAligned: json['is_aligned'] as bool? ?? false,
      alignmentLabel: json['alignment_label'] as String? ?? 'Route Corridor',
      seats: json['seats'] as int? ?? 4,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'rider_id': riderId,
      'vehicle_id': vehicleId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'driver_rating': driverRating,
      'vehicle_name': vehicleName,
      'license_plate': licensePlate,
      'vehicle_type_id': vehicleTypeId,
      'vehicle_type_name': vehicleTypeName,
      'route_from': routeFrom,
      'route_to': routeTo,
      'route_from_lat': routeFromLat,
      'route_from_lng': routeFromLng,
      'route_to_lat': routeToLat,
      'route_to_lng': routeToLng,
      'is_aligned': isAligned,
      'alignment_label': alignmentLabel,
      'seats': seats,
    };
  }

  CorporateAlignedVehicleEntity toEntity() => this;
}

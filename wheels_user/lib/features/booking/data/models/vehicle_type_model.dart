import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/vehicle_type_entity.dart';

part 'vehicle_type_model.freezed.dart';

double _toDouble(dynamic val) => (val as num?)?.toDouble() ?? 0.0;

@freezed
abstract class VehicleTypeModel with _$VehicleTypeModel {
  const factory VehicleTypeModel({
    required int id,
    required String code,
    required String name,
    String? description,
    String? iconUrl,
    @Default(1) int maxPassengers,
    @Default(0.0) double maxWeightKg,
    @Default(true) bool isActive,
    String? createdAt,
  }) = _VehicleTypeModel;

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    final String? image = (json['icon_url'] ??
            json['image_url'] ??
            json['icon'] ??
            json['image'] ??
            json['vehicle_image'] ??
            json['photo_url'])
        ?.toString();

    return VehicleTypeModel(
      id: (json['id'] is num)
          ? (json['id'] as num).toInt()
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      iconUrl: image,
      maxPassengers: (json['max_passengers'] is num)
          ? (json['max_passengers'] as num).toInt()
          : (int.tryParse(json['max_passengers']?.toString() ?? '1') ?? 1),
      maxWeightKg: _toDouble(json['max_weight_kg']),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at']?.toString(),
    );
  }
}

extension VehicleTypeModelX on VehicleTypeModel {
  VehicleTypeEntity toEntity() => VehicleTypeEntity(
        id: id,
        code: code,
        name: name,
        description: description,
        iconUrl: iconUrl,
        maxPassengers: maxPassengers,
        maxWeightKg: maxWeightKg,
        isActive: isActive,
        createdAt: createdAt,
      );
}

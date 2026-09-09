import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/vehicle_type_entity.dart';

part 'vehicle_type_model.freezed.dart';
part 'vehicle_type_model.g.dart';

double _toDouble(dynamic val) => (val as num?)?.toDouble() ?? 0.0;

@freezed
abstract class VehicleTypeModel with _$VehicleTypeModel {
  const factory VehicleTypeModel({
    required int id,
    required String code,
    required String name,
    String? description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'max_passengers') @Default(1) int maxPassengers,
    @JsonKey(name: 'max_weight_kg', fromJson: _toDouble)
    @Default(0.0)
    double maxWeightKg,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _VehicleTypeModel;

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleTypeModelFromJson(json);
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

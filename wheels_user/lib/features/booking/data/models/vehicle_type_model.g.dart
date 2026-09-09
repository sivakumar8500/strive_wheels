// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VehicleTypeModel _$VehicleTypeModelFromJson(Map<String, dynamic> json) =>
    _VehicleTypeModel(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      maxPassengers: (json['max_passengers'] as num?)?.toInt() ?? 1,
      maxWeightKg: json['max_weight_kg'] == null
          ? 0.0
          : _toDouble(json['max_weight_kg']),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$VehicleTypeModelToJson(_VehicleTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'max_passengers': instance.maxPassengers,
      'max_weight_kg': instance.maxWeightKg,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
    };

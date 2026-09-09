// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_estimate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FareEstimateModel _$FareEstimateModelFromJson(Map<String, dynamic> json) =>
    _FareEstimateModel(
      serviceMode: json['service_mode'] as String? ?? 'NORMAL',
      vehicleTypeId: (json['vehicle_type_id'] as num?)?.toInt() ?? 1,
      estimatedDistanceKm:
          (json['estimated_distance_km'] as num?)?.toDouble() ?? 0.0,
      estimatedDurationMins:
          (json['estimated_duration_mins'] as num?)?.toInt() ?? 0,
      baseFare: (json['base_fare'] as num?)?.toDouble() ?? 0.0,
      distanceCharge: (json['distance_charge'] as num?)?.toDouble() ?? 0.0,
      timeCharge: (json['time_charge'] as num?)?.toDouble() ?? 0.0,
      waitingCharge: (json['waiting_charge'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      surgeMultiplier: (json['surge_multiplier'] as num?)?.toDouble() ?? 1.0,
      estimatedFare: (json['estimated_fare'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$FareEstimateModelToJson(_FareEstimateModel instance) =>
    <String, dynamic>{
      'service_mode': instance.serviceMode,
      'vehicle_type_id': instance.vehicleTypeId,
      'estimated_distance_km': instance.estimatedDistanceKm,
      'estimated_duration_mins': instance.estimatedDurationMins,
      'base_fare': instance.baseFare,
      'distance_charge': instance.distanceCharge,
      'time_charge': instance.timeCharge,
      'waiting_charge': instance.waitingCharge,
      'discount_amount': instance.discountAmount,
      'surge_multiplier': instance.surgeMultiplier,
      'estimated_fare': instance.estimatedFare,
    };

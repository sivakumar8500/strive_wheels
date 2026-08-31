// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RideRequestModel _$RideRequestModelFromJson(Map<String, dynamic> json) =>
    _RideRequestModel(
      id: (json['id'] as num?)?.toInt(),
      pickupAddress: json['pickup_address'] as String?,
      dropAddress: json['drop_address'] as String?,
      estimatedFare: (json['estimated_fare'] as num?)?.toDouble(),
      pickupLat: (json['pickup_lat'] as num?)?.toDouble(),
      pickupLng: (json['pickup_lng'] as num?)?.toDouble(),
      dropLat: (json['drop_lat'] as num?)?.toDouble(),
      dropLng: (json['drop_lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RideRequestModelToJson(_RideRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pickup_address': instance.pickupAddress,
      'drop_address': instance.dropAddress,
      'estimated_fare': instance.estimatedFare,
      'pickup_lat': instance.pickupLat,
      'pickup_lng': instance.pickupLng,
      'drop_lat': instance.dropLat,
      'drop_lng': instance.dropLng,
    };

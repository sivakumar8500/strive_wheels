// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'past_ride_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PastRideItemModel _$PastRideItemModelFromJson(Map<String, dynamic> json) =>
    _PastRideItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      dateAndVehicle: json['dateAndVehicle'] as String,
      status: json['status'] as String,
      amount: json['amount'] as String,
      serviceType: json['serviceType'] as String,
      serviceMode: json['serviceMode'] as String? ?? 'SELF',
      pickupAddress: json['pickupAddress'] as String? ?? '',
      dropAddress: json['dropAddress'] as String? ?? '',
      pickupLat: (json['pickupLat'] as num?)?.toDouble(),
      pickupLng: (json['pickupLng'] as num?)?.toDouble(),
      dropLat: (json['dropLat'] as num?)?.toDouble(),
      dropLng: (json['dropLng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$PastRideItemModelToJson(_PastRideItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'dateAndVehicle': instance.dateAndVehicle,
      'status': instance.status,
      'amount': instance.amount,
      'serviceType': instance.serviceType,
      'serviceMode': instance.serviceMode,
      'pickupAddress': instance.pickupAddress,
      'dropAddress': instance.dropAddress,
      'pickupLat': instance.pickupLat,
      'pickupLng': instance.pickupLng,
      'dropLat': instance.dropLat,
      'dropLng': instance.dropLng,
    };

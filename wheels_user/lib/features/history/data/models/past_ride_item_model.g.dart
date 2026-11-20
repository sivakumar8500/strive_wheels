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
    );

Map<String, dynamic> _$PastRideItemModelToJson(_PastRideItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'dateAndVehicle': instance.dateAndVehicle,
      'status': instance.status,
      'amount': instance.amount,
      'serviceType': instance.serviceType,
    };

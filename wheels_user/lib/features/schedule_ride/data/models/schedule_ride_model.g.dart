// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_ride_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleRideModel _$ScheduleRideModelFromJson(Map<String, dynamic> json) =>
    _ScheduleRideModel(
      pickupPoint: json['pickupPoint'] as String,
      destination: json['destination'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      durationMins: (json['durationMins'] as num).toInt(),
      fareAmount: (json['fareAmount'] as num).toDouble(),
      currencySymbol: json['currencySymbol'] as String,
      selectedDate: json['selectedDate'] as String,
      selectedTime: json['selectedTime'] as String,
      isAm: json['isAm'] as bool,
      instantNotification: json['instantNotification'] as bool,
      checklistItems: (json['checklistItems'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ScheduleRideModelToJson(_ScheduleRideModel instance) =>
    <String, dynamic>{
      'pickupPoint': instance.pickupPoint,
      'destination': instance.destination,
      'distanceKm': instance.distanceKm,
      'durationMins': instance.durationMins,
      'fareAmount': instance.fareAmount,
      'currencySymbol': instance.currencySymbol,
      'selectedDate': instance.selectedDate,
      'selectedTime': instance.selectedTime,
      'isAm': instance.isAm,
      'instantNotification': instance.instantNotification,
      'checklistItems': instance.checklistItems,
    };

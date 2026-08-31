// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AvailabilityResponse _$AvailabilityResponseFromJson(
  Map<String, dynamic> json,
) => _AvailabilityResponse(
  success: json['success'] as bool,
  data: AvailabilityData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AvailabilityResponseToJson(
  _AvailabilityResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_AvailabilityData _$AvailabilityDataFromJson(Map<String, dynamic> json) =>
    _AvailabilityData(
      availabilityMode: json['availability_mode'] as String,
      isOnline: json['is_online'] as bool,
    );

Map<String, dynamic> _$AvailabilityDataToJson(_AvailabilityData instance) =>
    <String, dynamic>{
      'availability_mode': instance.availabilityMode,
      'is_online': instance.isOnline,
    };

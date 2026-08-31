// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_update_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocationUpdateResponse _$LocationUpdateResponseFromJson(
  Map<String, dynamic> json,
) => _LocationUpdateResponse(
  success: json['success'] as bool,
  data: LocationData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LocationUpdateResponseToJson(
  _LocationUpdateResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_LocationData _$LocationDataFromJson(Map<String, dynamic> json) =>
    _LocationData(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationDataToJson(_LocationData instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};

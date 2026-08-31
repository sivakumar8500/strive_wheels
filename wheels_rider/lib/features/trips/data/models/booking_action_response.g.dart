// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_action_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingActionResponse _$BookingActionResponseFromJson(
  Map<String, dynamic> json,
) => _BookingActionResponse(
  success: json['success'] as bool,
  data: BookingActionData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookingActionResponseToJson(
  _BookingActionResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_BookingActionData _$BookingActionDataFromJson(Map<String, dynamic> json) =>
    _BookingActionData(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
      finalFare: (json['final_fare'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BookingActionDataToJson(_BookingActionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'final_fare': instance.finalFare,
    };

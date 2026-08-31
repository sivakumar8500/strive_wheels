// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerifyOtpResponse _$VerifyOtpResponseFromJson(Map<String, dynamic> json) =>
    _VerifyOtpResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: VerifyOtpData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'],
      meta: json['meta'],
    );

Map<String, dynamic> _$VerifyOtpResponseToJson(_VerifyOtpResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'error': instance.error,
      'meta': instance.meta,
    };

_VerifyOtpData _$VerifyOtpDataFromJson(Map<String, dynamic> json) =>
    _VerifyOtpData(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String,
      userId: (json['user_id'] as num).toInt(),
      phone: json['phone'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      riderProfile: json['rider_profile'] == null
          ? null
          : RiderProfile.fromJson(
              json['rider_profile'] as Map<String, dynamic>,
            ),
      customerProfile: json['customer_profile'],
      driverRegistration: json['driver_registration'] == null
          ? null
          : DriverRegistration.fromJson(
              json['driver_registration'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$VerifyOtpDataToJson(_VerifyOtpData instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'user_id': instance.userId,
      'phone': instance.phone,
      'roles': instance.roles,
      'rider_profile': instance.riderProfile,
      'customer_profile': instance.customerProfile,
      'driver_registration': instance.driverRegistration,
    };

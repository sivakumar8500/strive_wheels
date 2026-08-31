// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendOtpResponse _$SendOtpResponseFromJson(Map<String, dynamic> json) =>
    _SendOtpResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: SendOtpData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'],
      meta: json['meta'],
    );

Map<String, dynamic> _$SendOtpResponseToJson(_SendOtpResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'error': instance.error,
      'meta': instance.meta,
    };

_SendOtpData _$SendOtpDataFromJson(Map<String, dynamic> json) => _SendOtpData(
  phone: json['phone'] as String,
  otpSent: json['otp_sent'] as bool,
  devOtp: json['dev_otp'] as String?,
);

Map<String, dynamic> _$SendOtpDataToJson(_SendOtpData instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'otp_sent': instance.otpSent,
      'dev_otp': instance.devOtp,
    };

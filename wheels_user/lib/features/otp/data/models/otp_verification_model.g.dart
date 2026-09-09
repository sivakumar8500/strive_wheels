// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtpVerificationModel _$OtpVerificationModelFromJson(
  Map<String, dynamic> json,
) => _OtpVerificationModel(
  fullPhoneNumber: json['phone'] as String,
  otpCode: json['otp'] as String,
);

Map<String, dynamic> _$OtpVerificationModelToJson(
  _OtpVerificationModel instance,
) => <String, dynamic>{
  'phone': instance.fullPhoneNumber,
  'otp': instance.otpCode,
};

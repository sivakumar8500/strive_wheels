// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OtpVerificationModel _$OtpVerificationModelFromJson(
  Map<String, dynamic> json,
) => _OtpVerificationModel(
  fullPhoneNumber: json['fullPhoneNumber'] as String,
  otpCode: json['otpCode'] as String,
);

Map<String, dynamic> _$OtpVerificationModelToJson(
  _OtpVerificationModel instance,
) => <String, dynamic>{
  'fullPhoneNumber': instance.fullPhoneNumber,
  'otpCode': instance.otpCode,
};

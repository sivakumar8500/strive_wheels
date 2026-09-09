import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_otp_response.freezed.dart';
part 'send_otp_response.g.dart';

@freezed
abstract class SendOtpResponse with _$SendOtpResponse {
  const factory SendOtpResponse({
    required bool success,
    required String message,
    required SendOtpData data,
    dynamic error,
    dynamic meta,
  }) = _SendOtpResponse;

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) => _$SendOtpResponseFromJson(json);
}

@freezed
abstract class SendOtpData with _$SendOtpData {
  const factory SendOtpData({
    required String phone,
    @JsonKey(name: 'otp_sent') required bool otpSent,
    @JsonKey(name: 'dev_otp') String? devOtp,
  }) = _SendOtpData;

  factory SendOtpData.fromJson(Map<String, dynamic> json) => _$SendOtpDataFromJson(json);
}

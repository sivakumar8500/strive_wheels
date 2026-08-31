import 'package:freezed_annotation/freezed_annotation.dart';
import 'rider_profile.dart';
import 'package:wheels_rider/features/registration/data/models/driver_registration.dart';

part 'verify_otp_response.freezed.dart';
part 'verify_otp_response.g.dart';

@freezed
abstract class VerifyOtpResponse with _$VerifyOtpResponse {
  const factory VerifyOtpResponse({
    required bool success,
    required String message,
    required VerifyOtpData data,
    dynamic error,
    dynamic meta,
  }) = _VerifyOtpResponse;

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => _$VerifyOtpResponseFromJson(json);
}

@freezed
abstract class VerifyOtpData with _$VerifyOtpData {
  const factory VerifyOtpData({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'user_id') required int userId,
    required String phone,
    required List<String> roles,
    @JsonKey(name: 'rider_profile') RiderProfile? riderProfile,
    @JsonKey(name: 'customer_profile') dynamic customerProfile,
    @JsonKey(name: 'driver_registration') DriverRegistration? driverRegistration,
  }) = _VerifyOtpData;

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) => _$VerifyOtpDataFromJson(json);
}

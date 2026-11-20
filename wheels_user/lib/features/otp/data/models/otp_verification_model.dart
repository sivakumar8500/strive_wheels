import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/otp_verification_entity.dart';

part 'otp_verification_model.freezed.dart';
part 'otp_verification_model.g.dart';

@freezed
abstract class OtpVerificationModel with _$OtpVerificationModel {
  const OtpVerificationModel._();

  const factory OtpVerificationModel({
    @JsonKey(name: 'phone') required String fullPhoneNumber,
    @JsonKey(name: 'otp') required String otpCode,
  }) = _OtpVerificationModel;

  factory OtpVerificationModel.fromJson(Map<String, dynamic> json) =>
      _$OtpVerificationModelFromJson(json);

  factory OtpVerificationModel.fromEntity(OtpVerificationEntity entity) {
    return OtpVerificationModel(
      fullPhoneNumber: entity.fullPhoneNumber,
      otpCode: entity.otpCode,
    );
  }
}

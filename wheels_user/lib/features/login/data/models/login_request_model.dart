import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/login_request_entity.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

@freezed
abstract class LoginRequestModel with _$LoginRequestModel {
  const LoginRequestModel._();

  const factory LoginRequestModel({
    required String countryCode,
    @JsonKey(name: 'phone') required String phoneNumber,
  }) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

  factory LoginRequestModel.fromEntity(LoginRequestEntity entity) {
    return LoginRequestModel(
      countryCode: entity.countryCode,
      phoneNumber: entity.phoneNumber,
    );
  }
}

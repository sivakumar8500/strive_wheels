import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_model.freezed.dart';
part 'coupon_model.g.dart';

@freezed
abstract class CouponModel with _$CouponModel {
  const factory CouponModel({
    required int id,
    required String code,
    @JsonKey(name: 'discount_type') String? discountType,
    @JsonKey(name: 'discount_value') num? discountValue,
  }) = _CouponModel;

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);
}

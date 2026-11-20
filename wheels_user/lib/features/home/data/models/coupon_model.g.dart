// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CouponModel _$CouponModelFromJson(Map<String, dynamic> json) => _CouponModel(
  id: (json['id'] as num).toInt(),
  code: json['code'] as String,
  discountType: json['discount_type'] as String?,
  discountValue: json['discount_value'] as num?,
  validUntil: json['valid_until'] as String?,
  expiresAt: json['expires_at'] as String?,
);

Map<String, dynamic> _$CouponModelToJson(_CouponModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'valid_until': instance.validUntil,
      'expires_at': instance.expiresAt,
    };

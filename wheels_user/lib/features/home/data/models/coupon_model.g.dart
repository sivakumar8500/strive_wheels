// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CouponModel _$CouponModelFromJson(Map<String, dynamic> json) => _CouponModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  code: (json['code'] ?? json['coupon_code'] ?? json['title'] ?? '').toString(),
  discountType: json['discount_type']?.toString(),
  discountValue: json['discount_value'] as num?,
  validUntil: (json['valid_until'] ?? json['valid_till'] ?? json['expires_at'] ?? json['expiry_date'])?.toString(),
  expiresAt: json['expires_at']?.toString(),
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

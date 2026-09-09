// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    _ProfileModel(
      id: (json['id'] as num?)?.toInt(),
      rating: (json['rating_avg'] as num?)?.toDouble(),
      totalEarnings: (json['total_earnings'] as num?)?.toDouble(),
      walletBalance: (json['wallet_balance'] as num?)?.toDouble(),
      user: json['user'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ProfileModelToJson(_ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rating_avg': instance.rating,
      'total_earnings': instance.totalEarnings,
      'wallet_balance': instance.walletBalance,
      'user': instance.user,
    };

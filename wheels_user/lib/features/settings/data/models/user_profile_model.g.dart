// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    _UserProfileModel(
      name: json['name'] as String,
      membershipTier: json['membershipTier'] as String,
      totalRides: json['totalRides'] as String,
      rating: json['rating'] as String,
    );

Map<String, dynamic> _$UserProfileModelToJson(_UserProfileModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'membershipTier': instance.membershipTier,
      'totalRides': instance.totalRides,
      'rating': instance.rating,
    };

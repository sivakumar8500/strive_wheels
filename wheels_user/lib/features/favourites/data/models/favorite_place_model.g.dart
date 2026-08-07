// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoritePlaceModel _$FavoritePlaceModelFromJson(Map<String, dynamic> json) =>
    _FavoritePlaceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      address: json['address'] as String,
      iconType: json['iconType'] as String,
    );

Map<String, dynamic> _$FavoritePlaceModelToJson(_FavoritePlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'address': instance.address,
      'iconType': instance.iconType,
    };

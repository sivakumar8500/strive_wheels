// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavoritePlaceModel _$FavoritePlaceModelFromJson(Map<String, dynamic> json) =>
    _FavoritePlaceModel(
      id: (_readId(json, 'id') as num).toInt(),
      title: json['title'] as String? ?? 'Unknown',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FavoritePlaceModelToJson(_FavoritePlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

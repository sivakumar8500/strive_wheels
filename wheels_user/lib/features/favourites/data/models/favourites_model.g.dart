// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourites_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FavouritesModel _$FavouritesModelFromJson(Map<String, dynamic> json) =>
    _FavouritesModel(
      shortcutTitle: json['shortcutTitle'] as String,
      shortcutSubtitle: json['shortcutSubtitle'] as String,
      places: (json['places'] as List<dynamic>)
          .map((e) => FavoritePlaceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FavouritesModelToJson(_FavouritesModel instance) =>
    <String, dynamic>{
      'shortcutTitle': instance.shortcutTitle,
      'shortcutSubtitle': instance.shortcutSubtitle,
      'places': instance.places,
    };

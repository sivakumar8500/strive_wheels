// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PopularLocationModel _$PopularLocationModelFromJson(
  Map<String, dynamic> json,
) => _PopularLocationModel(
  id: (json['id'] as num).toInt(),
  title: json['name'] as String,
  address: json['address'] as String,
  type: json['category'] as String,
);

Map<String, dynamic> _$PopularLocationModelToJson(
  _PopularLocationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.title,
  'address': instance.address,
  'category': instance.type,
};

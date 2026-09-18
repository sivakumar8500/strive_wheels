// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PopularLocationModel _$PopularLocationModelFromJson(
  Map<String, dynamic> json,
) => _PopularLocationModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: (json['name'] ?? json['title'] ?? '').toString(),
  address: (json['address'] ?? json['location'] ?? '').toString(),
  type: (json['category'] ?? json['type'] ?? 'city').toString(),
);

Map<String, dynamic> _$PopularLocationModelToJson(
  _PopularLocationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.title,
  'address': instance.address,
  'category': instance.type,
};

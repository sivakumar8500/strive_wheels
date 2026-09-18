// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuickServiceModel _$QuickServiceModelFromJson(Map<String, dynamic> json) =>
    _QuickServiceModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? json['name'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? json['description'] ?? '').toString(),
      iconUrl: (json['icon_url'] ?? json['icon'] ?? json['image_url'])?.toString(),
    );

Map<String, dynamic> _$QuickServiceModelToJson(_QuickServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'icon_url': instance.iconUrl,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuickServiceModel _$QuickServiceModelFromJson(Map<String, dynamic> json) =>
    _QuickServiceModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      iconUrl: json['icon_url'] as String?,
    );

Map<String, dynamic> _$QuickServiceModelToJson(_QuickServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'icon_url': instance.iconUrl,
    };

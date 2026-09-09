// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_journey_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecentJourneyModel _$RecentJourneyModelFromJson(Map<String, dynamic> json) =>
    _RecentJourneyModel(
      id: json['id'] as String,
      title: json['title'] as String,
      origin: json['origin'] as String,
      timestamp: json['timestamp'] as String,
      iconType: json['iconType'] as String,
    );

Map<String, dynamic> _$RecentJourneyModelToJson(_RecentJourneyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'origin': instance.origin,
      'timestamp': instance.timestamp,
      'iconType': instance.iconType,
    };

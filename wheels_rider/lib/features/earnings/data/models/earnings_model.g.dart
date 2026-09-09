// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earnings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EarningsActivityModel _$EarningsActivityModelFromJson(
  Map<String, dynamic> json,
) => _EarningsActivityModel(
  id: json['id'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  amount: (json['amount'] as num).toDouble(),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$EarningsActivityModelToJson(
  _EarningsActivityModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'amount': instance.amount,
  'timestamp': instance.timestamp.toIso8601String(),
};

_EarningsModel _$EarningsModelFromJson(Map<String, dynamic> json) =>
    _EarningsModel(
      totalEarnings: (json['total_earnings'] as num).toDouble(),
      trips: (json['trips'] as num).toInt(),
      hours: (json['hours'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      recentActivities: (json['recent_activities'] as List<dynamic>)
          .map((e) => EarningsActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EarningsModelToJson(_EarningsModel instance) =>
    <String, dynamic>{
      'total_earnings': instance.totalEarnings,
      'trips': instance.trips,
      'hours': instance.hours,
      'rating': instance.rating,
      'recent_activities': instance.recentActivities,
    };

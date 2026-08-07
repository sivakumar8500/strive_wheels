// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RideHistoryModel _$RideHistoryModelFromJson(Map<String, dynamic> json) =>
    _RideHistoryModel(
      monthlySummaryTitle: json['monthlySummaryTitle'] as String,
      tripCountText: json['tripCountText'] as String,
      distanceText: json['distanceText'] as String,
      spentText: json['spentText'] as String,
      pastRides: (json['pastRides'] as List<dynamic>)
          .map((e) => PastRideItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RideHistoryModelToJson(_RideHistoryModel instance) =>
    <String, dynamic>{
      'monthlySummaryTitle': instance.monthlySummaryTitle,
      'tripCountText': instance.tripCountText,
      'distanceText': instance.distanceText,
      'spentText': instance.spentText,
      'pastRides': instance.pastRides,
    };

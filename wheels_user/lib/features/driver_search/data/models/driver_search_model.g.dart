// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriverSearchModel _$DriverSearchModelFromJson(Map<String, dynamic> json) =>
    _DriverSearchModel(
      statusTitle: json['statusTitle'] as String,
      statusSubtitle: json['statusSubtitle'] as String,
      estimatedConfirmationText: json['estimatedConfirmationText'] as String,
      orderTime: json['orderTime'] as String,
      scanRadiusText: json['scanRadiusText'] as String,
      activeStepIndex: (json['activeStepIndex'] as num).toInt(),
    );

Map<String, dynamic> _$DriverSearchModelToJson(_DriverSearchModel instance) =>
    <String, dynamic>{
      'statusTitle': instance.statusTitle,
      'statusSubtitle': instance.statusSubtitle,
      'estimatedConfirmationText': instance.estimatedConfirmationText,
      'orderTime': instance.orderTime,
      'scanRadiusText': instance.scanRadiusText,
      'activeStepIndex': instance.activeStepIndex,
    };

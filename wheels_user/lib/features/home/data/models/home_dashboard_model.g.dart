// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeDashboardModel _$HomeDashboardModelFromJson(Map<String, dynamic> json) =>
    _HomeDashboardModel(
      userName: json['userName'] as String,
      greetingTitle: json['greetingTitle'] as String,
      greetingSubtitle: json['greetingSubtitle'] as String,
      recentRideTitle: json['recentRideTitle'] as String,
      recentRideDetails: json['recentRideDetails'] as String,
      selectedNavIndex: (json['selectedNavIndex'] as num?)?.toInt() ?? 0,
      isCorporate: json['isCorporate'] as bool? ?? false,
      companyName: json['companyName'] as String?,
      employeeCode: json['employeeCode'] as String?,
      spendingLimit: json['spendingLimit'] as String?,
      companyLocation: json['companyLocation'] as String?,
    );

Map<String, dynamic> _$HomeDashboardModelToJson(_HomeDashboardModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'greetingTitle': instance.greetingTitle,
      'greetingSubtitle': instance.greetingSubtitle,
      'recentRideTitle': instance.recentRideTitle,
      'recentRideDetails': instance.recentRideDetails,
      'selectedNavIndex': instance.selectedNavIndex,
      'isCorporate': instance.isCorporate,
      'companyName': instance.companyName,
      'employeeCode': instance.employeeCode,
      'spendingLimit': instance.spendingLimit,
      'companyLocation': instance.companyLocation,
    };

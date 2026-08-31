// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permissions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PermissionsModel _$PermissionsModelFromJson(Map<String, dynamic> json) =>
    _PermissionsModel(
      notificationsAllowed: json['notificationsAllowed'] as bool? ?? false,
      contactsAllowed: json['contactsAllowed'] as bool? ?? false,
      locationAllowed: json['locationAllowed'] as bool? ?? false,
    );

Map<String, dynamic> _$PermissionsModelToJson(_PermissionsModel instance) =>
    <String, dynamic>{
      'notificationsAllowed': instance.notificationsAllowed,
      'contactsAllowed': instance.contactsAllowed,
      'locationAllowed': instance.locationAllowed,
    };

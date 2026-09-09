// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RiderProfile _$RiderProfileFromJson(Map<String, dynamic> json) =>
    _RiderProfile(
      id: (json['id'] as num?)?.toInt(),
      verificationStatus: json['verification_status'] as String?,
      availabilityMode: json['availability_mode'] as String?,
      isOnline: json['is_online'] as bool?,
      isDriver: json['is_driver'] as bool?,
      driverRegistration: json['driver_registration'] == null
          ? null
          : DriverRegistration.fromJson(
              json['driver_registration'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$RiderProfileToJson(_RiderProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'verification_status': instance.verificationStatus,
      'availability_mode': instance.availabilityMode,
      'is_online': instance.isOnline,
      'is_driver': instance.isDriver,
      'driver_registration': instance.driverRegistration,
    };

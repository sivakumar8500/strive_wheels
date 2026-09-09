import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wheels_rider/features/registration/data/models/driver_registration.dart';

part 'rider_profile.freezed.dart';
part 'rider_profile.g.dart';

@freezed
abstract class RiderProfile with _$RiderProfile {
  const factory RiderProfile({
    int? id,
    @JsonKey(name: 'verification_status') String? verificationStatus,
    @JsonKey(name: 'availability_mode') String? availabilityMode,
    @JsonKey(name: 'is_online') bool? isOnline,
    @JsonKey(name: 'is_driver') bool? isDriver,
    @JsonKey(name: 'driver_registration') DriverRegistration? driverRegistration,
  }) = _RiderProfile;

  factory RiderProfile.fromJson(Map<String, dynamic> json) => _$RiderProfileFromJson(json);
}

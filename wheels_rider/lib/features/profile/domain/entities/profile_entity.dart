import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_entity.freezed.dart';

@freezed
abstract class ProfileEntity with _$ProfileEntity {
  const ProfileEntity._();

  const factory ProfileEntity({
    required int id,
    required String name,
    required double rating,
    required String profileImageUrl,
    required double totalEarnings,
    required double walletBalance,
    required String phone,
    required String email,
    required String dob,
    required String gender,
    required String status,
    @Default('Toyota') String vehicleMake,
    @Default('Innova Crysta') String vehicleModel,
    @Default('TS 09 EQ 1234') String vehicleNumber,
    @Default('SUV') String vehicleType,
    @Default('Pearl White') String vehicleColor,
    @Default('2023') String vehicleYear,
    @Default('Diesel') String fuelType,
  }) = _ProfileEntity;
}

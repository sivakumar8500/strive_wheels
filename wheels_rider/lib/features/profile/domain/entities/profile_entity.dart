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
  }) = _ProfileEntity;
}

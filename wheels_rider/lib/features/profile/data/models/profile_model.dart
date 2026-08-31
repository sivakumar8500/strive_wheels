import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/profile_entity.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const ProfileModel._();

  const factory ProfileModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'rating_avg') double? rating,
    @JsonKey(name: 'total_earnings') double? totalEarnings,
    @JsonKey(name: 'wallet_balance') double? walletBalance,
    @JsonKey(name: 'user') Map<String, dynamic>? user,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  ProfileEntity toEntity() {
    final userData = user ?? {};
    return ProfileEntity(
      id: id ?? 0,
      name: userData['full_name'] as String? ?? 'Unknown',
      rating: rating ?? 0.0,
      totalEarnings: totalEarnings ?? 0.0,
      walletBalance: walletBalance ?? 0.0,
      profileImageUrl: userData['profile_image_url'] as String? ?? '',
      phone: userData['phone'] as String? ?? '',
      email: userData['email'] as String? ?? '',
      dob: userData['dob'] as String? ?? '',
      gender: userData['gender'] as String? ?? '',
    );
  }
}

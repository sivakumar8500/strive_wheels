import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_profile_entity.dart';

part 'user_profile_model.freezed.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required String name,
    required String membershipTier,
    required String totalRides,
    required String rating,
    required String phone,
    required String email,
    required String gender,
    required bool isCorporate,
    String? companyName,
    String? corporateEmail,
    String? corporateId,
    String? department,
    String? designation,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(dynamic rawJson) {
    final Map<String, dynamic> json = rawJson is Map<String, dynamic>
        ? rawJson
        : (rawJson is Map ? Map<String, dynamic>.from(rawJson) : {});

    final Map<String, dynamic> data = json['data'] is Map<String, dynamic>
        ? json['data']
        : (json['data'] is Map
            ? Map<String, dynamic>.from(json['data'])
            : json);

    final Map<String, dynamic> corpData = data['corporate_info'] is Map
        ? Map<String, dynamic>.from(data['corporate_info'])
        : (data['company_info'] is Map
            ? Map<String, dynamic>.from(data['company_info'])
            : (data['corporate_profile'] is Map
                ? Map<String, dynamic>.from(data['corporate_profile'])
                : {}));

    final rawCompanyName = corpData['company_name'] ??
        corpData['name'] ??
        data['company_name'] ??
        data['corporate_name'];

    final bool isCorp = data['is_corporate'] == true ||
        data['is_corporate_user'] == true ||
        (rawCompanyName != null && rawCompanyName.toString().trim().isNotEmpty);

    return UserProfileModel(
      name: (data['name'] ?? data['full_name'] ?? data['first_name'] ?? 'Puja Sri').toString(),
      membershipTier: (data['membershipTier'] ?? data['membership_tier'] ?? data['tier'] ?? 'Gold Member').toString(),
      totalRides: (data['totalRides'] ?? data['total_rides'] ?? data['rides_count'] ?? '24').toString(),
      rating: (data['rating'] ?? data['rating_avg'] ?? data['avg_rating'] ?? '4.9').toString(),
      phone: (data['phone'] ?? data['phone_number'] ?? data['mobile'] ?? '+91 98765 43210').toString(),
      email: (data['email'] ?? data['email_id'] ?? 'pujasri@strive.com').toString(),
      gender: (data['gender'] ?? 'Female').toString(),
      isCorporate: isCorp,
      companyName: rawCompanyName?.toString(),
      corporateEmail: (corpData['corporate_email'] ?? data['corporate_email'])?.toString(),
      corporateId: (corpData['corporate_id'] ?? corpData['employee_id'] ?? data['corporate_id'])?.toString(),
      department: (corpData['department'] ?? data['department'])?.toString(),
      designation: (corpData['designation'] ?? data['designation'])?.toString(),
    );
  }
}

extension UserProfileModelX on UserProfileModel {
  UserProfileEntity toEntity() => UserProfileEntity(
        name: name,
        membershipTier: membershipTier,
        totalRides: totalRides,
        rating: rating,
        phone: phone,
        email: email,
        gender: gender,
        isCorporate: isCorporate,
        companyName: companyName,
        corporateEmail: corporateEmail,
        corporateId: corporateId,
        department: department,
        designation: designation,
      );
}

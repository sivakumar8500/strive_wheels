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
    String? spendingLimit,
    String? companyLocation,
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

    final Map<String, dynamic> activeCompany = data['active_company'] is Map
        ? Map<String, dynamic>.from(data['active_company'])
        : {};
    final List associations = (data['company_associations'] is List)
        ? data['company_associations']
        : [];
    final Map<String, dynamic> firstAssoc = (associations.isNotEmpty && associations.first is Map)
        ? Map<String, dynamic>.from(associations.first)
        : {};
    final Map<String, dynamic> assocCompany = (firstAssoc['company'] is Map)
        ? Map<String, dynamic>.from(firstAssoc['company'])
        : {};

    final rawCompanyName = activeCompany['name'] ??
        assocCompany['name'] ??
        corpData['company_name'] ??
        corpData['name'] ??
        data['company_name'] ??
        data['corporate_name'];

    final bool isCorp = data['is_corporate'] == true ||
        data['is_corporate_user'] == true ||
        (rawCompanyName != null && rawCompanyName.toString().trim().isNotEmpty);

    final rawCorpId = firstAssoc['employee_code'] ??
        corpData['corporate_id'] ??
        corpData['employee_code'] ??
        corpData['employee_id'] ??
        data['corporate_id'] ??
        data['employee_code'];

    final rawCorpEmail = activeCompany['contact_email'] ??
        assocCompany['contact_email'] ??
        corpData['corporate_email'] ??
        corpData['contact_email'] ??
        data['corporate_email'];

    final rawSpendingLimit = firstAssoc['spending_limit'] ??
        corpData['spending_limit'] ??
        data['spending_limit'];

    final rawLocation = activeCompany['company_location'] ??
        assocCompany['company_location'] ??
        corpData['company_location'] ??
        corpData['location'] ??
        data['company_location'];

    return UserProfileModel(
      name: (data['name'] ?? data['full_name'] ?? data['first_name'] ?? 'User').toString(),
      membershipTier: (data['membershipTier'] ?? data['membership_tier'] ?? data['tier'] ?? 'Gold Member').toString(),
      totalRides: (data['totalRides'] ?? data['total_rides'] ?? data['rides_count'] ?? '0').toString(),
      rating: (data['rating'] ?? data['rating_avg'] ?? data['avg_rating'] ?? '5.0').toString(),
      phone: (data['phone'] ?? data['phone_number'] ?? data['mobile'] ?? '').toString(),
      email: (data['email'] ?? data['email_id'] ?? '').toString(),
      gender: (data['gender'] ?? 'Not Specified').toString(),
      isCorporate: isCorp,
      companyName: rawCompanyName?.toString(),
      corporateEmail: rawCorpEmail?.toString(),
      corporateId: rawCorpId?.toString(),
      department: (corpData['department'] ?? data['department'])?.toString(),
      designation: (corpData['designation'] ?? data['designation'])?.toString(),
      spendingLimit: rawSpendingLimit?.toString(),
      companyLocation: rawLocation?.toString(),
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
        spendingLimit: spendingLimit,
        companyLocation: companyLocation,
      );
}

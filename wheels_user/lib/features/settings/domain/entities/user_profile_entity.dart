class UserProfileEntity {
  final String name;
  final String membershipTier;
  final String totalRides;
  final String rating;
  final String phone;
  final String email;
  final String gender;
  final bool isCorporate;
  final String? companyName;
  final String? corporateEmail;
  final String? corporateId;
  final String? department;
  final String? designation;
  final String? spendingLimit;
  final String? companyLocation;

  const UserProfileEntity({
    required this.name,
    required this.membershipTier,
    required this.totalRides,
    required this.rating,
    required this.phone,
    required this.email,
    required this.gender,
    this.isCorporate = false,
    this.companyName,
    this.corporateEmail,
    this.corporateId,
    this.department,
    this.designation,
    this.spendingLimit,
    this.companyLocation,
  });
}

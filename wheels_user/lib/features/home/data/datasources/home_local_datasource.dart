import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/home_dashboard_model.dart';

abstract class HomeLocalDataSource {
  Future<HomeDashboardModel> getHomeDashboardData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final SharedPreferences sharedPreferences;

  const HomeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<HomeDashboardModel> getHomeDashboardData() async {
    String userName = sharedPreferences.getString('user_name') ?? '';
    String? profileImageUrl = sharedPreferences.getString('user_profile_image') ??
        sharedPreferences.getString('profile_image_url');

    final savedProfileStr = sharedPreferences.getString('saved_customer_profile');
    if (savedProfileStr != null && savedProfileStr.isNotEmpty) {
      try {
        final decoded = jsonDecode(savedProfileStr);
        if (decoded is Map<String, dynamic>) {
          final userObj = decoded['user'] is Map ? decoded['user'] as Map<String, dynamic> : null;
          if (profileImageUrl == null || profileImageUrl.trim().isEmpty) {
            final rawImg = decoded['profile_image_url'] ??
                decoded['profile_photo_url'] ??
                decoded['profile_image'] ??
                decoded['avatar_url'] ??
                decoded['avatar'] ??
                decoded['image_url'] ??
                decoded['profile_pic'] ??
                userObj?['profile_image_url'] ??
                userObj?['profile_photo_url'] ??
                userObj?['profile_image'] ??
                userObj?['avatar_url'] ??
                userObj?['avatar'] ??
                userObj?['image_url'] ??
                userObj?['profile_pic'];
            if (rawImg != null && rawImg.toString().trim().isNotEmpty) {
              profileImageUrl = rawImg.toString().trim();
            }
          }
          if (userName.isEmpty || userName == 'User') {
            final foundName = decoded['full_name'] ??
                decoded['name'] ??
                userObj?['full_name'] ??
                userObj?['name'];
            if (foundName != null && foundName.toString().trim().isNotEmpty) {
              userName = foundName.toString().trim();
            }
          }
        }
      } catch (_) {}
    }

    if (userName.isEmpty) {
      userName = 'User';
    }

    final isCorporate = sharedPreferences.getBool('is_corporate_user') ?? false;
    final companyName = sharedPreferences.getString('corporate_company_name');
    final employeeCode = sharedPreferences.getString('corporate_employee_code');
    final spendingLimit = sharedPreferences.getString('corporate_spending_limit');
    final companyLocation = sharedPreferences.getString('corporate_location');

    return HomeDashboardModel(
      userName: userName,
      profileImageUrl: profileImageUrl,
      greetingTitle: AppStrings.goodMorning,
      greetingSubtitle: AppStrings.readyForNextRide,
      recentRideTitle: AppStrings.recentRideOfficeToHome,
      recentRideDetails: AppStrings.recentRideDetails,
      selectedNavIndex: 0,
      isCorporate: isCorporate,
      companyName: companyName,
      employeeCode: employeeCode,
      spendingLimit: spendingLimit,
      companyLocation: companyLocation,
    );
  }
}

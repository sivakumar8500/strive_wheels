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
    final userName = sharedPreferences.getString('user_name') ?? 'User';
    final isCorporate = sharedPreferences.getBool('is_corporate_user') ?? false;
    final companyName = sharedPreferences.getString('corporate_company_name');
    final employeeCode = sharedPreferences.getString('corporate_employee_code');
    final spendingLimit = sharedPreferences.getString('corporate_spending_limit');
    final companyLocation = sharedPreferences.getString('corporate_location');

    return HomeDashboardModel(
      userName: userName,
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

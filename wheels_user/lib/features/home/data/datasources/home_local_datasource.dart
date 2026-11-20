import '../../../../core/constants/app_strings.dart';
import '../models/home_dashboard_model.dart';

abstract class HomeLocalDataSource {
  Future<HomeDashboardModel> getHomeDashboardData();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  const HomeLocalDataSourceImpl();

  @override
  Future<HomeDashboardModel> getHomeDashboardData() async {
    return const HomeDashboardModel(
      userName: 'JW',
      greetingTitle: AppStrings.goodMorning,
      greetingSubtitle: AppStrings.readyForNextRide,
      recentRideTitle: AppStrings.recentRideOfficeToHome,
      recentRideDetails: AppStrings.recentRideDetails,
      selectedNavIndex: 0,
    );
  }
}

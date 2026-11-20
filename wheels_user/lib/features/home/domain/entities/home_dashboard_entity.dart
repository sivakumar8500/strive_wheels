/// Domain entity representing Home Dashboard data.
class HomeDashboardEntity {
  final String userName;
  final String greetingTitle;
  final String greetingSubtitle;
  final String recentRideTitle;
  final String recentRideDetails;
  final int selectedNavIndex;

  const HomeDashboardEntity({
    required this.userName,
    required this.greetingTitle,
    required this.greetingSubtitle,
    required this.recentRideTitle,
    required this.recentRideDetails,
    this.selectedNavIndex = 0,
  });
}

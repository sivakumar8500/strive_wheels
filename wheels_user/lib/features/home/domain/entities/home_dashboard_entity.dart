class QuickServiceEntity {
  final String id;
  final String title;
  final String subtitle;
  final String iconUrl;

  const QuickServiceEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconUrl,
  });
}

class PopularLocationEntity {
  final String id;
  final String title;
  final String address;
  final String type;

  const PopularLocationEntity({
    required this.id,
    required this.title,
    required this.address,
    required this.type,
  });
}

class CouponEntity {
  final String id;
  final String title;
  final String code;
  final String description;

  const CouponEntity({
    required this.id,
    required this.title,
    required this.code,
    required this.description,
  });
}

/// Domain entity representing Home Dashboard data.
class HomeDashboardEntity {
  final String userName;
  final String greetingTitle;
  final String greetingSubtitle;
  final String recentRideTitle;
  final String recentRideDetails;
  final int selectedNavIndex;
  final List<QuickServiceEntity> quickServices;
  final List<PopularLocationEntity> popularLocations;
  final List<CouponEntity> coupons;

  const HomeDashboardEntity({
    required this.userName,
    required this.greetingTitle,
    required this.greetingSubtitle,
    required this.recentRideTitle,
    required this.recentRideDetails,
    this.selectedNavIndex = 0,
    this.quickServices = const [],
    this.popularLocations = const [],
    this.coupons = const [],
  });
}

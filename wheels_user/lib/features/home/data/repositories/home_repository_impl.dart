import '../../../../core/network/api_constants.dart';
import '../../domain/entities/home_dashboard_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<HomeDashboardEntity> getHomeDashboard() async {
    // Always start with local data so the screen renders even if network fails
    final localModel = await localDataSource.getHomeDashboardData();

    // Fetch remote data individually — any failure returns an empty list
    List<QuickServiceEntity> quickServices = [];
    List<PopularLocationEntity> popularLocations = [];
    List<CouponEntity> coupons = [];

    try {
      final rawServices = await remoteDataSource.getQuickServices();
      quickServices = rawServices.map((m) {
        String icon = m.iconUrl ?? '';
        if (icon.isNotEmpty && !icon.startsWith('http')) {
          icon = '${ApiConstants.baseUrl}$icon';
        }
        return QuickServiceEntity(
          id: m.id.toString(),
          title: m.title,
          subtitle: m.subtitle,
          iconUrl: icon,
        );
      }).toList();
    } catch (_) {}

    try {
      final rawLocations = await remoteDataSource.getPopularLocations();
      popularLocations = rawLocations.map((m) => PopularLocationEntity(
        id: m.id.toString(),
        title: m.title,
        address: m.address,
        type: m.type,
      )).toList();
    } catch (_) {}

    try {
      final rawCoupons = await remoteDataSource.getActiveCoupons();
      coupons = rawCoupons.map((m) {
        final val = (m.discountValue != null && m.discountValue != 0)
            ? '${m.discountValue} OFF'
            : (m.code.isNotEmpty ? m.code : 'SPECIAL OFFER');
        return CouponEntity(
          id: m.id.toString(),
          title: val,
          code: m.code,
          description: m.discountType ?? '',
          validUntil: m.validUntil ?? m.expiresAt ?? '',
        );
      }).toList();
    } catch (_) {}

    return HomeDashboardEntity(
      userName: localModel.userName,
      greetingTitle: localModel.greetingTitle,
      greetingSubtitle: localModel.greetingSubtitle,
      recentRideTitle: localModel.recentRideTitle,
      recentRideDetails: localModel.recentRideDetails,
      selectedNavIndex: localModel.selectedNavIndex,
      quickServices: quickServices,
      popularLocations: popularLocations,
      coupons: coupons,
    );
  }
}

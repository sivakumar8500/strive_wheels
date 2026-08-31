import '../../domain/entities/home_dashboard_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/home_dashboard_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<HomeDashboardEntity> getHomeDashboard() async {
    final localModel = await localDataSource.getHomeDashboardData();
    
    // Fetch dynamic data in parallel
    final results = await Future.wait([
      remoteDataSource.getQuickServices(),
      remoteDataSource.getPopularLocations(),
      remoteDataSource.getActiveCoupons(),
    ]);

    final quickServices = (results[0] as List).map((m) => QuickServiceEntity(
      id: m.id.toString(),
      title: m.title,
      subtitle: m.subtitle,
      iconUrl: m.iconUrl ?? '',
    )).toList();

    final popularLocations = (results[1] as List).map((m) => PopularLocationEntity(
      id: m.id.toString(),
      title: m.title,
      address: m.address,
      type: m.type,
    )).toList();

    final coupons = (results[2] as List).map((m) => CouponEntity(
      id: m.id.toString(),
      title: '${m.discountValue ?? 0} OFF',
      code: m.code ?? '',
      description: m.discountType ?? '',
    )).toList();

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

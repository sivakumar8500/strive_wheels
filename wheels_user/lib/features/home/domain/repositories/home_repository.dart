import '../entities/home_dashboard_entity.dart';

/// Abstract repository interface for Home Dashboard.
abstract class HomeRepository {
  Future<HomeDashboardEntity> getHomeDashboard();
}

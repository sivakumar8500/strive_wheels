import '../entities/home_dashboard_entity.dart';
import '../repositories/home_repository.dart';

/// UseCase to retrieve Home Dashboard data.
class GetHomeDashboardUseCase {
  final HomeRepository repository;

  GetHomeDashboardUseCase(this.repository);

  Future<HomeDashboardEntity> call() async {
    return await repository.getHomeDashboard();
  }
}

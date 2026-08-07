import '../../domain/entities/home_dashboard_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../models/home_dashboard_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({required this.localDataSource});

  @override
  Future<HomeDashboardEntity> getHomeDashboard() async {
    final model = await localDataSource.getHomeDashboardData();
    return model.toEntity();
  }
}

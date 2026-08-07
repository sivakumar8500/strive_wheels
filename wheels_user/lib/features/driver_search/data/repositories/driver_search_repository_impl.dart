import '../../domain/entities/driver_search_entity.dart';
import '../../domain/repositories/driver_search_repository.dart';
import '../datasources/driver_search_local_datasource.dart';
import '../models/driver_search_model.dart';

class DriverSearchRepositoryImpl implements DriverSearchRepository {
  final DriverSearchLocalDataSource localDataSource;

  DriverSearchRepositoryImpl({required this.localDataSource});

  @override
  Future<DriverSearchEntity> getDriverSearchDetails() async {
    final model = await localDataSource.getDriverSearchDetails();
    return model.toEntity();
  }
}

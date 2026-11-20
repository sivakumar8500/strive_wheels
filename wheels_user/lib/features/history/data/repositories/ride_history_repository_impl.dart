import '../../domain/entities/ride_history_entity.dart';
import '../../domain/repositories/ride_history_repository.dart';
import '../datasources/ride_history_local_datasource.dart';
import '../models/ride_history_model.dart';

class RideHistoryRepositoryImpl implements RideHistoryRepository {
  final RideHistoryLocalDataSource localDataSource;

  RideHistoryRepositoryImpl({required this.localDataSource});

  @override
  Future<RideHistoryEntity> getRideHistory() async {
    final model = await localDataSource.getRideHistoryData();
    return model.toEntity();
  }
}

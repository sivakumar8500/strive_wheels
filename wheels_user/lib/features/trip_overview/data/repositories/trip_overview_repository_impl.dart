import '../../domain/entities/trip_overview_entity.dart';
import '../../domain/repositories/trip_overview_repository.dart';
import '../datasources/trip_overview_local_datasource.dart';
import '../models/trip_overview_model.dart';

class TripOverviewRepositoryImpl implements TripOverviewRepository {
  final TripOverviewLocalDataSource localDataSource;

  TripOverviewRepositoryImpl({required this.localDataSource});

  @override
  Future<TripOverviewEntity> getTripOverviewDetails(String vehicleId) async {
    final model = await localDataSource.getTripOverviewDetails(vehicleId);
    return model.toEntity();
  }
}

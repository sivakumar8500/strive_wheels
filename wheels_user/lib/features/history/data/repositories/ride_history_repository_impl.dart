import '../../domain/entities/ride_history_entity.dart';
import '../../domain/repositories/ride_history_repository.dart';
import '../datasources/ride_history_local_datasource.dart';
import '../datasources/ride_history_remote_data_source.dart';
import '../models/ride_history_model.dart';
import '../models/booking_history_model.dart';

class RideHistoryRepositoryImpl implements RideHistoryRepository {
  final RideHistoryLocalDataSource localDataSource;
  final RideHistoryRemoteDataSource remoteDataSource;

  RideHistoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<RideHistoryEntity> getRideHistory() async {
    final localModel = await localDataSource.getRideHistoryData();
    final localEntity = localModel.toEntity();

    final remoteBookings = await remoteDataSource.getBookingHistory();
    final pastRides = remoteBookings.map((m) => m.toEntity()).toList();

    return RideHistoryEntity(
      monthlySummaryTitle: localEntity.monthlySummaryTitle,
      tripCountText: '${pastRides.length} Trips',
      distanceText: localEntity.distanceText,
      spentText: localEntity.spentText,
      pastRides: pastRides,
    );
  }
}

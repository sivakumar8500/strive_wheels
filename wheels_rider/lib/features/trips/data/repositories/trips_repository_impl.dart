import '../../domain/entities/trip_entity.dart';
import '../../domain/repositories/trips_repository.dart';
import '../datasources/trips_remote_data_source.dart';

class TripsRepositoryImpl implements TripsRepository {
  final TripsRemoteDataSource remoteDataSource;

  TripsRepositoryImpl(this.remoteDataSource);

  @override
  Future<TripEntity> getTrips(int limit, int offset) async {
    try {
      final model = await remoteDataSource.getTrips(limit, offset);
      return model.toEntity();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

import '../../domain/entities/schedule_ride_entity.dart';
import '../../domain/repositories/schedule_ride_repository.dart';
import '../datasources/schedule_ride_local_datasource.dart';
import '../models/schedule_ride_model.dart';

class ScheduleRideRepositoryImpl implements ScheduleRideRepository {
  final ScheduleRideLocalDataSource localDataSource;

  ScheduleRideRepositoryImpl({required this.localDataSource});

  @override
  Future<ScheduleRideEntity> getScheduleRideDetails() async {
    final model = await localDataSource.getScheduleRideDetails();
    return model.toEntity();
  }
}

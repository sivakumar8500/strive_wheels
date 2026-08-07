import '../entities/schedule_ride_entity.dart';

abstract class ScheduleRideRepository {
  Future<ScheduleRideEntity> getScheduleRideDetails();
}

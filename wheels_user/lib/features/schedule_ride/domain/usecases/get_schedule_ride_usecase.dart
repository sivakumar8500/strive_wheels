import '../entities/schedule_ride_entity.dart';
import '../repositories/schedule_ride_repository.dart';

class GetScheduleRideUseCase {
  final ScheduleRideRepository repository;

  GetScheduleRideUseCase(this.repository);

  Future<ScheduleRideEntity> call() async {
    return await repository.getScheduleRideDetails();
  }
}

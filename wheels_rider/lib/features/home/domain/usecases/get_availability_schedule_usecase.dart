import '../repositories/home_repository.dart';

class GetAvailabilityScheduleUseCase {
  final HomeRepository repository;

  GetAvailabilityScheduleUseCase(this.repository);

  Future<List<DateTime>> call() async {
    return await repository.getAvailabilitySchedule();
  }
}

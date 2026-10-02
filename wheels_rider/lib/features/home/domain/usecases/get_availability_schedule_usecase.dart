import '../repositories/home_repository.dart';

class GetAvailabilityScheduleUseCase {
  final HomeRepository repository;

  GetAvailabilityScheduleUseCase(this.repository);

  Future<List<DateTime>> call({DateTime? startDate}) async {
    return await repository.getAvailabilitySchedule(startDate: startDate);
  }
}

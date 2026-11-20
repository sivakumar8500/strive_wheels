import '../repositories/home_repository.dart';

class UpdateAvailabilityUseCase {
  final HomeRepository repository;

  UpdateAvailabilityUseCase(this.repository);

  Future<void> call({required String availabilityMode, required bool isOnline, List<DateTime>? selectedDates}) async {
    await repository.updateAvailability(availabilityMode: availabilityMode, isOnline: isOnline);
    
    if (selectedDates != null && selectedDates.isNotEmpty) {
      await repository.updateAvailabilitySchedule(selectedDates);
    }
  }
}

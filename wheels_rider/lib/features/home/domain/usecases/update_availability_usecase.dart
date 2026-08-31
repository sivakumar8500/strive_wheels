import '../repositories/home_repository.dart';

class UpdateAvailabilityUseCase {
  final HomeRepository repository;

  UpdateAvailabilityUseCase(this.repository);

  Future<void> call({required String availabilityMode, required bool isOnline}) {
    return repository.updateAvailability(availabilityMode: availabilityMode, isOnline: isOnline);
  }
}

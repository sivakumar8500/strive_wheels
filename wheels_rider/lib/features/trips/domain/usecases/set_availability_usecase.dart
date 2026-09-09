import '../repositories/rider_repository.dart';
import '../../data/models/availability_response.dart';

class SetAvailabilityUseCase {
  final RiderRepository repository;

  SetAvailabilityUseCase(this.repository);

  Future<AvailabilityResponse> call({required String mode, required bool isOnline}) {
    return repository.setAvailability(mode: mode, isOnline: isOnline);
  }
}
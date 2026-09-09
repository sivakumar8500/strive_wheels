import '../entities/ride_history_entity.dart';
import '../repositories/ride_history_repository.dart';

class GetRideHistoryUseCase {
  final RideHistoryRepository repository;

  GetRideHistoryUseCase(this.repository);

  Future<RideHistoryEntity> call() async {
    return await repository.getRideHistory();
  }
}

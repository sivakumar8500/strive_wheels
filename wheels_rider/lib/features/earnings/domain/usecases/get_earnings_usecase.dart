import '../entities/earnings_entity.dart';
import '../repositories/earnings_repository.dart';

class GetEarningsUseCase {
  final EarningsRepository repository;

  GetEarningsUseCase(this.repository);

  Future<EarningsEntity> call(int limit, int offset) async {
    return await repository.getEarnings(limit, offset);
  }
}

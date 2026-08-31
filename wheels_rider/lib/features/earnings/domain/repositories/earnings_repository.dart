import '../entities/earnings_entity.dart';

abstract class EarningsRepository {
  Future<EarningsEntity> getEarnings(int limit, int offset);
}

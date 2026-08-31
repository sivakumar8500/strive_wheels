import '../../domain/entities/earnings_entity.dart';
import '../../domain/repositories/earnings_repository.dart';
import '../datasources/earnings_remote_data_source.dart';

class EarningsRepositoryImpl implements EarningsRepository {
  final EarningsRemoteDataSource remoteDataSource;

  EarningsRepositoryImpl(this.remoteDataSource);

  @override
  Future<EarningsEntity> getEarnings(int limit, int offset) async {
    try {
      final model = await remoteDataSource.getEarnings(limit, offset);
      return model.toEntity();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

import '../entities/driver_search_entity.dart';
import '../repositories/driver_search_repository.dart';

class GetDriverSearchUseCase {
  final DriverSearchRepository repository;

  GetDriverSearchUseCase(this.repository);

  Future<DriverSearchEntity> call() async {
    return await repository.getDriverSearchDetails();
  }
}

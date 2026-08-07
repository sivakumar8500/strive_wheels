import '../entities/driver_search_entity.dart';

abstract class DriverSearchRepository {
  Future<DriverSearchEntity> getDriverSearchDetails();
}

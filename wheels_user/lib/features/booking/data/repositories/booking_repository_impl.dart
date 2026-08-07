import '../../domain/entities/recent_journey_entity.dart';
import '../../domain/entities/vehicle_option_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_local_datasource.dart';
import '../models/recent_journey_model.dart';
import '../models/vehicle_option_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource localDataSource;

  BookingRepositoryImpl({required this.localDataSource});

  @override
  Future<List<RecentJourneyEntity>> getRecentJourneys() async {
    final models = await localDataSource.getRecentJourneys();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<VehicleOptionEntity>> getAvailableVehicles() async {
    final models = await localDataSource.getAvailableVehicles();
    return models.map((m) => m.toEntity()).toList();
  }
}

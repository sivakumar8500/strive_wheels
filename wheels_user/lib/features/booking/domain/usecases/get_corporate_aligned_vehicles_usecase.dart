import '../entities/corporate_aligned_vehicle_entity.dart';
import '../repositories/booking_repository.dart';

class GetCorporateAlignedVehiclesUseCase {
  final BookingRepository repository;

  GetCorporateAlignedVehiclesUseCase(this.repository);

  Future<List<CorporateAlignedVehicleEntity>> call({
    double? pickupLat,
    double? pickupLng,
    String? dropAddress,
  }) async {
    return await repository.getCorporateAlignedVehicles(
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropAddress: dropAddress,
    );
  }
}

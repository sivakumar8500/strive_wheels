import '../repositories/rider_repository.dart';
import '../../data/models/location_update_response.dart';

class UpdateLocationUseCase {
  final RiderRepository repository;

  UpdateLocationUseCase(this.repository);

  Future<LocationUpdateResponse> call({required double lat, required double lng}) {
    return repository.updateLocation(lat: lat, lng: lng);
  }
}
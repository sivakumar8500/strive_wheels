import '../repositories/home_repository.dart';

class UpdateLocationUseCase {
  final HomeRepository repository;

  UpdateLocationUseCase(this.repository);

  Future<void> call(double lat, double lng) async {
    return await repository.updateLocation(lat: lat, lng: lng);
  }
}

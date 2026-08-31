abstract class HomeRepository {
  Future<void> updateLocation({required double lat, required double lng});
  Future<void> updateAvailability({required String availabilityMode, required bool isOnline});
}

import '../../data/models/availability_response.dart';
import '../../data/models/location_update_response.dart';
import '../../data/models/booking_action_response.dart';

abstract class RiderRepository {
  Future<AvailabilityResponse> setAvailability({required String mode, required bool isOnline});
  Future<LocationUpdateResponse> updateLocation({required double lat, required double lng});
  Future<BookingActionResponse> acceptBooking(int bookingId);
  Future<BookingActionResponse> markArrived(int bookingId);
  Future<BookingActionResponse> startTrip({required int bookingId, required String otp});
  Future<BookingActionResponse> completeTrip({required int bookingId, required double distanceKm, required int durationMins});
}

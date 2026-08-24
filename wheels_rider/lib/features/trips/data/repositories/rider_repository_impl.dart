import '../../domain/repositories/rider_repository.dart';
import '../datasources/rider_remote_data_source.dart';
import '../models/availability_response.dart';
import '../models/location_update_response.dart';
import '../models/booking_action_response.dart';

class RiderRepositoryImpl implements RiderRepository {
  final RiderRemoteDataSource remoteDataSource;

  RiderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AvailabilityResponse> setAvailability({required String mode, required bool isOnline}) async {
    return remoteDataSource.setAvailability(mode: mode, isOnline: isOnline);
  }

  @override
  Future<LocationUpdateResponse> updateLocation({required double lat, required double lng}) async {
    return remoteDataSource.updateLocation(lat: lat, lng: lng);
  }

  @override
  Future<BookingActionResponse> acceptBooking(int bookingId) async {
    return remoteDataSource.acceptBooking(bookingId);
  }

  @override
  Future<BookingActionResponse> markArrived(int bookingId) async {
    return remoteDataSource.markArrived(bookingId);
  }

  @override
  Future<BookingActionResponse> startTrip({required int bookingId, required String otp}) async {
    return remoteDataSource.startTrip(bookingId: bookingId, otp: otp);
  }

  @override
  Future<BookingActionResponse> completeTrip({required int bookingId, required double distanceKm, required int durationMins}) async {
    return remoteDataSource.completeTrip(bookingId: bookingId, distanceKm: distanceKm, durationMins: durationMins);
  }
}

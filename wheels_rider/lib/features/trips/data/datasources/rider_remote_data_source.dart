import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/availability_response.dart';
import '../models/location_update_response.dart';
import '../models/booking_action_response.dart';

abstract class RiderRemoteDataSource {
  Future<AvailabilityResponse> setAvailability({required String mode, required bool isOnline});
  Future<LocationUpdateResponse> updateLocation({required double lat, required double lng});
  Future<BookingActionResponse> acceptBooking(int bookingId);
  Future<BookingActionResponse> markArrived(int bookingId);
  Future<BookingActionResponse> startTrip({required int bookingId, required String otp});
  Future<BookingActionResponse> completeTrip({required int bookingId, required double distanceKm, required int durationMins});
}

class RiderRemoteDataSourceImpl implements RiderRemoteDataSource {
  final ApiClient apiClient;

  RiderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AvailabilityResponse> setAvailability({required String mode, required bool isOnline}) async {
    final response = await apiClient.post(
      ApiEndpoints.riderAvailability,
      data: {
        'mode': mode,
        'is_online': isOnline,
      },
    );
    return AvailabilityResponse.fromJson(response.data);
  }

  @override
  Future<LocationUpdateResponse> updateLocation({required double lat, required double lng}) async {
    final response = await apiClient.post(
      ApiEndpoints.riderLocation,
      data: {
        'lat': lat,
        'lng': lng,
      },
    );
    return LocationUpdateResponse.fromJson(response.data);
  }

  @override
  Future<BookingActionResponse> acceptBooking(int bookingId) async {
    final response = await apiClient.post(ApiEndpoints.acceptBooking(bookingId));
    return BookingActionResponse.fromJson(response.data);
  }

  @override
  Future<BookingActionResponse> markArrived(int bookingId) async {
    final response = await apiClient.post(ApiEndpoints.markArrived(bookingId));
    return BookingActionResponse.fromJson(response.data);
  }

  @override
  Future<BookingActionResponse> startTrip({required int bookingId, required String otp}) async {
    final response = await apiClient.post(
      ApiEndpoints.startTrip(bookingId),
      data: {
        'otp': otp,
      },
    );
    return BookingActionResponse.fromJson(response.data);
  }

  @override
  Future<BookingActionResponse> completeTrip({required int bookingId, required double distanceKm, required int durationMins}) async {
    final response = await apiClient.post(
      ApiEndpoints.completeTrip(bookingId),
      data: {
        'actual_distance_km': distanceKm,
        'actual_duration_mins': durationMins,
      },
    );
    return BookingActionResponse.fromJson(response.data);
  }
}

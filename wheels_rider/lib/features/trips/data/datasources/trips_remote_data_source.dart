import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/trip_model.dart';

abstract class TripsRemoteDataSource {
  Future<TripModel> getTrips(int limit, int offset);
}

class TripsRemoteDataSourceImpl implements TripsRemoteDataSource {
  final ApiClient _apiClient;

  TripsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<TripModel> getTrips(int limit, int offset) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.riderBookings(limit: limit, offset: offset));
      
      List<dynamic> dataList = [];
      if (response.data is List) {
        dataList = response.data;
      } else if (response.data is Map && response.data['data'] is List) {
        dataList = response.data['data'];
      }

      final bookings = dataList.map((e) => BookingModel.fromJson(e)).toList();

      return TripModel(
        totalMileage: 0.0,
        totalRides: bookings.length,
        avgRating: 0.0,
        bookings: bookings,
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch trips');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class HomeRemoteDataSource {
  Future<void> updateLocation({required double lat, required double lng});
  Future<void> updateAvailability({required String availabilityMode, required bool isOnline});
  Future<void> updateAvailabilitySchedule(List<DateTime> dates);
  Future<List<DateTime>> getAvailabilitySchedule();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> updateLocation({required double lat, required double lng}) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.riderLocation,
        data: {
          "lat": lat,
          "lng": lng,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to update location',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Unknown error occurred while updating location';
      final responseData = e.response?.data;
      if (responseData is Map) {
        final message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          errorMessage = message;
        }
      } else {
        if (e.message != null && e.message!.isNotEmpty) {
          errorMessage = e.message!;
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<void> updateAvailability({required String availabilityMode, required bool isOnline}) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.riderAvailability,
        data: {
          "availability_mode": availabilityMode,
          "is_online": isOnline,
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to update availability',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Unknown error occurred while updating availability';
      final responseData = e.response?.data;
      if (responseData is Map) {
        final message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          errorMessage = message;
        }
      } else {
        if (e.message != null && e.message!.isNotEmpty) {
          errorMessage = e.message!;
        }
      }
      throw Exception(errorMessage);
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<void> updateAvailabilitySchedule(List<DateTime> dates) async {
    try {
      final List<Map<String, dynamic>> payload = dates.map((date) => {
        "date": "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "is_available": true,
        "notes": ""
      }).toList();

      final response = await apiClient.post(
        ApiEndpoints.riderAvailabilitySchedule,
        data: payload,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to update availability schedule',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Unknown error occurred while updating availability schedule';
      final responseData = e.response?.data;
      if (responseData is Map) {
        final message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          errorMessage = message;
        }
      } else {
        if (e.message != null && e.message!.isNotEmpty) {
          errorMessage = e.message!;
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }

  @override
  Future<List<DateTime>> getAvailabilitySchedule() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.riderAvailabilitySchedule,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'];
        if (data is List) {
          return data
              .where((item) => item['is_available'] == true)
              .map((item) => DateTime.parse(item['date'] as String))
              .toList();
        }
        return [];
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to fetch availability schedule',
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Unknown error occurred while fetching availability schedule';
      final responseData = e.response?.data;
      if (responseData is Map) {
        final message = responseData['message'];
        if (message is String && message.isNotEmpty) {
          errorMessage = message;
        }
      } else {
        if (e.message != null && e.message!.isNotEmpty) {
          errorMessage = e.message!;
        }
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred');
    }
  }
}

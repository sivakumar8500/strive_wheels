import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

abstract class HomeRemoteDataSource {
  Future<void> updateLocation({required double lat, required double lng});
  Future<void> updateAvailability({required String availabilityMode, required bool isOnline});
  Future<void> updateAvailabilitySchedule(List<DateTime> dates, {List<DateTime>? allWorkingDays});
  Future<List<DateTime>> getAvailabilitySchedule({DateTime? startDate});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({required this.apiClient});

  DateTime _calculateNextWorkingDay() {
    DateTime current = DateTime.now().add(const Duration(days: 1));
    while (current.weekday == DateTime.saturday || current.weekday == DateTime.sunday) {
      current = current.add(const Duration(days: 1));
    }
    return DateTime(current.year, current.month, current.day);
  }

  @override
  Future<void> updateLocation({required double lat, required double lng}) async {
    try {
      await apiClient.post(
        ApiEndpoints.riderLocation,
        data: {
          "lat": lat,
          "lng": lng,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to update location');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
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
    }
  }

  List<DateTime> _calculateNextWorkingDays(int count) {
    List<DateTime> days = [];
    DateTime current = DateTime.now().add(const Duration(days: 1));
    current = DateTime(current.year, current.month, current.day);
    while (days.length < count) {
      if (current.weekday != DateTime.saturday && current.weekday != DateTime.sunday) {
        days.add(current);
      }
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  @override
  Future<void> updateAvailabilitySchedule(List<DateTime> dates, {List<DateTime>? allWorkingDays}) async {
    try {
      final daysToUpdate = (allWorkingDays != null && allWorkingDays.isNotEmpty)
          ? allWorkingDays
          : _calculateNextWorkingDays(5);

      final List<Map<String, dynamic>> payload = daysToUpdate.map((date) {
        final isAvailable = dates.any(
          (d) => d.year == date.year && d.month == date.month && d.day == date.day,
        );
        return {
          "date": "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
          "is_available": isAvailable,
          "notes": ""
        };
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
  Future<List<DateTime>> getAvailabilitySchedule({DateTime? startDate}) async {
    try {
      final queryDate = startDate ?? _calculateNextWorkingDay();
      final dateStr =
          "${queryDate.year}-${queryDate.month.toString().padLeft(2, '0')}-${queryDate.day.toString().padLeft(2, '0')}";

      final response = await apiClient.get(
        ApiEndpoints.riderAvailabilitySchedule,
        queryParameters: {'start_date': dateStr},
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

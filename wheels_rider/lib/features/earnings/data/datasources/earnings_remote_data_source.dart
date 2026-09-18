import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/earnings_model.dart';

abstract class EarningsRemoteDataSource {
  Future<EarningsModel> getEarnings(int limit, int offset);
}

class EarningsRemoteDataSourceImpl implements EarningsRemoteDataSource {
  final ApiClient _apiClient;

  EarningsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<EarningsModel> getEarnings(int limit, int offset) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.riderEarnings(limit: limit, offset: offset));
      
      if (response.data is Map && response.data['data'] is Map) {
        return EarningsModel.fromJson(Map<String, dynamic>.from(response.data['data']));
      } else if (response.data is Map && response.data['data'] is List) {
        final dataList = response.data['data'] as List;
        final activities = dataList.map((e) => EarningsActivityModel.fromJson(Map<String, dynamic>.from(e))).toList();
        final double total = activities.fold(0.0, (sum, a) => sum + a.amount);
        return EarningsModel(
          totalEarnings: total,
          trips: activities.length,
          hours: (activities.length * 0.4),
          rating: 5.0,
          recentActivities: activities,
        );
      } else if (response.data is List) {
        final dataList = response.data as List;
        final activities = dataList.map((e) => EarningsActivityModel.fromJson(Map<String, dynamic>.from(e))).toList();
        final double total = activities.fold(0.0, (sum, a) => sum + a.amount);
        return EarningsModel(
          totalEarnings: total,
          trips: activities.length,
          hours: (activities.length * 0.4),
          rating: 5.0,
          recentActivities: activities,
        );
      } else if (response.data is Map) {
        return EarningsModel.fromJson(Map<String, dynamic>.from(response.data));
      }

      return const EarningsModel(
        totalEarnings: 0.0,
        trips: 0,
        hours: 0.0,
        rating: 0.0,
        recentActivities: [],
      );
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch earnings');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}

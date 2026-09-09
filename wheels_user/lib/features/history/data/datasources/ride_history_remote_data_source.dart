import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../models/booking_history_model.dart';

abstract class RideHistoryRemoteDataSource {
  Future<List<BookingHistoryModel>> getBookingHistory();
}

class RideHistoryRemoteDataSourceImpl implements RideHistoryRemoteDataSource {
  final Dio dio;

  RideHistoryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BookingHistoryModel>> getBookingHistory() async {
    try {
      final response = await dio.get(ApiConstants.bookings);
      if (response.statusCode == 200 && response.data != null) {
        final raw = response.data;
        List<dynamic> list = [];
        if (raw is Map && raw['data'] is List) {
          list = raw['data'] as List;
        } else if (raw is List) {
          list = raw;
        }
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => BookingHistoryModel.fromApiJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('Ride history API error: $e');
      return [];
    }
  }
}

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
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => BookingHistoryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

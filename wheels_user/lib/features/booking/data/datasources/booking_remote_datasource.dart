import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_constants.dart';
import '../models/fare_estimate_model.dart';
import '../models/vehicle_type_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<VehicleTypeModel>> getVehicleTypes();
  Future<FareEstimateModel> getFareEstimate({
    required int vehicleTypeId,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    double distanceKm = 0.0,
    int durationMins = 0,
    String serviceMode = 'NORMAL',
    String bookingMode = 'INSTANT',
    String tripType = 'ONE_WAY',
    String couponCode = 'string',
    bool isAc = true,
    bool isOutstation = false,
    int vehicleAgeYears = 2,
    String weather = 'CLEAR',
    String trafficLevel = 'LOW',
  });
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final Dio dio;

  BookingRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VehicleTypeModel>> getVehicleTypes() async {
    try {
      final response = await dio.get(
        ApiConstants.vehicleTypes,
        options: Options(
          headers: {'accept': 'application/json'},
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map ? response.data : {};
        final List<dynamic> list = data['data'] ?? [];
        return list
            .map((item) =>
                VehicleTypeModel.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<FareEstimateModel> getFareEstimate({
    required int vehicleTypeId,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    double distanceKm = 0.0,
    int durationMins = 0,
    String serviceMode = 'NORMAL',
    String bookingMode = 'INSTANT',
    String tripType = 'ONE_WAY',
    String couponCode = 'string',
    bool isAc = true,
    bool isOutstation = false,
    int vehicleAgeYears = 2,
    String weather = 'CLEAR',
    String trafficLevel = 'LOW',
  }) async {
    final requestBody = {
      'service_mode': serviceMode,
      'company_id': 1,
      'booking_mode': bookingMode,
      'trip_type': tripType,
      'vehicle_type_id': vehicleTypeId,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'drop_lat': dropLat,
      'drop_lng': dropLng,
      'distance_km': distanceKm,
      'duration_mins': durationMins,
      'return_drop_lat': 0,
      'return_drop_lng': 0,
      'waiting_duration_mins': 0,
      'coupon_code': couponCode,
      'is_ac': isAc,
      'is_outstation': isOutstation,
      'vehicle_age_years': vehicleAgeYears,
      'weather': weather,
      'traffic_level': trafficLevel,
    };

    debugPrint('=== Fare Estimate Request ===');
    debugPrint('URL : ${ApiConstants.baseUrl}${ApiConstants.fareEstimate}');
    debugPrint('Body: $requestBody');

    final response = await dio.post(
      ApiConstants.fareEstimate,
      data: requestBody,
      options: Options(
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        sendTimeout: const Duration(seconds: 12),
        receiveTimeout: const Duration(seconds: 12),
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final raw = response.data is Map ? response.data as Map : {};
      final dataMap = raw['data'];
      if (dataMap != null) {
        return FareEstimateModel.fromJson(
            Map<String, dynamic>.from(dataMap as Map));
      }
    }
    throw Exception('Fare estimate API returned unexpected response');
  }
}

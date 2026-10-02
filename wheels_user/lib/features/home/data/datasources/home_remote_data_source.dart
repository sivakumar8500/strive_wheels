import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_constants.dart';
import '../models/coupon_model.dart';
import '../models/popular_location_model.dart';
import '../models/quick_service_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<QuickServiceModel>> getQuickServices();
  Future<List<PopularLocationModel>> getPopularLocations();
  Future<List<CouponModel>> getActiveCoupons();
  Future<Map<String, dynamic>?> getCustomerProfile();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<QuickServiceModel>> getQuickServices() async {
    try {
      final response = await dio.get(ApiConstants.quickServices);
      debugPrint('====== QUICK SERVICES RESPONSE ======');
      debugPrint('${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => QuickServiceModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('====== QUICK SERVICES ERROR ======');
      debugPrint('$e');
      return [];
    }
  }

  @override
  Future<List<PopularLocationModel>> getPopularLocations() async {
    try {
      final response = await dio.get(ApiConstants.popularLocations);
      debugPrint('====== POPULAR LOCATIONS RESPONSE ======');
      debugPrint('${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => PopularLocationModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('====== POPULAR LOCATIONS ERROR ======');
      debugPrint('$e');
      return [];
    }
  }

  @override
  Future<List<CouponModel>> getActiveCoupons() async {
    try {
      final response = await dio.get(
        ApiConstants.coupons,
        queryParameters: {'limit': 50, 'offset': 0},
      );
      debugPrint('====== ACTIVE COUPONS RESPONSE ======');
      debugPrint('${response.data}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => CouponModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('====== ACTIVE COUPONS ERROR ======');
      debugPrint('$e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>?> getCustomerProfile() async {
    try {
      final response = await dio.get(ApiConstants.customerProfile);
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

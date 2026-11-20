import 'package:dio/dio.dart';

import '../../../../core/network/api_constants.dart';
import '../models/coupon_model.dart';
import '../models/popular_location_model.dart';
import '../models/quick_service_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<QuickServiceModel>> getQuickServices();
  Future<List<PopularLocationModel>> getPopularLocations();
  Future<List<CouponModel>> getActiveCoupons();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<QuickServiceModel>> getQuickServices() async {
    try {
      final response = await dio.get(ApiConstants.quickServices);
      print('====== QUICK SERVICES RESPONSE ======');
      print(response.data);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => QuickServiceModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('====== QUICK SERVICES ERROR ======');
      print(e);
      return [];
    }
  }

  @override
  Future<List<PopularLocationModel>> getPopularLocations() async {
    try {
      final response = await dio.get(ApiConstants.popularLocations);
      print('====== POPULAR LOCATIONS RESPONSE ======');
      print(response.data);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => PopularLocationModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('====== POPULAR LOCATIONS ERROR ======');
      print(e);
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
      print('====== ACTIVE COUPONS RESPONSE ======');
      print(response.data);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((e) => CouponModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('====== ACTIVE COUPONS ERROR ======');
      print(e);
      return [];
    }
  }
}

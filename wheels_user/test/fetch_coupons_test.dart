import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:wheels_user/core/network/api_constants.dart';
import 'package:wheels_user/features/home/data/models/coupon_model.dart';
import 'package:wheels_user/features/home/data/datasources/home_remote_data_source.dart';

void main() {
  test('Test Fetching Coupons with Dio directly', () async {
    final token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2Iiwicm9sZXMiOlsiQ1VTVE9NRVIiXSwicGVybWlzc2lvbnMiOltdLCJleHAiOjE3ODc4MjA4NjEsInR5cGUiOiJhY2Nlc3MifQ.cHB0SbTO0bIWGMT38defk_NbHNF8VMJ7NC276CDI2LM';
    
    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['accept'] = 'application/json';

    final dataSource = HomeRemoteDataSourceImpl(dio: dio);
    
    try {
      final coupons = await dataSource.getActiveCoupons();
      print('TEST SUCCESS! Fetched \${coupons.length} coupons.');
      for (var c in coupons) {
        print('Coupon: \${c.code}, \${c.discountType}, \${c.discountValue}');
      }
    } catch (e, st) {
      print('TEST ERROR: $e');
      print(st);
      fail('Failed to fetch coupons');
    }
  });
}

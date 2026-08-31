import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final Dio _dio;
  final SharedPreferences _sharedPreferences;

  ApiClient({required this._dio, required this._sharedPreferences}) {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add interceptors for logging or token injection
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _sharedPreferences.getString('user_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            var body = response.requestOptions.data;
            if (body is FormData) {
              final fields = body.fields.map((f) => '${f.key}: ${f.value}').join(', ');
              final files = body.files.map((f) => '${f.key}: ${f.value.filename}').join(', ');
              body = 'FormData(fields: [$fields], files: [$files])';
            }
            print('============================');
            print('url : ${response.requestOptions.uri}');
            print('body : $body');
            print('responce : ${response.data}');
            print('===========================');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            var body = e.requestOptions.data;
            if (body is FormData) {
              final fields = body.fields.map((f) => '${f.key}: ${f.value}').join(', ');
              final files = body.files.map((f) => '${f.key}: ${f.value.filename}').join(', ');
              body = 'FormData(fields: [$fields], files: [$files])';
            }
            print('============================');
            print('url : ${e.requestOptions.uri}');
            print('body : $body');
            print('responce : ${e.response?.data ?? e.message}');
            print('===========================');
          }
          return handler.next(e);
        },
      ),
    );
  }

  // GET Request
  Future<Response> get(String url, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST Request
  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
      );
      return response;
    } catch (e) {
      if (e is DioException && e.response != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          throw Exception(data['message']);
        } else if (data is Map && data.containsKey('detail')) {
          throw Exception(data['detail'].toString());
        }
        throw Exception(data.toString());
      }
      rethrow;
    }
  }

  // PUT Request
  Future<Response> put(String url, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.put(url, data: data, queryParameters: queryParameters, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE Request
  Future<Response> delete(String url, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await _dio.delete(url, data: data, queryParameters: queryParameters, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

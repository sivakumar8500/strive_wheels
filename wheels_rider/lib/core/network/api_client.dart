import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../features/auth/presentation/pages/login_page.dart';

class ApiClient {
  final Dio _dio;
  final SharedPreferences _sharedPreferences;
  static Future<String?>? _refreshTokenFuture;

  ApiClient(this._dio, this._sharedPreferences) {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add interceptors for logging or token injection & automatic refresh
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _sharedPreferences.getString('user_token') ??
                        _sharedPreferences.getString('access_token');
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

          final data = response.data;
          if (data is Map && data['success'] == false) {
            final message = data['message']?.toString() ?? '';
            final errorCode = data['error'] != null && data['error'] is Map ? data['error']['code'] : null;
            if (message == 'Invalid access token.' || errorCode == 'UNAUTHORIZED') {
              _redirectToLogin();
            }
          }
          
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
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
          
          final data = e.response?.data;
          final message = data is Map ? data['message']?.toString() : null;
          final errorCode = data is Map && data['error'] != null && data['error'] is Map ? data['error']['code'] : null;
          final is401 = e.response?.statusCode == 401 || message == 'Invalid access token.' || errorCode == 'UNAUTHORIZED';
          final isRefreshPath = e.requestOptions.path.contains('/auth/refresh') || e.requestOptions.path.contains('/refresh');

          if (is401 && !isRefreshPath) {
            try {
              _refreshTokenFuture ??= _performTokenRefresh();
              final newAccessToken = await _refreshTokenFuture;
              _refreshTokenFuture = null;

              if (newAccessToken != null && newAccessToken.isNotEmpty) {
                final retryOptions = e.requestOptions;
                retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

                final retryDio = Dio(BaseOptions(
                  connectTimeout: const Duration(seconds: 30),
                  receiveTimeout: const Duration(seconds: 30),
                ));

                final retriedResponse = await retryDio.fetch(retryOptions);
                return handler.resolve(retriedResponse);
              }
            } catch (refreshError) {
              _refreshTokenFuture = null;
              debugPrint('[ApiClient] Token refresh error: $refreshError');
              await _redirectToLogin();
              return handler.next(e);
            }
          }

          if (is401) {
            await _redirectToLogin();
          }
          
          return handler.next(e);
        },
      ),
    );
  }

  Future<String?> _performTokenRefresh() async {
    final refreshToken = _sharedPreferences.getString('user_refresh_token') ??
                         _sharedPreferences.getString('refresh_token');

    if (refreshToken == null || refreshToken.isEmpty) {
      debugPrint('[ApiClient] No refresh token found.');
      return null;
    }

    try {
      final refreshDio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ));

      const refreshUrl = 'http://15.252.129.37:8200/api/v1/auth/refresh';
      debugPrint('[ApiClient] Triggering token refresh: $refreshUrl');

      final response = await refreshDio.post(
        refreshUrl,
        data: {
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        Map<String, dynamic> dataMap = {};
        
        if (data is Map<String, dynamic>) {
          if (data['data'] is Map<String, dynamic>) {
            dataMap = data['data'] as Map<String, dynamic>;
          } else {
            dataMap = data;
          }
        }

        final newAccessToken = (dataMap['access_token'] as String?) ?? (dataMap['token'] as String?);
        final newRefreshToken = (dataMap['refresh_token'] as String?);

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          debugPrint('[ApiClient] Token refreshed successfully!');
          await _sharedPreferences.setString('user_token', newAccessToken);
          await _sharedPreferences.setString('access_token', newAccessToken);
          
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await _sharedPreferences.setString('user_refresh_token', newRefreshToken);
            await _sharedPreferences.setString('refresh_token', newRefreshToken);
          }
          return newAccessToken;
        }
      }
    } catch (e) {
      debugPrint('[ApiClient] Token refresh API error: $e');
    }

    return null;
  }

  Future<void> _redirectToLogin() async {
    await _sharedPreferences.remove('user_token');
    await _sharedPreferences.remove('access_token');
    await _sharedPreferences.remove('user_refresh_token');
    await _sharedPreferences.remove('refresh_token');

    if (navigatorKey.currentContext != null) {
      Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
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

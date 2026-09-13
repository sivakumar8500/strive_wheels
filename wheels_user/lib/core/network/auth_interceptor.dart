import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _sharedPreferences;
  static Future<String?>? _refreshTokenFuture;
  
  AuthInterceptor(this._sharedPreferences);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiConstants.contentTypeKey] ??= ApiConstants.applicationJson;

    final accessToken = _sharedPreferences.getString('access_token') ?? 
                        _sharedPreferences.getString('user_token');
    
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers[ApiConstants.authorizationKey] = 'Bearer $accessToken';
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;
    final is401 = response?.statusCode == 401;
    final isRefreshPath = err.requestOptions.path.contains('/auth/refresh') || 
                          err.requestOptions.path.contains('/refresh');

    if (is401 && !isRefreshPath) {
      try {
        // Handle concurrent refresh calls cleanly by sharing a single Future
        _refreshTokenFuture ??= _performTokenRefresh();
        final newAccessToken = await _refreshTokenFuture;
        _refreshTokenFuture = null;

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          // Clone request and retry with new access token
          final requestOptions = err.requestOptions;
          requestOptions.headers[ApiConstants.authorizationKey] = 'Bearer $newAccessToken';
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryDio = Dio(BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
          ));

          final retriedResponse = await retryDio.fetch(requestOptions);
          return handler.resolve(retriedResponse);
        }
      } catch (refreshError) {
        _refreshTokenFuture = null;
        debugPrint('[AuthInterceptor] Token refresh failed: $refreshError');
        await _clearTokens();
      }
    }

    super.onError(err, handler);
  }

  Future<String?> _performTokenRefresh() async {
    final refreshToken = _sharedPreferences.getString('refresh_token') ?? 
                         _sharedPreferences.getString('user_refresh_token');

    if (refreshToken == null || refreshToken.isEmpty) {
      debugPrint('[AuthInterceptor] No refresh token found in storage.');
      await _clearTokens();
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

      const refreshUrl = '${ApiConstants.baseUrl}/auth/refresh';
      debugPrint('[AuthInterceptor] Hitting refresh endpoint: $refreshUrl');

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

        final newAccessToken = (dataMap['access_token'] as String?) ?? 
                               (dataMap['token'] as String?);
        final newRefreshToken = (dataMap['refresh_token'] as String?);

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          debugPrint('[AuthInterceptor] Token refresh success! Received new access token.');
          await _sharedPreferences.setString('access_token', newAccessToken);
          await _sharedPreferences.setString('user_token', newAccessToken);
          
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await _sharedPreferences.setString('refresh_token', newRefreshToken);
            await _sharedPreferences.setString('user_refresh_token', newRefreshToken);
          }
          return newAccessToken;
        }
      }
    } catch (e) {
      debugPrint('[AuthInterceptor] Refresh API call error: $e');
    }

    await _clearTokens();
    return null;
  }

  Future<void> _clearTokens() async {
    await _sharedPreferences.remove('access_token');
    await _sharedPreferences.remove('user_token');
    await _sharedPreferences.remove('refresh_token');
    await _sharedPreferences.remove('user_refresh_token');
  }
}

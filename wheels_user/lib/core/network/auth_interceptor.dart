import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';
import 'session_manager.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences _sharedPreferences;
  final SessionManager? _sessionManager;

  AuthInterceptor(this._sharedPreferences, {SessionManager? sessionManager})
      : _sessionManager = sessionManager;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers[ApiConstants.contentTypeKey] ??= ApiConstants.applicationJson;

    final isRefreshPath = options.path.contains('/auth/refresh') || options.path.contains('/refresh');
    final isAuthPath = options.path.contains('/auth/send-otp') || options.path.contains('/auth/verify-otp');

    String? accessToken;
    if (_sessionManager != null && !isRefreshPath && !isAuthPath) {
      accessToken = await _sessionManager!.getValidAccessToken();
    } else {
      accessToken = _sharedPreferences.getString('access_token') ??
                    _sharedPreferences.getString('user_token');
    }

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

    final isAlreadyRetried = err.requestOptions.extra['is_retry'] == true;

    if (is401 && !isRefreshPath && !isAlreadyRetried) {
      try {
        final sessionMgr = _sessionManager ?? SessionManager(_sharedPreferences);
        final newAccessToken = await sessionMgr.refreshSession();

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          final requestOptions = err.requestOptions;
          requestOptions.headers[ApiConstants.authorizationKey] = 'Bearer $newAccessToken';
          requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          requestOptions.extra['is_retry'] = true;

          final retryDio = Dio(BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
          ));

          final retriedResponse = await retryDio.fetch(requestOptions);
          return handler.resolve(retriedResponse);
        }
      } catch (refreshError) {
        debugPrint('[AuthInterceptor] Token refresh retry error: $refreshError');
      }
    }

    super.onError(err, handler);
  }
}

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/jwt_utils.dart';

/// Centralized Session & Token Refresh Manager for Rider App.
/// Provides deduplicated in-flight token refresh across HTTP and WebSockets.
class SessionManager {
  final SharedPreferences _prefs;
  
  Future<String?>? _inFlightRefreshFuture;
  final _sessionStreamController = StreamController<String?>.broadcast();

  /// Emits new access token on successful refresh
  Stream<String?> get onTokenRefreshed => _sessionStreamController.stream;

  /// Callback executed when refresh token is definitively expired/revoked
  VoidCallback? onSessionExpired;

  SessionManager(this._prefs);

  String? get accessToken =>
      _prefs.getString('user_token') ?? _prefs.getString('access_token');

  String? get refreshToken =>
      _prefs.getString('user_refresh_token') ?? _prefs.getString('refresh_token');

  /// Saves newly issued access token and optional rotated refresh token
  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    await _prefs.setString('user_token', accessToken);
    await _prefs.setString('access_token', accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _prefs.setString('user_refresh_token', refreshToken);
      await _prefs.setString('refresh_token', refreshToken);
    }
    _sessionStreamController.add(accessToken);
  }

  /// Clears session token storage
  Future<void> clearSession() async {
    await _prefs.remove('user_token');
    await _prefs.remove('access_token');
    await _prefs.remove('user_refresh_token');
    await _prefs.remove('refresh_token');
    await _prefs.remove('is_authenticated');
  }

  /// Checks if access token is missing, invalid, or expiring within [marginSeconds]
  bool isTokenExpiringSoon({int marginSeconds = 120}) {
    final token = accessToken;
    if (token == null || token.isEmpty) return true;
    return JwtUtils.isTokenExpiring(token, marginSeconds: marginSeconds);
  }

  /// Obtains valid access token, performing proactive refresh if expiring soon
  Future<String?> getValidAccessToken() async {
    if (isTokenExpiringSoon()) {
      debugPrint('[SessionManager Rider] Access token expiring soon or missing. Proactively refreshing...');
      return await refreshSession();
    }
    return accessToken;
  }

  /// Single deduplicated in-flight token refresh operation
  Future<String?> refreshSession({bool force = false}) async {
    if (!force && !isTokenExpiringSoon(marginSeconds: 15)) {
      return accessToken;
    }

    if (_inFlightRefreshFuture != null) {
      debugPrint('[SessionManager Rider] In-flight refresh in progress. Awaiting result...');
      return await _inFlightRefreshFuture;
    }

    _inFlightRefreshFuture = _performRefresh();
    try {
      final newToken = await _inFlightRefreshFuture;
      return newToken;
    } finally {
      _inFlightRefreshFuture = null;
    }
  }

  Future<String?> _performRefresh() async {
    final curRefreshToken = refreshToken;
    if (curRefreshToken == null || curRefreshToken.isEmpty) {
      debugPrint('[SessionManager Rider] No refresh token found. Triggering session expiry.');
      await handleSessionExpiry();
      return null;
    }

    try {
      final refreshDio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ));

      const refreshUrl = 'http://15.252.129.37:8200/api/v1/auth/refresh';
      debugPrint('[SessionManager Rider] Sending refresh request to $refreshUrl...');

      final response = await refreshDio.post(
        refreshUrl,
        data: {'refresh_token': curRefreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        Map<String, dynamic> dataMap = {};
        if (data is Map<String, dynamic>) {
          dataMap = (data['data'] is Map<String, dynamic>)
              ? data['data'] as Map<String, dynamic>
              : data;
        }

        final newAccess = (dataMap['access_token'] as String?) ?? (dataMap['token'] as String?);
        final newRefresh = (dataMap['refresh_token'] as String?);

        if (newAccess != null && newAccess.isNotEmpty) {
          debugPrint('[SessionManager Rider] Refresh success! Issued new access token.');
          await saveTokens(accessToken: newAccess, refreshToken: newRefresh);
          return newAccess;
        }
      }

      if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 422) {
        debugPrint('[SessionManager Rider] Refresh token rejected with HTTP ${response.statusCode}. Expiry triggered.');
        await handleSessionExpiry();
        return null;
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 400 || status == 401 || status == 403 || status == 422) {
        debugPrint('[SessionManager Rider] Refresh token error ($status). Triggering session expiry.');
        await handleSessionExpiry();
        return null;
      }
      debugPrint('[SessionManager Rider] Network or server error during refresh: $e. Session retained.');
      return null;
    } catch (e) {
      debugPrint('[SessionManager Rider] Unexpected exception during refresh: $e');
      return null;
    }

    return null;
  }

  Future<void> handleSessionExpiry() async {
    debugPrint('[SessionManager Rider] Session expired. Clearing credentials & notifying callback.');
    await clearSession();
    onSessionExpired?.call();
  }
}

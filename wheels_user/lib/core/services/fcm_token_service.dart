import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_constants.dart';

/// Centralized service to update FCM token via API on app install / startup.
class FcmTokenService {
  final Dio dio;
  final SharedPreferences sharedPreferences;

  static const String _fcmTokenRegisteredKey = 'is_fcm_token_registered_on_install';

  FcmTokenService({
    required this.dio,
    required this.sharedPreferences,
  });

  /// Sends the FCM token PUT request to the auth API endpoint.
  /// Triggered once when the app is installed / launched.
  Future<bool> updateFcmToken({String token = 'string'}) async {
    try {
      final response = await dio.put(
        ApiConstants.updateFcmToken,
        data: {
          'fcm_token': token,
        },
        options: Options(
          headers: {
            'accept': ApiConstants.applicationJson,
            ApiConstants.contentTypeKey: ApiConstants.applicationJson,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('====== FCM TOKEN UPDATED SUCCESSFULLY ======');
        debugPrint('Response: ${response.data}');
        await sharedPreferences.setBool(_fcmTokenRegisteredKey, true);
        return true;
      }
      debugPrint('====== FCM TOKEN UPDATE FAILED: ${response.statusCode} ======');
      return false;
    } catch (e) {
      debugPrint('====== FCM TOKEN UPDATE ERROR ======: $e');
      return false;
    }
  }

  /// Automatically registers the FCM token on app installation / first launch.
  Future<void> registerFcmTokenOnInstall({String token = 'string'}) async {
    final isRegistered = sharedPreferences.getBool(_fcmTokenRegisteredKey) ?? false;
    if (!isRegistered) {
      debugPrint('[FcmTokenService] App installed/launched for the first time. Invoking FCM Token API...');
      await updateFcmToken(token: token);
    } else {
      // Re-update token to ensure server synchronization
      await updateFcmToken(token: token);
    }
  }
}

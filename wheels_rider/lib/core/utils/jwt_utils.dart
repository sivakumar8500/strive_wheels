import 'dart:convert';
import 'package:flutter/foundation.dart';

class JwtUtils {
  /// Safely extracts the user/driver ID from a JWT access token string
  static int? getUserIdFromJwt(String? token) {
    if (token == null || token.trim().isEmpty) return null;

    try {
      final parts = token.trim().split('.');
      if (parts.length != 3) return null;

      final normalized = base64Url.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> payload = jsonDecode(payloadString);

      final rawId = payload['sub'] ??
          payload['user_id'] ??
          payload['driver_id'] ??
          payload['rider_id'] ??
          payload['id'] ??
          payload['user']?['id'];

      if (rawId != null) {
        return int.tryParse(rawId.toString());
      }
    } catch (e) {
      debugPrint('[JwtUtils] Error parsing JWT token payload: $e');
    }
    return null;
  }

  /// Parses the exp claim from a JWT token string
  static DateTime? getTokenExpiration(String? token) {
    if (token == null || token.trim().isEmpty) return null;

    try {
      final parts = token.trim().split('.');
      if (parts.length != 3) return null;

      final normalized = base64Url.normalize(parts[1]);
      final payloadString = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> payload = jsonDecode(payloadString);

      final exp = payload['exp'];
      if (exp is num) {
        return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000, isUtc: true);
      }
    } catch (e) {
      debugPrint('[JwtUtils] Error parsing JWT exp: $e');
    }
    return null;
  }

  /// Checks if token is null, invalid, or expiring within [marginSeconds]
  static bool isTokenExpiring(String? token, {int marginSeconds = 120}) {
    final exp = getTokenExpiration(token);
    if (exp == null) return true;
    final cutoff = DateTime.now().toUtc().add(Duration(seconds: marginSeconds));
    return exp.isBefore(cutoff);
  }
}

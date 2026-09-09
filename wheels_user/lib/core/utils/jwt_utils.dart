import 'dart:convert';
import 'package:flutter/foundation.dart';

class JwtUtils {
  /// Safely extracts the user/customer ID from a JWT access token string
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
          payload['customer_id'] ??
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
}

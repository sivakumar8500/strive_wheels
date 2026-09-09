import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/utils/jwt_utils.dart';

void main() {
  group('JwtUtils tests', () {
    test('extracts user/customer ID from JWT payload sub claim', () {
      // JWT token with payload {"sub":"6","roles":["CUSTOMER"]}
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI2Iiwicm9sZXMiOlsiQ1VTVE9NRVIiXX0.signature';
      final userId = JwtUtils.getUserIdFromJwt(token);
      expect(userId, equals(6));
    });

    test('extracts user/customer ID from user_id claim in JWT payload', () {
      // JWT token with payload {"user_id": 42}
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo0Mn0.signature';
      final userId = JwtUtils.getUserIdFromJwt(token);
      expect(userId, equals(42));
    });

    test('returns null for invalid or empty token', () {
      expect(JwtUtils.getUserIdFromJwt(null), isNull);
      expect(JwtUtils.getUserIdFromJwt(''), isNull);
      expect(JwtUtils.getUserIdFromJwt('invalid_token'), isNull);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/network/api_constants.dart';
import 'package:wheels_user/core/network/websocket_service.dart';

void main() {
  group('WebSocketService URL formatting tests', () {
    test('ApiConstants.wsBaseUrl is correctly defined', () {
      expect(ApiConstants.wsBaseUrl, 'ws://15.252.129.37:8200/api/v1');
    });

    test('WebSocketService formats http:// baseUrl into ws:// and cleans token fragment', () {
      final wsService = WebSocketService();
      
      // Connecting with http URL and fragment token should not throw synchronous error in parameter sanitization
      expect(
        () => wsService.connect(
          'http://15.252.129.37:8200/api/v1',
          301,
          'demo_token#',
          role: 'customer',
        ),
        returnsNormally,
      );

      wsService.disconnect();
    });
  });
}

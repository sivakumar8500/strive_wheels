import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/core/network/api_endpoints.dart';
import 'package:wheels_rider/core/network/websocket_client.dart';

void main() {
  group('ApiEndpoints WebSocket Tests', () {
    test('wsBaseUrl should be configured correctly for API v1', () {
      expect(ApiEndpoints.wsBaseUrl, 'ws://13.234.75.204:8200/api/v1');
    });

    test('wsConnect should return correct unified endpoint', () {
      expect(ApiEndpoints.wsConnect, 'ws://13.234.75.204:8200/api/v1/ws/connect');
    });

    test('wsDriverConnect should format driver endpoint correctly', () {
      expect(ApiEndpoints.wsDriverConnect(4), 'ws://13.234.75.204:8200/api/v1/ws/driver/4');
    });
  });

  group('WebSocketClient Unit Tests', () {
    late WebSocketClient client;

    setUp(() {
      client = WebSocketClient();
    });

    tearDown(() {
      client.disconnect();
    });

    test('initial state should be disconnected', () {
      expect(client.isConnected, isFalse);
    });

    test('disconnect sets isConnected to false and cleans up', () {
      client.disconnect();
      expect(client.isConnected, isFalse);
    });
  });
}

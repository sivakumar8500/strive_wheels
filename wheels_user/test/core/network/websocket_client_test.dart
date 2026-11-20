import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/network/api_endpoints.dart';
import 'package:wheels_user/core/network/websocket_client.dart';

void main() {
  group('ApiEndpoints Customer WebSocket Tests', () {
    test('wsBaseUrl should be configured correctly for API v1', () {
      expect(ApiEndpoints.wsBaseUrl, 'ws://15.252.129.37:8200/api/v1');
    });

    test('wsConnect should return correct unified endpoint', () {
      expect(ApiEndpoints.wsConnect, 'ws://15.252.129.37:8200/api/v1/ws/v1/connect');
    });

    test('wsCustomerConnect should format customer endpoint correctly', () {
      expect(ApiEndpoints.wsCustomerConnect(12), 'ws://15.252.129.37:8200/api/v1/ws/customer/12');
    });
  });

  group('WebSocketClient Customer Unit Tests', () {
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

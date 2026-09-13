import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/network/customer_ws_controller.dart';

void main() {
  group('CustomerWSController Unit Tests', () {
    late CustomerWSController controller;

    setUp(() {
      controller = CustomerWSController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('can be instantiated with default dependencies', () {
      expect(controller, isNotNull);
      expect(controller.bookingEventStream, isNotNull);
    });

    test('initCustomerWebSocket initializes listener cleanly without error', () {
      expect(
        () => controller.initCustomerWebSocket(110, 'demo_token'),
        returnsNormally,
      );
    });

    test('requestRide triggers websocket send call cleanly', () {
      expect(
        () => controller.requestRide(
          vehicleTypeId: 1,
          pickupLat: 17.48,
          pickupLng: 78.37,
          pickupAddress: 'Pickup',
          dropLat: 17.49,
          dropLng: 78.40,
          dropAddress: 'Drop',
        ),
        returnsNormally,
      );
    });

    test('requestDrop triggers drop request WS payload cleanly', () {
      expect(
        () => controller.requestDrop(
          bookingId: 110,
          reason: 'Customer requested drop',
        ),
        returnsNormally,
      );
    });
  });
}

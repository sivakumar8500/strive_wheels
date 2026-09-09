import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_user/core/services/active_booking_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late ActiveBookingService activeBookingService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    activeBookingService = ActiveBookingService(prefs);
  });

  group('ActiveBookingService Tests', () {
    test('Initial active booking state is null', () {
      expect(activeBookingService.hasActiveBooking, false);
      expect(activeBookingService.activeBooking, null);
    });

    test('setActiveBooking updates active booking and persists state', () async {
      const testData = ActiveBookingData(
        bookingId: 'ER-9921-X4B',
        driverName: 'Marcus Thorne',
        driverRating: 4.9,
        vehicleInfo: 'BMW i7 xDrive60 • 7396',
        pickupAddress: 'The Ritz-Carlton, Central Park',
        dropAddress: 'JFK International Airport',
        pickupLatLng: LatLng(17.4126, 78.3498),
        dropLatLng: LatLng(17.4435, 78.3772),
        totalAmount: '₹124.00',
        startOtp: '9886',
        status: 'RIDER_ACCEPTED',
      );

      await activeBookingService.setActiveBooking(testData);

      expect(activeBookingService.hasActiveBooking, true);
      expect(activeBookingService.activeBooking?.bookingId, 'ER-9921-X4B');
      expect(activeBookingService.activeBooking?.driverName, 'Marcus Thorne');
      expect(activeBookingService.activeBooking?.startOtp, '9886');

      // Verify persistence by initializing new service instance
      final newServiceInstance = ActiveBookingService(prefs);
      expect(newServiceInstance.hasActiveBooking, true);
      expect(newServiceInstance.activeBooking?.bookingId, 'ER-9921-X4B');
    });

    test('updateBookingStatus updates status field', () async {
      const testData = ActiveBookingData(
        bookingId: 'ER-9921-X4B',
        driverName: 'Marcus Thorne',
        driverRating: 4.9,
        vehicleInfo: 'BMW i7 xDrive60 • 7396',
        pickupAddress: 'The Ritz-Carlton',
        dropAddress: 'JFK Airport',
        pickupLatLng: LatLng(17.4126, 78.3498),
        dropLatLng: LatLng(17.4435, 78.3772),
        totalAmount: '₹124.00',
        status: 'RIDER_ACCEPTED',
      );

      await activeBookingService.setActiveBooking(testData);
      await activeBookingService.updateBookingStatus('TRIP_STARTED');

      expect(activeBookingService.activeBooking?.status, 'TRIP_STARTED');
    });

    test('clearActiveBooking removes active booking and clears storage', () async {
      const testData = ActiveBookingData(
        bookingId: 'ER-9921-X4B',
        driverName: 'Marcus Thorne',
        driverRating: 4.9,
        vehicleInfo: 'BMW i7 xDrive60 • 7396',
        pickupAddress: 'The Ritz-Carlton',
        dropAddress: 'JFK Airport',
        pickupLatLng: LatLng(17.4126, 78.3498),
        dropLatLng: LatLng(17.4435, 78.3772),
        totalAmount: '₹124.00',
      );

      await activeBookingService.setActiveBooking(testData);
      expect(activeBookingService.hasActiveBooking, true);

      await activeBookingService.clearActiveBooking();

      expect(activeBookingService.hasActiveBooking, false);
      expect(activeBookingService.activeBooking, null);

      final newServiceInstance = ActiveBookingService(prefs);
      expect(newServiceInstance.hasActiveBooking, false);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/core/utils/geo_utils.dart';

void main() {
  group('GeoUtils', () {
    test('maxRideSearchRadiusKm is exactly 5.0 km', () {
      expect(GeoUtils.maxRideSearchRadiusKm, 5.0);
      expect(GeoUtils.maxRideSearchRadiusMeters, 5000.0);
    });

    test('calculateDistanceKm returns 0 for identical coordinates', () {
      final dist = GeoUtils.calculateDistanceKm(
        lat1: 17.448292,
        lng1: 78.391485,
        lat2: 17.448292,
        lng2: 78.391485,
      );
      expect(dist, closeTo(0.0, 0.001));
    });

    test('calculateDistanceMeters returns accurate meter value', () {
      final distMeters = GeoUtils.calculateDistanceMeters(
        lat1: 17.448292,
        lng1: 78.391485,
        lat2: 17.448292,
        lng2: 78.391485,
      );
      expect(distMeters, closeTo(0.0, 0.1));
    });

    test('isWithin5KmRadius returns true for points within 5 km', () {
      // Coordinates approx 2 km apart in Hitec City, Hyderabad
      final within = GeoUtils.isWithin5KmRadius(
        riderLat: 17.448292,
        riderLng: 78.391485,
        pickupLat: 17.458292,
        pickupLng: 78.381485,
      );
      expect(within, isTrue);
    });

    test('isWithin5KmRadius returns false for points beyond 5 km', () {
      // Coordinates > 10 km apart (Hitec City to Secunderabad)
      final within = GeoUtils.isWithin5KmRadius(
        riderLat: 17.448292,
        riderLng: 78.391485,
        pickupLat: 17.500000,
        pickupLng: 78.550000,
      );
      expect(within, isFalse);
    });

    test('isWithin5KmRadius returns false if rider coordinates are 0.0, 0.0', () {
      final within = GeoUtils.isWithin5KmRadius(
        riderLat: 0.0,
        riderLng: 0.0,
        pickupLat: 17.448292,
        pickupLng: 78.391485,
      );
      expect(within, isFalse);
    });

    test('isWithin5KmRadius returns false if pickup coordinates are 0.0, 0.0', () {
      final within = GeoUtils.isWithin5KmRadius(
        riderLat: 17.448292,
        riderLng: 78.391485,
        pickupLat: 0.0,
        pickupLng: 0.0,
      );
      expect(within, isFalse);
    });
  });
}

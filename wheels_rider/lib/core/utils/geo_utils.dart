import 'dart:math';

/// Centralized utility for geolocation and distance calculations.
/// Enforces the strict 5 km ride radius policy.
class GeoUtils {
  /// Maximum search radius for ride dispatching and receiving in kilometers (5 km).
  static const double maxRideSearchRadiusKm = 5.0;

  /// Maximum search radius in meters (5,000 m).
  static const double maxRideSearchRadiusMeters = maxRideSearchRadiusKm * 1000.0;

  /// Mean Earth radius in kilometers.
  static const double earthRadiusKm = 6371.0;

  /// Calculates great-circle distance between two GPS coordinates in kilometers using Haversine formula.
  static double calculateDistanceKm({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// Calculates great-circle distance between two GPS coordinates in meters.
  static double calculateDistanceMeters({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    return calculateDistanceKm(
      lat1: lat1,
      lng1: lng1,
      lat2: lat2,
      lng2: lng2,
    ) * 1000.0;
  }

  /// Checks whether a pickup location is within the 5 km radius of the rider's position.
  /// Returns `false` if either position has default/invalid coordinates (0.0, 0.0).
  static bool isWithin5KmRadius({
    required double riderLat,
    required double riderLng,
    required double pickupLat,
    required double pickupLng,
    double maxRadiusKm = maxRideSearchRadiusKm,
  }) {
    if (riderLat == 0.0 && riderLng == 0.0) return false;
    if (pickupLat == 0.0 && pickupLng == 0.0) return false;

    final distanceKm = calculateDistanceKm(
      lat1: riderLat,
      lng1: riderLng,
      lat2: pickupLat,
      lng2: pickupLng,
    );
    return distanceKm <= maxRadiusKm;
  }

  static double _toRadians(double degree) {
    return degree * (pi / 180.0);
  }
}

import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum ManeuverType {
  straight,
  turnLeft,
  turnRight,
  slightLeft,
  slightRight,
  sharpLeft,
  sharpRight,
  uTurn,
  arrive,
  depart,
  unknown,
}

class NavigationStep {
  final String instruction;
  final String roadName;
  final double distanceMeters;
  final double durationSeconds;
  final ManeuverType maneuverType;
  final LatLng location;

  const NavigationStep({
    required this.instruction,
    required this.roadName,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.maneuverType,
    required this.location,
  });

  factory NavigationStep.fromOsrmJson(Map<String, dynamic> json) {
    final maneuver = json['maneuver'] as Map<String, dynamic>? ?? {};
    final typeStr = maneuver['type']?.toString().toLowerCase() ?? '';
    final modifierStr = maneuver['modifier']?.toString().toLowerCase() ?? '';
    final locationArr = maneuver['location'] as List<dynamic>? ?? [0.0, 0.0];

    final lng = locationArr.isNotEmpty ? (locationArr[0] as num).toDouble() : 0.0;
    final lat = locationArr.length > 1 ? (locationArr[1] as num).toDouble() : 0.0;
    final roadName = json['name']?.toString().trim() ?? '';
    final distance = (json['distance'] as num?)?.toDouble() ?? 0.0;
    final duration = (json['duration'] as num?)?.toDouble() ?? 0.0;

    ManeuverType maneuverType = ManeuverType.unknown;

    if (typeStr == 'depart') {
      maneuverType = ManeuverType.depart;
    } else if (typeStr == 'arrive') {
      maneuverType = ManeuverType.arrive;
    } else if (modifierStr.contains('uturn')) {
      maneuverType = ManeuverType.uTurn;
    } else if (modifierStr.contains('sharp left')) {
      maneuverType = ManeuverType.sharpLeft;
    } else if (modifierStr.contains('sharp right')) {
      maneuverType = ManeuverType.sharpRight;
    } else if (modifierStr.contains('slight left')) {
      maneuverType = ManeuverType.slightLeft;
    } else if (modifierStr.contains('slight right')) {
      maneuverType = ManeuverType.slightRight;
    } else if (modifierStr.contains('left')) {
      maneuverType = ManeuverType.turnLeft;
    } else if (modifierStr.contains('right')) {
      maneuverType = ManeuverType.turnRight;
    } else if (modifierStr.contains('straight')) {
      maneuverType = ManeuverType.straight;
    } else {
      maneuverType = ManeuverType.straight;
    }

    String instruction = _buildInstructionText(maneuverType, roadName);

    return NavigationStep(
      instruction: instruction,
      roadName: roadName.isEmpty ? 'Unnamed Road' : roadName,
      distanceMeters: distance,
      durationSeconds: duration,
      maneuverType: maneuverType,
      location: LatLng(lat, lng),
    );
  }

  static String _buildInstructionText(ManeuverType type, String roadName) {
    final road = roadName.isEmpty ? 'ahead' : 'onto $roadName';
    switch (type) {
      case ManeuverType.turnLeft:
        return 'Turn left $road';
      case ManeuverType.turnRight:
        return 'Turn right $road';
      case ManeuverType.slightLeft:
        return 'Keep left $road';
      case ManeuverType.slightRight:
        return 'Keep right $road';
      case ManeuverType.sharpLeft:
        return 'Sharp left $road';
      case ManeuverType.sharpRight:
        return 'Sharp right $road';
      case ManeuverType.uTurn:
        return 'Make a U-turn';
      case ManeuverType.depart:
        return 'Head towards destination';
      case ManeuverType.arrive:
        return 'You have arrived at your destination';
      case ManeuverType.straight:
      default:
        return 'Continue straight $road';
    }
  }
}

class RouteNavigationData {
  final List<LatLng> points;
  final List<NavigationStep> steps;
  final double totalDistanceMeters;
  final double totalDurationSeconds;

  const RouteNavigationData({
    required this.points,
    required this.steps,
    required this.totalDistanceMeters,
    required this.totalDurationSeconds,
  });

  bool get isEmpty => points.isEmpty;
}

class NavigationService {
  final Dio _dio;

  NavigationService({Dio? dio}) : _dio = dio ?? Dio();

  static const String _osrmBaseUrl = 'https://router.project-osrm.org/route/v1/driving';

  Future<RouteNavigationData> fetchRouteNavigation({
    required LatLng start,
    required LatLng destination,
  }) async {
    try {
      final url =
          '$_osrmBaseUrl/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?overview=full&geometries=geojson&steps=true';

      final response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map ? response.data as Map<String, dynamic> : {};
        final routes = data['routes'] as List<dynamic>?;
        if (routes != null && routes.isNotEmpty) {
          final firstRoute = routes.first as Map<String, dynamic>;
          final geometry = firstRoute['geometry'] as Map<String, dynamic>?;
          final coords = geometry?['coordinates'] as List<dynamic>?;

          final totalDistance = (firstRoute['distance'] as num?)?.toDouble() ?? 0.0;
          final totalDuration = (firstRoute['duration'] as num?)?.toDouble() ?? 0.0;

          List<LatLng> points = [];
          if (coords != null) {
            points = coords.map((c) {
              final lng = (c[0] as num).toDouble();
              final lat = (c[1] as num).toDouble();
              return LatLng(lat, lng);
            }).toList();
          }

          List<NavigationStep> steps = [];
          final legs = firstRoute['legs'] as List<dynamic>?;
          if (legs != null && legs.isNotEmpty) {
            final firstLeg = legs.first as Map<String, dynamic>;
            final rawSteps = firstLeg['steps'] as List<dynamic>?;
            if (rawSteps != null) {
              steps = rawSteps
                  .map((s) => NavigationStep.fromOsrmJson(s as Map<String, dynamic>))
                  .toList();
            }
          }

          return RouteNavigationData(
            points: points,
            steps: steps,
            totalDistanceMeters: totalDistance,
            totalDurationSeconds: totalDuration,
          );
        }
      }
    } catch (e) {
      debugPrint('[NavigationService] Route fetch error: $e');
    }

    return const RouteNavigationData(
      points: [],
      steps: [],
      totalDistanceMeters: 0,
      totalDurationSeconds: 0,
    );
  }

  NavigationStep? getCurrentStep(LatLng currentPos, List<NavigationStep> steps) {
    if (steps.isEmpty) return null;

    NavigationStep? closestStep;
    double minDistance = double.infinity;

    for (final step in steps) {
      final distance = calculateDistanceMeters(currentPos, step.location);
      if (distance < minDistance) {
        minDistance = distance;
        closestStep = step;
      }
    }

    return closestStep;
  }

  static double calculateDistanceMeters(LatLng p1, LatLng p2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((p2.latitude - p1.latitude) * p) / 2 +
        cos(p1.latitude * p) *
            cos(p2.latitude * p) *
            (1 - cos((p2.longitude - p1.longitude) * p)) /
            2;
    return 12742000 * asin(sqrt(a));
  }
}

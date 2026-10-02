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

class CorridorWaypointStop {
  final String id;
  final String label;
  final String address;
  final LatLng location;
  final String type; // 'pickup' | 'drop'
  final int sequence;
  final String? passengerName;

  const CorridorWaypointStop({
    required this.id,
    required this.label,
    required this.address,
    required this.location,
    required this.type,
    this.sequence = 0,
    this.passengerName,
  });

  CorridorWaypointStop copyWith({
    String? id,
    String? label,
    String? address,
    LatLng? location,
    String? type,
    int? sequence,
    String? passengerName,
  }) {
    return CorridorWaypointStop(
      id: id ?? this.id,
      label: label ?? this.label,
      address: address ?? this.address,
      location: location ?? this.location,
      type: type ?? this.type,
      sequence: sequence ?? this.sequence,
      passengerName: passengerName ?? this.passengerName,
    );
  }
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
            for (final leg in legs) {
              final rawSteps = (leg as Map<String, dynamic>)['steps'] as List<dynamic>?;
              if (rawSteps != null) {
                steps.addAll(
                  rawSteps.map((s) => NavigationStep.fromOsrmJson(s as Map<String, dynamic>)),
                );
              }
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

  /// Fetches real road-accurate turn-by-turn geometry points for multiple stops/waypoints from OSRM
  Future<RouteNavigationData> fetchMultiStopRouteNavigation({
    required List<LatLng> waypoints,
  }) async {
    if (waypoints.length < 2) {
      return const RouteNavigationData(
        points: [],
        steps: [],
        totalDistanceMeters: 0,
        totalDurationSeconds: 0,
      );
    }

    try {
      final coordsParam = waypoints
          .map((w) => '${w.longitude},${w.latitude}')
          .join(';');
      final url = '$_osrmBaseUrl/$coordsParam?overview=full&geometries=geojson&steps=true';

      final response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.json,
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
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
            for (final leg in legs) {
              final rawSteps = (leg as Map<String, dynamic>)['steps'] as List<dynamic>?;
              if (rawSteps != null) {
                steps.addAll(
                  rawSteps.map((s) => NavigationStep.fromOsrmJson(s as Map<String, dynamic>)),
                );
              }
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
      debugPrint('[NavigationService] Multi-stop route fetch error: $e');
    }

    return const RouteNavigationData(
      points: [],
      steps: [],
      totalDistanceMeters: 0,
      totalDurationSeconds: 0,
    );
  }

  /// Sequences multi-passenger corridor stops logically based on origin, pickups, drops, and company destination.
  List<CorridorWaypointStop> optimizeCorridorSequence({
    required List<CorridorWaypointStop> stops,
    LatLng? companyLocation,
    bool isEveningCommute = false,
  }) {
    if (stops.length <= 1) return stops;

    final pickups = stops.where((s) => s.type.toLowerCase() == 'pickup').toList();
    final drops = stops.where((s) => s.type.toLowerCase() == 'drop').toList();

    // Case 1: Commute to Destination (Pickups heading towards a company destination)
    if (drops.length <= 1 && pickups.isNotEmpty) {
      final destLocation = drops.isNotEmpty
          ? drops.first.location
          : (companyLocation ?? pickups.last.location);

      // Sort pickups descending by distance to destination:
      // Farthest pickup first (e.g. KPHB) -> Next (Nexus Mall) -> Nearest (Madhapur) -> Destination (Mindspace)
      pickups.sort((a, b) {
        final distA = calculateDistanceMeters(a.location, destLocation);
        final distB = calculateDistanceMeters(b.location, destLocation);
        return distB.compareTo(distA); // descending
      });

      final result = <CorridorWaypointStop>[...pickups, ...drops];
      for (int i = 0; i < result.length; i++) {
        result[i] = result[i].copyWith(sequence: i + 1);
      }
      return result;
    }

    // Case 2: Evening Commute (Single origin / company pickup with multiple drops)
    if (pickups.length <= 1 && drops.isNotEmpty && isEveningCommute) {
      final originLocation = pickups.isNotEmpty
          ? pickups.first.location
          : (companyLocation ?? drops.first.location);

      // Sort drops ascending by distance from origin:
      // Company Origin -> Nearest drop first (Madhapur) -> Next (Nexus Mall) -> Farthest drop (KPHB)
      drops.sort((a, b) {
        final distA = calculateDistanceMeters(originLocation, a.location);
        final distB = calculateDistanceMeters(originLocation, b.location);
        return distA.compareTo(distB); // ascending
      });

      final result = <CorridorWaypointStop>[...pickups, ...drops];
      for (int i = 0; i < result.length; i++) {
        result[i] = result[i].copyWith(sequence: i + 1);
      }
      return result;
    }

    // Case 3: Mixed Pickups and Drops (Greedy topological nearest neighbor)
    final unvisited = List<CorridorWaypointStop>.from(stops);
    final visited = <CorridorWaypointStop>[];
    final pickedUpIds = <String>{};

    CorridorWaypointStop current;
    if (companyLocation != null && pickups.isNotEmpty) {
      pickups.sort((a, b) => calculateDistanceMeters(b.location, companyLocation)
          .compareTo(calculateDistanceMeters(a.location, companyLocation)));
      current = pickups.first;
    } else {
      current = unvisited.first;
    }

    unvisited.remove(current);
    visited.add(current);
    if (current.type.toLowerCase() == 'pickup') {
      pickedUpIds.add(current.id);
    }

    while (unvisited.isNotEmpty) {
      final candidates = unvisited.where((s) {
        if (s.type.toLowerCase() == 'pickup') return true;
        return pickedUpIds.contains(s.id) || !stops.any((x) => x.id == s.id && x.type.toLowerCase() == 'pickup');
      }).toList();

      if (candidates.isEmpty) {
        candidates.addAll(unvisited);
      }

      candidates.sort((a, b) {
        final distA = calculateDistanceMeters(current.location, a.location);
        final distB = calculateDistanceMeters(current.location, b.location);
        return distA.compareTo(distB);
      });

      final next = candidates.first;
      unvisited.remove(next);
      visited.add(next);
      if (next.type.toLowerCase() == 'pickup') {
        pickedUpIds.add(next.id);
      }
      current = next;
    }

    for (int i = 0; i < visited.length; i++) {
      visited[i] = visited[i].copyWith(sequence: i + 1);
    }
    return visited;
  }

  /// Calculates nearest upcoming navigation step based on current vehicle location
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

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../network/api_constants.dart';

enum WeatherCondition {
  clear(1.0, 'Clear'),
  cloudy(1.0, 'Cloudy'),
  lightRain(1.1, 'Light Rain'),
  moderateRain(1.2, 'Moderate Rain'),
  heavyRain(1.4, 'Heavy Rain');

  final double multiplier;
  final String label;
  const WeatherCondition(this.multiplier, this.label);

  String get apiKey => switch (this) {
        WeatherCondition.clear => 'CLEAR',
        WeatherCondition.cloudy => 'CLOUDY',
        WeatherCondition.lightRain => 'LIGHT_RAIN',
        WeatherCondition.moderateRain => 'MODERATE_RAIN',
        WeatherCondition.heavyRain => 'HEAVY_RAIN',
      };
}

enum TrafficLevel {
  low(1.0, 'Low'),
  medium(1.1, 'Medium'),
  high(1.25, 'High'),
  veryHigh(1.5, 'Very High');

  final double multiplier;
  final String label;
  const TrafficLevel(this.multiplier, this.label);

  String get apiKey => switch (this) {
        TrafficLevel.low => 'LOW',
        TrafficLevel.medium => 'MEDIUM',
        TrafficLevel.high => 'HIGH',
        TrafficLevel.veryHigh => 'VERY_HIGH',
      };
}

class RouteConditionResult {
  final WeatherCondition weather;
  final TrafficLevel traffic;
  final double delayRatio;
  final String rawWeatherDescription;

  const RouteConditionResult({
    required this.weather,
    required this.traffic,
    required this.delayRatio,
    required this.rawWeatherDescription,
  });

  double get weatherMultiplier => weather.multiplier;
  double get trafficMultiplier => traffic.multiplier;
  double get totalSurgeMultiplier =>
      double.parse((weatherMultiplier * trafficMultiplier).toStringAsFixed(2));

  Map<String, dynamic> toJson() => {
        'weather': weather.label,
        'weather_multiplier': weatherMultiplier,
        'traffic_level': traffic.label,
        'traffic_multiplier': trafficMultiplier,
        'total_surge_multiplier': totalSurgeMultiplier,
        'delay_ratio': delayRatio.toStringAsFixed(2),
        'weather_description': rawWeatherDescription,
      };
}

class RouteConditionService {
  final Dio _dio;

  RouteConditionService({Dio? dio}) : _dio = dio ?? Dio();

  /// Fetches traffic from Google Routes API (v2) and weather from Weather API,
  /// then classifies both into multipliers according to specification.
  Future<RouteConditionResult> analyzeRouteConditions({
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
  }) async {
    final trafficFuture = _fetchTrafficLevel(pickupLat, pickupLng, dropLat, dropLng);
    final weatherFuture = _fetchWeatherCondition((pickupLat + dropLat) / 2, (pickupLng + dropLng) / 2);

    final results = await Future.wait([trafficFuture, weatherFuture]);
    final trafficData = results[0] as _TrafficData;
    final weatherData = results[1] as _WeatherData;

    return RouteConditionResult(
      weather: weatherData.condition,
      traffic: trafficData.level,
      delayRatio: trafficData.delayRatio,
      rawWeatherDescription: weatherData.description,
    );
  }

  /// Query Google Routes API with TRAFFIC_ON_POLYLINE
  Future<_TrafficData> _fetchTrafficLevel(
    double pickupLat,
    double pickupLng,
    double dropLat,
    double dropLng,
  ) async {
    try {
      final response = await _dio.post(
        'https://routes.googleapis.com/directions/v2:computeRoutes',
        data: {
          'origin': {
            'location': {
              'latLng': {'latitude': pickupLat, 'longitude': pickupLng}
            }
          },
          'destination': {
            'location': {
              'latLng': {'latitude': dropLat, 'longitude': dropLng}
            }
          },
          'travelMode': 'DRIVE',
          'routingPreference': 'TRAFFIC_AWARE_OPTIMAL',
          'extraComputations': ['TRAFFIC_ON_POLYLINE'],
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': ApiConstants.googleMapsApiKey,
            'X-Goog-FieldMask':
                'routes.duration,routes.staticDuration,routes.travelAdvisory.speedReadingIntervals',
          },
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map ? response.data : {};
        final routes = data['routes'] as List?;
        if (routes != null && routes.isNotEmpty) {
          final route = routes[0];
          final durationStr = (route['duration'] as String?) ?? '0s';
          final staticDurationStr = (route['staticDuration'] as String?) ?? '0s';

          final durationSec = int.tryParse(durationStr.replaceAll('s', '')) ?? 0;
          final staticDurationSec = int.tryParse(staticDurationStr.replaceAll('s', '')) ?? 1;

          final delayRatio = staticDurationSec > 0 ? durationSec / staticDurationSec : 1.0;

          final speedIntervals = (route['travelAdvisory']?['speedReadingIntervals'] as List?) ?? [];
          int jamCount = 0;
          int slowCount = 0;

          for (final interval in speedIntervals) {
            final speed = interval['speed'] as String?;
            if (speed == 'TRAFFIC_JAM') jamCount++;
            if (speed == 'SLOW') slowCount++;
          }

          TrafficLevel level;
          if (delayRatio > 1.80 || (jamCount >= 3 && delayRatio > 1.5)) {
            level = TrafficLevel.veryHigh;
          } else if (delayRatio > 1.45 || jamCount > 0) {
            level = TrafficLevel.high;
          } else if (delayRatio > 1.15 || slowCount > 0) {
            level = TrafficLevel.medium;
          } else {
            level = TrafficLevel.low;
          }

          return _TrafficData(level: level, delayRatio: delayRatio);
        }
      }
    } catch (e) {
      debugPrint('Error fetching traffic level: $e');
    }

    return const _TrafficData(level: TrafficLevel.low, delayRatio: 1.0);
  }

  /// Query Weather API to determine precise precipitation & weather condition
  Future<_WeatherData> _fetchWeatherCondition(double lat, double lng) async {
    try {
      final response = await _dio.get(
        'https://api.open-meteo.com/v1/forecast',
        queryParameters: {
          'latitude': lat,
          'longitude': lng,
          'current_weather': true,
          'hourly': 'precipitation,rain,showers',
        },
        options: Options(
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map ? response.data : {};
        final currentWeather = data['current_weather'] as Map?;
        final weatherCode = (currentWeather?['weathercode'] as num?)?.toInt() ?? 0;

        final hourlyRain = (data['hourly']?['rain'] as List?) ?? [];
        final rainMm = (hourlyRain.isNotEmpty && hourlyRain[0] is num)
            ? (hourlyRain[0] as num).toDouble()
            : 0.0;

        WeatherCondition condition;
        String desc = 'Clear';

        if (weatherCode >= 95 || weatherCode == 65 || weatherCode == 82 || rainMm >= 7.5) {
          condition = WeatherCondition.heavyRain;
          desc = 'Heavy Rain / Thunderstorm';
        } else if (weatherCode == 63 || weatherCode == 81 || (rainMm >= 2.5 && rainMm < 7.5)) {
          condition = WeatherCondition.moderateRain;
          desc = 'Moderate Rain';
        } else if ((weatherCode >= 51 && weatherCode <= 61) || weatherCode == 80 || (rainMm > 0.0 && rainMm < 2.5)) {
          condition = WeatherCondition.lightRain;
          desc = 'Light Rain / Drizzle';
        } else if (weatherCode >= 1 && weatherCode <= 3) {
          condition = WeatherCondition.cloudy;
          desc = 'Cloudy / Partly Cloudy';
        } else {
          condition = WeatherCondition.clear;
          desc = 'Clear';
        }

        return _WeatherData(condition: condition, description: desc);
      }
    } catch (e) {
      debugPrint('Error fetching weather condition: $e');
    }

    return const _WeatherData(condition: WeatherCondition.clear, description: 'Clear');
  }
}

class _TrafficData {
  final TrafficLevel level;
  final double delayRatio;
  const _TrafficData({required this.level, required this.delayRatio});
}

class _WeatherData {
  final WeatherCondition condition;
  final String description;
  const _WeatherData({required this.condition, required this.description});
}

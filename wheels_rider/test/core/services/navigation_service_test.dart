import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/services/navigation_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late NavigationService navigationService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    navigationService = NavigationService(dio: mockDio);
  });

  group('NavigationStep Tests', () {
    test('NavigationStep.fromOsrmJson parses turn left step correctly', () {
      final json = {
        'maneuver': {
          'type': 'turn',
          'modifier': 'left',
          'location': [78.3498, 17.4126],
        },
        'name': 'Hitech City Main Rd',
        'distance': 250.0,
        'duration': 45.0,
      };

      final step = NavigationStep.fromOsrmJson(json);

      expect(step.maneuverType, equals(ManeuverType.turnLeft));
      expect(step.roadName, equals('Hitech City Main Rd'));
      expect(step.distanceMeters, equals(250.0));
      expect(step.durationSeconds, equals(45.0));
      expect(step.location, equals(const LatLng(17.4126, 78.3498)));
      expect(step.instruction, contains('Turn left onto Hitech City Main Rd'));
    });

    test('NavigationStep.fromOsrmJson parses u-turn step correctly', () {
      final json = {
        'maneuver': {
          'type': 'turn',
          'modifier': 'uturn',
          'location': [78.3500, 17.4130],
        },
        'name': '',
        'distance': 100.0,
        'duration': 20.0,
      };

      final step = NavigationStep.fromOsrmJson(json);

      expect(step.maneuverType, equals(ManeuverType.uTurn));
      expect(step.roadName, equals('Unnamed Road'));
      expect(step.instruction, equals('Make a U-turn'));
    });
  });

  group('NavigationService API Tests', () {
    test('fetchRouteNavigation returns empty RouteNavigationData on API error', () async {
      when(() => mockDio.get(
            any(),
            options: any(named: 'options'),
          )).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      final result = await navigationService.fetchRouteNavigation(
        start: const LatLng(17.4126, 78.3498),
        destination: const LatLng(17.4435, 78.3772),
      );

      expect(result.isEmpty, isTrue);
      expect(result.points, isEmpty);
      expect(result.steps, isEmpty);
    });

    test('fetchRouteNavigation parses valid OSRM JSON response', () async {
      final osrmResponse = {
        'routes': [
          {
            'distance': 5000.0,
            'duration': 600.0,
            'geometry': {
              'coordinates': [
                [78.3498, 17.4126],
                [78.3772, 17.4435],
              ],
            },
            'legs': [
              {
                'steps': [
                  {
                    'maneuver': {
                      'type': 'depart',
                      'modifier': 'right',
                      'location': [78.3498, 17.4126],
                    },
                    'name': 'Start St',
                    'distance': 500.0,
                    'duration': 60.0,
                  }
                ]
              }
            ]
          }
        ]
      };

      when(() => mockDio.get(
            any(),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response(
          data: osrmResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await navigationService.fetchRouteNavigation(
        start: const LatLng(17.4126, 78.3498),
        destination: const LatLng(17.4435, 78.3772),
      );

      expect(result.isEmpty, isFalse);
      expect(result.points.length, equals(2));
      expect(result.steps.length, equals(1));
      expect(result.totalDistanceMeters, equals(5000.0));
      expect(result.totalDurationSeconds, equals(600.0));
    });

    test('getCurrentStep returns closest step from list', () {
      final steps = [
        const NavigationStep(
          instruction: 'Step 1',
          roadName: 'Road 1',
          distanceMeters: 100,
          durationSeconds: 10,
          maneuverType: ManeuverType.straight,
          location: LatLng(17.4126, 78.3498),
        ),
        const NavigationStep(
          instruction: 'Step 2',
          roadName: 'Road 2',
          distanceMeters: 200,
          durationSeconds: 20,
          maneuverType: ManeuverType.turnLeft,
          location: LatLng(17.4200, 78.3500),
        ),
      ];

      final currentPos = const LatLng(17.4127, 78.3499);
      final closest = navigationService.getCurrentStep(currentPos, steps);

      expect(closest, isNotNull);
      expect(closest!.instruction, equals('Step 1'));
    });
  });
}

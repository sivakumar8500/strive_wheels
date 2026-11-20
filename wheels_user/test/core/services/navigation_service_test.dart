import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/core/services/navigation_service.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late NavigationService navigationService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    navigationService = NavigationService(dio: mockDio);
  });

  group('NavigationService Customer Tests', () {
    test('NavigationStep.fromOsrmJson parses straight step correctly', () {
      final json = {
        'maneuver': {
          'type': 'turn',
          'modifier': 'straight',
          'location': [78.3772, 17.4435],
        },
        'name': 'Gachibowli Main Rd',
        'distance': 500.0,
        'duration': 60.0,
      };

      final step = NavigationStep.fromOsrmJson(json);

      expect(step.maneuverType, equals(ManeuverType.straight));
      expect(step.roadName, equals('Gachibowli Main Rd'));
      expect(step.instruction, contains('Continue straight onto Gachibowli Main Rd'));
    });

    test('fetchRouteNavigation handles empty routes gracefully', () async {
      when(() => mockDio.get(
            any(),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response(
          data: {'routes': []},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await navigationService.fetchRouteNavigation(
        start: const LatLng(17.4126, 78.3498),
        destination: const LatLng(17.4435, 78.3772),
      );

      expect(result.isEmpty, isTrue);
    });

    test('optimizeCorridorSequence orders pickups descending by distance to company destination (Morning Commute)', () {
      // Person A: KPHB (farthest from Mindspace ~ 17.4938, 78.3995)
      // Person B: Nexus Mall (intermediate ~ 17.4830, 78.3880)
      // Person C: Madhapur (nearest to Mindspace ~ 17.4480, 78.3850)
      // Destination: Mindspace (17.4400, 78.3800)
      const mindspace = LatLng(17.4400, 78.3800);
      const kphb = LatLng(17.4938, 78.3995);
      const nexusMall = LatLng(17.4830, 78.3880);
      const madhapur = LatLng(17.4480, 78.3850);

      final stops = [
        const CorridorWaypointStop(
          id: 'person_c',
          label: 'Person C (Madhapur)',
          address: 'Madhapur',
          location: madhapur,
          type: 'pickup',
          passengerName: 'Person C',
        ),
        const CorridorWaypointStop(
          id: 'person_a',
          label: 'Person A (KPHB)',
          address: 'KPHB Colony',
          location: kphb,
          type: 'pickup',
          passengerName: 'Person A',
        ),
        const CorridorWaypointStop(
          id: 'person_b',
          label: 'Person B (Nexus Mall)',
          address: 'Nexus Mall',
          location: nexusMall,
          type: 'pickup',
          passengerName: 'Person B',
        ),
        const CorridorWaypointStop(
          id: 'company_drop',
          label: 'Mindspace (Company Drop)',
          address: 'Mindspace Tech Park',
          location: mindspace,
          type: 'drop',
          passengerName: 'Company Destination',
        ),
      ];

      final sequenced = navigationService.optimizeCorridorSequence(
        stops: stops,
        companyLocation: mindspace,
      );

      expect(sequenced.length, equals(4));
      // First stop: Person A (KPHB - farthest from Mindspace)
      expect(sequenced[0].id, equals('person_a'));
      expect(sequenced[0].sequence, equals(1));

      // Second stop: Person B (Nexus Mall - intermediate)
      expect(sequenced[1].id, equals('person_b'));
      expect(sequenced[1].sequence, equals(2));

      // Third stop: Person C (Madhapur - nearest to Mindspace)
      expect(sequenced[2].id, equals('person_c'));
      expect(sequenced[2].sequence, equals(3));

      // Final stop: Company Drop (Mindspace)
      expect(sequenced[3].id, equals('company_drop'));
      expect(sequenced[3].sequence, equals(4));
    });

    test('fetchMultiStopRouteNavigation parses multi-leg route and steps correctly', () async {
      when(() => mockDio.get(
            any(),
            options: any(named: 'options'),
          )).thenAnswer(
        (_) async => Response(
          data: {
            'routes': [
              {
                'distance': 12500.0,
                'duration': 1500.0,
                'geometry': {
                  'coordinates': [
                    [78.3995, 17.4938],
                    [78.3880, 17.4830],
                    [78.3850, 17.4480],
                    [78.3800, 17.4400],
                  ],
                },
                'legs': [
                  {
                    'steps': [
                      {
                        'maneuver': {'type': 'depart', 'location': [78.3995, 17.4938]},
                        'name': 'KPHB Main Rd',
                        'distance': 2500.0,
                        'duration': 300.0,
                      }
                    ]
                  },
                  {
                    'steps': [
                      {
                        'maneuver': {'type': 'arrive', 'location': [78.3800, 17.4400]},
                        'name': 'Mindspace Rd',
                        'distance': 1000.0,
                        'duration': 120.0,
                      }
                    ]
                  }
                ]
              }
            ]
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await navigationService.fetchMultiStopRouteNavigation(
        waypoints: const [
          LatLng(17.4938, 78.3995),
          LatLng(17.4830, 78.3880),
          LatLng(17.4480, 78.3850),
          LatLng(17.4400, 78.3800),
        ],
      );

      expect(result.isEmpty, isFalse);
      expect(result.points.length, equals(4));
      expect(result.totalDistanceMeters, equals(12500.0));
      expect(result.totalDurationSeconds, equals(1500.0));
      expect(result.steps.length, equals(2));
    });
  });
}

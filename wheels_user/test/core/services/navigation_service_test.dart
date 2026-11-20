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
  });
}

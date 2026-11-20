import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/core/services/live_journey_notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LiveJourneyNotificationServiceImpl service;
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();
    const MethodChannel testChannel = MethodChannel('com.strivewheels/journey_notification');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(testChannel, (MethodCall methodCall) async {
      log.add(methodCall);
      return null;
    });

    service = const LiveJourneyNotificationServiceImpl(channel: testChannel);
  });

  group('buildCarProgressTrack', () {
    test('places car at start for 0.0 progress', () {
      final track = LiveJourneyNotificationServiceImpl.buildCarProgressTrack(
        progressPercent: 0.0,
        totalSlots: 8,
      );
      expect(track.startsWith('🚗'), isTrue);
      expect(track.contains('─'), isTrue);
    });

    test('places car near end for 1.0 progress', () {
      final track = LiveJourneyNotificationServiceImpl.buildCarProgressTrack(
        progressPercent: 1.0,
        totalSlots: 8,
      );
      expect(track.endsWith('🚗'), isTrue);
      expect(track.contains('━'), isTrue);
    });

    test('places car in the middle for 0.5 progress', () {
      final track = LiveJourneyNotificationServiceImpl.buildCarProgressTrack(
        progressPercent: 0.5,
        totalSlots: 8,
      );
      expect(track.contains('🚗'), isTrue);
      expect(track.contains('━'), isTrue);
      expect(track.contains('─'), isTrue);
    });
  });

  group('showJourneyNotification', () {
    test('invokes native channel with formatted arguments and progress track', () async {
      await service.showJourneyNotification(
        title: 'Driving to Drop • 8 min',
        pickupLocation: 'Banjara Hills Rd 1',
        dropLocation: 'Hitec City Cyber Towers',
        progressPercent: 0.60,
        subText: 'Passenger: Alice',
        remainingMins: 8,
      );

      expect(log.length, 1);
      expect(log.first.method, 'showJourneyNotification');
      final args = log.first.arguments as Map<dynamic, dynamic>;
      expect(args['title'], 'Driving to Drop • 8 min');
      expect(args['body'], contains('Banjara Hills Rd 1'));
      expect(args['body'], contains('Hitec City Cyber Towers'));
      expect(args['body'], contains('🚗'));
      expect(args['progress'], 60);
      expect(args['subText'], 'Passenger: Alice');
    });
  });

  group('dismissJourneyNotification', () {
    test('invokes dismissJourneyNotification on method channel', () async {
      await service.dismissJourneyNotification();

      expect(log.length, 1);
      expect(log.first.method, 'dismissJourneyNotification');
    });
  });
}

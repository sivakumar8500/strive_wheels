import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/services/live_journey_notification_service.dart';

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
        title: 'Driver arriving • 12 min',
        pickupLocation: '245 Market St, San Francisco',
        dropLocation: 'SFO International Airport',
        progressPercent: 0.45,
        subText: 'T 4032',
        remainingMins: 12,
      );

      expect(log.length, 1);
      expect(log.first.method, 'showJourneyNotification');
      final args = log.first.arguments as Map<dynamic, dynamic>;
      expect(args['title'], 'Driver arriving • 12 min');
      expect(args['body'], contains('245 Market St'));
      expect(args['body'], contains('SFO International Airport'));
      expect(args['body'], contains('🚗'));
      expect(args['progress'], 45);
      expect(args['subText'], 'T 4032');
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

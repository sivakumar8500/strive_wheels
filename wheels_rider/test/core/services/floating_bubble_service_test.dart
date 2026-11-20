import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/core/services/floating_bubble_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FloatingBubbleServiceImpl service;
  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    log.clear();
    const MethodChannel testChannel = MethodChannel('com.strivewheels/floating_bubble');

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(testChannel, (MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'checkPermission':
          return true;
        case 'isBubbleShowing':
          return true;
        case 'requestPermission':
        case 'showBubble':
        case 'hideBubble':
          return true;
        default:
          return null;
      }
    });

    service = const FloatingBubbleServiceImpl(channel: testChannel);
  });

  group('FloatingBubbleService Tests', () {
    test('checkPermission returns result from native channel on Android', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final result = await service.checkPermission();
      expect(result, isTrue);
      expect(log.any((call) => call.method == 'checkPermission'), isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    test('checkPermission returns false on non-Android platform', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final result = await service.checkPermission();
      expect(result, isFalse);
      debugDefaultTargetPlatformOverride = null;
    });

    test('requestPermission invokes native channel on Android', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await service.requestPermission();
      expect(log.any((call) => call.method == 'requestPermission'), isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    test('showBubble sends default arguments when none provided', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await service.showBubble();
      final call = log.firstWhere((c) => c.method == 'showBubble');
      expect(call.arguments['title'], 'STRIVE');
      expect(call.arguments['subText'], 'CAPTAIN');
      debugDefaultTargetPlatformOverride = null;
    });

    test('showBubble sends custom title and subText when provided', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await service.showBubble(title: 'STRIVE RIDER', subText: 'IN RIDE');
      final call = log.firstWhere((c) => c.method == 'showBubble');
      expect(call.arguments['title'], 'STRIVE RIDER');
      expect(call.arguments['subText'], 'IN RIDE');
      debugDefaultTargetPlatformOverride = null;
    });

    test('hideBubble invokes native hideBubble method', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await service.hideBubble();
      expect(log.any((call) => call.method == 'hideBubble'), isTrue);
      debugDefaultTargetPlatformOverride = null;
    });

    test('isBubbleShowing returns boolean result from channel', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      final showing = await service.isBubbleShowing();
      expect(showing, isTrue);
      expect(log.any((call) => call.method == 'isBubbleShowing'), isTrue);
      debugDefaultTargetPlatformOverride = null;
    });
  });
}

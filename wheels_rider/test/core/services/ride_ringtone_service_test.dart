import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/core/services/ride_ringtone_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RideRingtoneService Tests', () {
    late RideRingtoneService ringtoneService;

    setUp(() {
      ringtoneService = RideRingtoneServiceImpl();
    });

    tearDown(() async {
      await ringtoneService.stopCallingRingtone();
    });

    test('should initialize with isPlaying false', () {
      expect(ringtoneService.isPlaying, isFalse);
    });

    test('stopCallingRingtone should ensure isPlaying is false without throwing', () async {
      await ringtoneService.stopCallingRingtone();
      expect(ringtoneService.isPlaying, isFalse);
    });

    test('dispose should safely reset player and state', () async {
      await ringtoneService.dispose();
      expect(ringtoneService.isPlaying, isFalse);
    });
  });
}

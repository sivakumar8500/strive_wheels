import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class LiveJourneyNotificationService {
  Future<void> showJourneyNotification({
    required String title,
    required String pickupLocation,
    required String dropLocation,
    required double progressPercent,
    String? subText,
    int? remainingMins,
  });

  Future<void> dismissJourneyNotification();
}

class LiveJourneyNotificationServiceImpl implements LiveJourneyNotificationService {
  final MethodChannel channel;

  const LiveJourneyNotificationServiceImpl({
    this.channel = const MethodChannel('com.strivewheels/journey_notification'),
  });

  /// Builds a visual car progress line connecting start and drop locations
  /// E.g. ━━🚗──────
  static String buildCarProgressTrack({
    required double progressPercent,
    int totalSlots = 8,
  }) {
    final clamped = progressPercent.clamp(0.0, 1.0);
    final carPos = (clamped * (totalSlots - 1)).round();
    final buffer = StringBuffer();
    for (int i = 0; i < totalSlots; i++) {
      if (i == carPos) {
        buffer.write('🚗');
      } else if (i < carPos) {
        buffer.write('━');
      } else {
        buffer.write('─');
      }
    }
    return buffer.toString();
  }

  static String _shortenLocation(String location) {
    if (location.isEmpty) return '';
    final parts = location.split(',');
    return parts.first.trim();
  }

  @override
  Future<void> showJourneyNotification({
    required String title,
    required String pickupLocation,
    required String dropLocation,
    required double progressPercent,
    String? subText,
    int? remainingMins,
  }) async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        try {
          final status = await Permission.notification.status;
          if (!status.isGranted) {
            await Permission.notification.request();
          }
        } catch (e) {
          debugPrint('[LiveJourneyNotificationService] Notification permission check: $e');
        }
      }

      final startShort = _shortenLocation(pickupLocation);
      final dropShort = _shortenLocation(dropLocation);
      final track = buildCarProgressTrack(progressPercent: progressPercent);
      final percentInt = (progressPercent.clamp(0.0, 1.0) * 100).round();

      final body = '$startShort $track $dropShort ($percentInt%)';

      String effectiveTitle = title;
      if (remainingMins != null && remainingMins > 0 && !effectiveTitle.contains('min')) {
        effectiveTitle = '$title • $remainingMins min';
      }

      await channel.invokeMethod('showJourneyNotification', {
        'title': effectiveTitle,
        'body': body,
        'subText': subText ?? 'Strive Wheels',
        'progress': percentInt,
        'maxProgress': 100,
      });
    } catch (e) {
      debugPrint('[LiveJourneyNotificationService] Error showing notification: $e');
    }
  }

  @override
  Future<void> dismissJourneyNotification() async {
    try {
      await channel.invokeMethod('dismissJourneyNotification');
    } catch (e) {
      debugPrint('[LiveJourneyNotificationService] Error dismissing notification: $e');
    }
  }
}

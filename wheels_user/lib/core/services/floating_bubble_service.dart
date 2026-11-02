import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract class FloatingBubbleService {
  /// Returns whether the system overlay ('Display over other apps') permission is granted.
  Future<bool> checkPermission();

  /// Prompts or directs the user to Android Settings to enable overlay permission.
  Future<void> requestPermission();

  /// Displays the floating screen bubble docked to the screen edge.
  Future<void> showBubble({
    String? title,
    String? subText,
  });

  /// Hides and dismisses the floating screen bubble.
  Future<void> hideBubble();

  /// Returns whether the floating bubble is currently active.
  Future<bool> isBubbleShowing();
}

class FloatingBubbleServiceImpl implements FloatingBubbleService {
  final MethodChannel channel;

  const FloatingBubbleServiceImpl({
    this.channel = const MethodChannel('com.strivewheels/floating_bubble'),
  });

  @override
  Future<bool> checkPermission() async {
    try {
      if (defaultTargetPlatform != TargetPlatform.android) return false;
      final result = await channel.invokeMethod<bool>('checkPermission');
      return result ?? false;
    } catch (e) {
      debugPrint('[FloatingBubbleService] Error checking permission: $e');
      return false;
    }
  }

  @override
  Future<void> requestPermission() async {
    try {
      if (defaultTargetPlatform != TargetPlatform.android) return;
      await channel.invokeMethod('requestPermission');
    } catch (e) {
      debugPrint('[FloatingBubbleService] Error requesting permission: $e');
    }
  }

  @override
  Future<void> showBubble({
    String? title,
    String? subText,
  }) async {
    try {
      if (defaultTargetPlatform != TargetPlatform.android) return;
      await channel.invokeMethod('showBubble', {
        'title': title ?? 'STRIVE',
        'subText': subText ?? 'WHEELS',
      });
    } catch (e) {
      debugPrint('[FloatingBubbleService] Error showing bubble: $e');
    }
  }

  @override
  Future<void> hideBubble() async {
    try {
      if (defaultTargetPlatform != TargetPlatform.android) return;
      await channel.invokeMethod('hideBubble');
    } catch (e) {
      debugPrint('[FloatingBubbleService] Error hiding bubble: $e');
    }
  }

  @override
  Future<bool> isBubbleShowing() async {
    try {
      if (defaultTargetPlatform != TargetPlatform.android) return false;
      final result = await channel.invokeMethod<bool>('isBubbleShowing');
      return result ?? false;
    } catch (e) {
      debugPrint('[FloatingBubbleService] Error checking bubble status: $e');
      return false;
    }
  }
}

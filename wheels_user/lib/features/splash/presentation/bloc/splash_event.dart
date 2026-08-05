import 'package:flutter/foundation.dart';

@immutable
abstract class SplashEvent {
  const SplashEvent();
}

class StartSplashEvent extends SplashEvent {
  const StartSplashEvent();
}

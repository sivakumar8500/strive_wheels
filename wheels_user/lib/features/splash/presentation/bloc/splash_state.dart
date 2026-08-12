import 'package:flutter/foundation.dart';

@immutable
abstract class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashLoading extends SplashState {
  const SplashLoading();
}

class SplashCompleted extends SplashState {
  final bool isFirstTime;

  const SplashCompleted({required this.isFirstTime});
}

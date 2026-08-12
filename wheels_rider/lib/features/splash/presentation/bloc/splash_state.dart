import 'package:flutter/foundation.dart';

@immutable
abstract class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashCompleted extends SplashState {
  final bool isAuthenticated;
  final bool isFirstTime;

  const SplashCompleted({
    required this.isAuthenticated,
    required this.isFirstTime,
  });
}

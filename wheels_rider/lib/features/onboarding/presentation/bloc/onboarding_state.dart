import 'package:flutter/foundation.dart';
import '../../domain/entities/onboarding_item.dart';

@immutable
abstract class OnboardingState {
  const OnboardingState();
}

class OnboardingInitialState extends OnboardingState {}

class OnboardingLoadingState extends OnboardingState {}

class OnboardingLoadedState extends OnboardingState {
  final List<OnboardingItem> items;
  final int currentPageIndex;

  const OnboardingLoadedState({
    required this.items,
    required this.currentPageIndex,
  });

  OnboardingLoadedState copyWith({
    List<OnboardingItem>? items,
    int? currentPageIndex,
  }) {
    return OnboardingLoadedState(
      items: items ?? this.items,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}

class OnboardingCompletedState extends OnboardingState {}

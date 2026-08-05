import '../../domain/entities/onboarding_item.dart';

abstract class OnboardingState {
  const OnboardingState();
}

class OnboardingInitialState extends OnboardingState {
  const OnboardingInitialState();
}

class OnboardingLoadingState extends OnboardingState {
  const OnboardingLoadingState();
}

class OnboardingLoadedState extends OnboardingState {
  final List<OnboardingItem> items;
  final int currentPageIndex;
  final bool isFirstTime;

  const OnboardingLoadedState({
    required this.items,
    required this.currentPageIndex,
    required this.isFirstTime,
  });

  OnboardingLoadedState copyWith({
    List<OnboardingItem>? items,
    int? currentPageIndex,
    bool? isFirstTime,
  }) {
    return OnboardingLoadedState(
      items: items ?? this.items,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }
}

class OnboardingCompletedState extends OnboardingState {
  const OnboardingCompletedState();
}

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/complete_onboarding.dart';
import '../../domain/usecases/get_onboarding_items.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingItems getOnboardingItems;
  final CompleteOnboarding completeOnboarding;

  OnboardingBloc({
    required this.getOnboardingItems,
    required this.completeOnboarding,
  }) : super(OnboardingInitialState()) {
    on<CheckFirstTimeEvent>(_onCheckFirstTime);
    on<OnboardingPageChangedEvent>(_onPageChanged);
    on<NextOnboardingPageEvent>(_onNextPage);
  }

  void _onCheckFirstTime(
    CheckFirstTimeEvent event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingLoadingState());
    final items = getOnboardingItems();
    emit(OnboardingLoadedState(items: items, currentPageIndex: 0));
  }

  void _onPageChanged(
    OnboardingPageChangedEvent event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoadedState) {
      final currentState = state as OnboardingLoadedState;
      emit(currentState.copyWith(currentPageIndex: event.pageIndex));
    }
  }

  Future<void> _onNextPage(
    NextOnboardingPageEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingLoadedState) {
      final currentState = state as OnboardingLoadedState;
      final nextIndex = currentState.currentPageIndex + 1;
      if (nextIndex < currentState.items.length) {
        emit(currentState.copyWith(currentPageIndex: nextIndex));
      } else {
        await completeOnboarding();
        emit(OnboardingCompletedState());
      }
    }
  }
}

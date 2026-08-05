import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/onboarding_item.dart';
import '../../domain/usecases/check_first_time_usecase.dart';
import '../../domain/usecases/complete_onboarding_usecase.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CheckFirstTimeUseCase checkFirstTimeUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;

  static const List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
      imagePath: AppAssets.onboarding1,
    ),
    OnboardingItem(
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
      imagePath: AppAssets.onboarding2,
    ),
  ];

  OnboardingBloc({
    required this.checkFirstTimeUseCase,
    required this.completeOnboardingUseCase,
  }) : super(const OnboardingInitialState()) {
    on<CheckFirstTimeEvent>(_onCheckFirstTime);
    on<OnboardingPageChangedEvent>(_onPageChanged);
    on<NextOnboardingPageEvent>(_onNextPage);
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
  }

  Future<void> _onCheckFirstTime(
    CheckFirstTimeEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingLoadingState());
    final isFirst = await checkFirstTimeUseCase();
    if (isFirst) {
      emit(
        OnboardingLoadedState(
          items: onboardingItems,
          currentPageIndex: 0,
          isFirstTime: true,
        ),
      );
    } else {
      emit(const OnboardingCompletedState());
    }
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

  void _onNextPage(
    NextOnboardingPageEvent event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingLoadedState) {
      final currentState = state as OnboardingLoadedState;
      if (currentState.currentPageIndex < currentState.items.length - 1) {
        emit(
          currentState.copyWith(
            currentPageIndex: currentState.currentPageIndex + 1,
          ),
        );
      } else {
        add(const CompleteOnboardingEvent());
      }
    }
  }

  Future<void> _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    await completeOnboardingUseCase();
    emit(const OnboardingCompletedState());
  }
}

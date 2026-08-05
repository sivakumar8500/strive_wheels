abstract class OnboardingEvent {
  const OnboardingEvent();
}

class CheckFirstTimeEvent extends OnboardingEvent {
  const CheckFirstTimeEvent();
}

class OnboardingPageChangedEvent extends OnboardingEvent {
  final int pageIndex;

  const OnboardingPageChangedEvent(this.pageIndex);
}

class NextOnboardingPageEvent extends OnboardingEvent {
  const NextOnboardingPageEvent();
}

class CompleteOnboardingEvent extends OnboardingEvent {
  const CompleteOnboardingEvent();
}

abstract class HomeEvent {
  const HomeEvent();
}

class LoadHomeDashboardEvent extends HomeEvent {
  const LoadHomeDashboardEvent();
}

class ChangeNavTabEvent extends HomeEvent {
  final int tabIndex;

  const ChangeNavTabEvent(this.tabIndex);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeNavTabEvent &&
          runtimeType == other.runtimeType &&
          tabIndex == other.tabIndex;

  @override
  int get hashCode => tabIndex.hashCode;
}

class SelectQuickServiceEvent extends HomeEvent {
  final String serviceName;

  const SelectQuickServiceEvent(this.serviceName);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectQuickServiceEvent &&
          runtimeType == other.runtimeType &&
          serviceName == other.serviceName;

  @override
  int get hashCode => serviceName.hashCode;
}

class ClaimOfferEvent extends HomeEvent {
  final String offerCode;

  const ClaimOfferEvent(this.offerCode);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClaimOfferEvent &&
          runtimeType == other.runtimeType &&
          offerCode == other.offerCode;

  @override
  int get hashCode => offerCode.hashCode;
}

class RepeatRideEvent extends HomeEvent {
  const RepeatRideEvent();
}

class SearchQueryChangedEvent extends HomeEvent {
  final String query;

  const SearchQueryChangedEvent(this.query);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchQueryChangedEvent &&
          runtimeType == other.runtimeType &&
          query == other.query;

  @override
  int get hashCode => query.hashCode;
}

class SearchSubmittedEvent extends HomeEvent {
  final String query;

  const SearchSubmittedEvent(this.query);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchSubmittedEvent &&
          runtimeType == other.runtimeType &&
          query == other.query;

  @override
  int get hashCode => query.hashCode;
}

class OpenMenuEvent extends HomeEvent {
  const OpenMenuEvent();
}

class OpenMicEvent extends HomeEvent {
  const OpenMicEvent();
}

class OpenNotificationsEvent extends HomeEvent {
  const OpenNotificationsEvent();
}

class OpenProfileEvent extends HomeEvent {
  const OpenProfileEvent();
}

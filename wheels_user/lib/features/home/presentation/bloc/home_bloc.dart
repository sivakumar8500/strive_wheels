import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_home_dashboard_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDashboardUseCase getHomeDashboardUseCase;

  HomeBloc({
    required this.getHomeDashboardUseCase,
  }) : super(const HomeState(isLoading: true)) {
    on<LoadHomeDashboardEvent>(_onLoadHomeDashboard);
    on<ChangeNavTabEvent>(_onChangeNavTab);
    on<SelectQuickServiceEvent>(_onSelectQuickService);
    on<ClaimOfferEvent>(_onClaimOffer);
    on<RepeatRideEvent>(_onRepeatRide);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<SearchSubmittedEvent>(_onSearchSubmitted);
    on<OpenMenuEvent>(_onOpenMenu);
    on<OpenMicEvent>(_onOpenMic);
    on<OpenNotificationsEvent>(_onOpenNotifications);
    on<OpenProfileEvent>(_onOpenProfile);
  }

  Future<void> _onLoadHomeDashboard(
    LoadHomeDashboardEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final entity = await getHomeDashboardUseCase();
      emit(state.copyWith(
        isLoading: false,
        dashboardEntity: entity,
        selectedNavIndex: entity.selectedNavIndex,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load dashboard',
      ));
    }
  }

  void _onChangeNavTab(
    ChangeNavTabEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(selectedNavIndex: event.tabIndex));
  }

  void _onSelectQuickService(
    SelectQuickServiceEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(selectedService: event.serviceName));
  }

  void _onClaimOffer(
    ClaimOfferEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      claimedOfferMessage: 'Offer code ${event.offerCode} applied!',
    ));
  }

  void _onRepeatRide(
    RepeatRideEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      selectedService: 'Office ➔ Home Repeat',
    ));
  }

  void _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onSearchSubmitted(
    SearchSubmittedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      actionMessage: 'Searching for destination: ${event.query}',
    ));
  }

  void _onOpenMenu(
    OpenMenuEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(actionMessage: 'Menu opened'));
  }

  void _onOpenMic(
    OpenMicEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(actionMessage: 'Voice search activated'));
  }

  void _onOpenNotifications(
    OpenNotificationsEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(actionMessage: 'Notifications opened'));
  }

  void _onOpenProfile(
    OpenProfileEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(actionMessage: 'User profile JW opened'));
  }
}

import '../../domain/entities/home_dashboard_entity.dart';

class HomeState {
  final bool isLoading;
  final HomeDashboardEntity? dashboardEntity;
  final int selectedNavIndex;
  final String? selectedService;
  final String? claimedOfferMessage;
  final String? searchQuery;
  final String? actionMessage;
  final String? errorMessage;

  const HomeState({
    this.isLoading = false,
    this.dashboardEntity,
    this.selectedNavIndex = 0,
    this.selectedService,
    this.claimedOfferMessage,
    this.searchQuery,
    this.actionMessage,
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    HomeDashboardEntity? dashboardEntity,
    int? selectedNavIndex,
    String? selectedService,
    String? claimedOfferMessage,
    String? searchQuery,
    String? actionMessage,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      dashboardEntity: dashboardEntity ?? this.dashboardEntity,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      selectedService: selectedService ?? this.selectedService,
      claimedOfferMessage: claimedOfferMessage ?? this.claimedOfferMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      actionMessage: actionMessage,
      errorMessage: errorMessage,
    );
  }
}

import '../../domain/entities/driver_search_entity.dart';

class DriverSearchState {
  final bool isLoading;
  final DriverSearchEntity? driverSearch;
  final bool isCancelled;
  final String? errorMessage;

  const DriverSearchState({
    this.isLoading = true,
    this.driverSearch,
    this.isCancelled = false,
    this.errorMessage,
  });

  DriverSearchState copyWith({
    bool? isLoading,
    DriverSearchEntity? driverSearch,
    bool? isCancelled,
    String? errorMessage,
  }) {
    return DriverSearchState(
      isLoading: isLoading ?? this.isLoading,
      driverSearch: driverSearch ?? this.driverSearch,
      isCancelled: isCancelled ?? this.isCancelled,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

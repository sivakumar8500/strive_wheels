import '../../domain/entities/trip_entity.dart';

abstract class TripsState {}

class TripsInitial extends TripsState {}

class TripsLoading extends TripsState {}

class TripsLoaded extends TripsState {
  final TripEntity tripEntity;

  TripsLoaded(this.tripEntity);
}

class TripsError extends TripsState {
  final String message;

  TripsError(this.message);
}

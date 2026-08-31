import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/rider_repository.dart';

abstract class RiderTripEvent {}

class GoOnlineEvent extends RiderTripEvent {}
class GoOfflineEvent extends RiderTripEvent {}

abstract class RiderTripState {}

class RiderTripInitial extends RiderTripState {}
class RiderTripLoading extends RiderTripState {}
class RiderTripOnline extends RiderTripState {}
class RiderTripOffline extends RiderTripState {}
class RiderTripError extends RiderTripState {
  final String message;
  RiderTripError(this.message);
}

class RiderTripBloc extends Bloc<RiderTripEvent, RiderTripState> {
  final RiderRepository repository;

  RiderTripBloc(this.repository) : super(RiderTripInitial()) {
    on<GoOnlineEvent>((event, emit) async {
      emit(RiderTripLoading());
      try {
        final response = await repository.setAvailability(mode: 'NORMAL', isOnline: true);
        if (response.success) {
          emit(RiderTripOnline());
        } else {
          emit(RiderTripError('Failed to go online'));
        }
      } catch (e) {
        emit(RiderTripError(e.toString()));
      }
    });

    on<GoOfflineEvent>((event, emit) async {
      emit(RiderTripLoading());
      try {
        final response = await repository.setAvailability(mode: 'NORMAL', isOnline: false);
        if (response.success) {
          emit(RiderTripOffline());
        } else {
          emit(RiderTripError('Failed to go offline'));
        }
      } catch (e) {
        emit(RiderTripError(e.toString()));
      }
    });
  }
}

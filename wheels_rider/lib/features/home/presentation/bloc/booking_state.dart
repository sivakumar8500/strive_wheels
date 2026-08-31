import '../../domain/entities/ride_request_entity.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingConnected extends BookingState {}

class NewRideRequestState extends BookingState {
  final RideRequestEntity rideRequest;
  NewRideRequestState(this.rideRequest);
}

class AcceptingRideState extends BookingState {}

class RideAcceptedSuccessState extends BookingState {
  final int bookingId;
  RideAcceptedSuccessState(this.bookingId);
}

class BookingErrorState extends BookingState {
  final String message;
  BookingErrorState(this.message);
}

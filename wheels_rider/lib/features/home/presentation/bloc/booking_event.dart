abstract class BookingEvent {}

class ConnectWebSocketEvent extends BookingEvent {
  final int driverId;
  final String token;
  ConnectWebSocketEvent({required this.driverId, required this.token});
}

class DisconnectWebSocketEvent extends BookingEvent {}

class RideRequestReceivedEvent extends BookingEvent {
  final dynamic rideRequest; // Will cast to RideRequestEntity in Bloc
  RideRequestReceivedEvent(this.rideRequest);
}

class AcceptRideEvent extends BookingEvent {
  final int bookingId;
  AcceptRideEvent(this.bookingId);
}

class DeclineRideEvent extends BookingEvent {}

class BookingSuccessEvent extends BookingEvent {
  final int bookingId;
  BookingSuccessEvent(this.bookingId);
}

class BookingErrorEvent extends BookingEvent {
  final String message;
  BookingErrorEvent(this.message);
}

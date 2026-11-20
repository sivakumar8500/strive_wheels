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

class SendLocationPingEvent extends BookingEvent {
  final double lat;
  final double lng;
  final double heading;
  final double speedKmh;

  SendLocationPingEvent({
    required this.lat,
    required this.lng,
    this.heading = 0.0,
    this.speedKmh = 0.0,
  });
}

class RideCancelledEvent extends BookingEvent {
  final String reason;
  RideCancelledEvent({this.reason = 'Ride cancelled by customer'});
}

class CancelRideEvent extends BookingEvent {
  final int bookingId;
  final String reason;
  CancelRideEvent({required this.bookingId, this.reason = 'Rider cancelled trip'});
}

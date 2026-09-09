import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import '../../domain/usecases/booking_usecases.dart';
import '../../domain/entities/ride_request_entity.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ConnectToBookingSocketUseCase connectToBookingSocket;
  final DisconnectBookingSocketUseCase disconnectBookingSocket;
  final AcceptBookingUseCase acceptBooking;
  final GetRideRequestsStreamUseCase getRideRequestsStream;
  final GetBookingSuccessStreamUseCase getBookingSuccessStream;
  final GetBookingErrorStreamUseCase getBookingErrorStream;
  final GetRideCancelledStreamUseCase? getRideCancelledStream;

  StreamSubscription? _requestsSubscription;
  StreamSubscription? _successSubscription;
  StreamSubscription? _errorSubscription;
  StreamSubscription? _cancelledSubscription;

  BookingBloc({
    required this.connectToBookingSocket,
    required this.disconnectBookingSocket,
    required this.acceptBooking,
    required this.getRideRequestsStream,
    required this.getBookingSuccessStream,
    required this.getBookingErrorStream,
    this.getRideCancelledStream,
  }) : super(BookingInitial()) {
    on<ConnectWebSocketEvent>(_onConnectWebSocket);
    on<DisconnectWebSocketEvent>(_onDisconnectWebSocket);
    on<RideRequestReceivedEvent>(_onRideRequestReceived);
    on<AcceptRideEvent>(_onAcceptRide);
    on<DeclineRideEvent>(_onDeclineRide);
    on<BookingSuccessEvent>(_onBookingSuccess);
    on<BookingErrorEvent>(_onBookingError);
    on<RideCancelledEvent>(_onRideCancelled);
  }

  void _onConnectWebSocket(ConnectWebSocketEvent event, Emitter<BookingState> emit) {
    connectToBookingSocket(event.driverId, event.token);
    emit(BookingConnected());

    _requestsSubscription?.cancel();
    _requestsSubscription = getRideRequestsStream().listen((rideRequest) {
      add(RideRequestReceivedEvent(rideRequest));
    });

    _successSubscription?.cancel();
    _successSubscription = getBookingSuccessStream().listen((bookingId) {
      add(BookingSuccessEvent(bookingId));
    });

    _errorSubscription?.cancel();
    _errorSubscription = getBookingErrorStream().listen((errorMsg) {
      add(BookingErrorEvent(errorMsg));
    });

    _cancelledSubscription?.cancel();
    if (getRideCancelledStream != null) {
      _cancelledSubscription = getRideCancelledStream!().listen((data) {
        final reason = data['reason']?.toString() ?? 'Ride was cancelled by customer';
        add(RideCancelledEvent(reason: reason));
      });
    }
  }

  void _onDisconnectWebSocket(DisconnectWebSocketEvent event, Emitter<BookingState> emit) {
    disconnectBookingSocket();
    _requestsSubscription?.cancel();
    _successSubscription?.cancel();
    _errorSubscription?.cancel();
    _cancelledSubscription?.cancel();
    emit(BookingInitial());
  }

  void _onRideRequestReceived(RideRequestReceivedEvent event, Emitter<BookingState> emit) {
    emit(NewRideRequestState(event.rideRequest as RideRequestEntity));
  }

  void _onAcceptRide(AcceptRideEvent event, Emitter<BookingState> emit) {
    emit(AcceptingRideState());
    acceptBooking(event.bookingId);
  }

  void _onDeclineRide(DeclineRideEvent event, Emitter<BookingState> emit) {
    emit(BookingConnected()); // Return to connected state without showing request
  }

  void _onBookingSuccess(BookingSuccessEvent event, Emitter<BookingState> emit) {
    emit(RideAcceptedSuccessState(event.bookingId));
  }

  void _onBookingError(BookingErrorEvent event, Emitter<BookingState> emit) {
    emit(BookingErrorState(event.message));
  }

  void _onRideCancelled(RideCancelledEvent event, Emitter<BookingState> emit) {
    emit(RideCancelledState(event.reason));
  }

  @override
  Future<void> close() {
    disconnectBookingSocket();
    _requestsSubscription?.cancel();
    _successSubscription?.cancel();
    _errorSubscription?.cancel();
    _cancelledSubscription?.cancel();
    return super.close();
  }
}

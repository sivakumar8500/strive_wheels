import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'booking_event.dart';
import 'booking_state.dart';
import '../../domain/usecases/booking_usecases.dart';
import '../../domain/entities/ride_request_entity.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ConnectToBookingSocketUseCase connectToBookingSocket;
  final DisconnectBookingSocketUseCase disconnectBookingSocket;
  final AcceptBookingUseCase acceptBooking;
  final DeclineBookingUseCase? declineBookingUseCase;
  final GetRideRequestsStreamUseCase getRideRequestsStream;
  final GetBookingSuccessStreamUseCase getBookingSuccessStream;
  final GetBookingErrorStreamUseCase getBookingErrorStream;
  final GetRideCancelledStreamUseCase getRideCancelledStream;
  final SendLocationPingUseCase sendLocationPing;
  final CancelBookingUseCase? cancelBookingUseCase;

  final Set<int> _declinedBookingIds = <int>{};
  StreamSubscription? _requestsSubscription;
  StreamSubscription? _successSubscription;
  StreamSubscription? _errorSubscription;
  StreamSubscription? _cancelledSubscription;

  BookingBloc({
    required this.connectToBookingSocket,
    required this.disconnectBookingSocket,
    required this.acceptBooking,
    this.declineBookingUseCase,
    required this.getRideRequestsStream,
    required this.getBookingSuccessStream,
    required this.getBookingErrorStream,
    required this.getRideCancelledStream,
    required this.sendLocationPing,
    this.cancelBookingUseCase,
  }) : super(BookingInitial()) {
    _loadDeclinedBookings();
    on<ConnectWebSocketEvent>(_onConnectWebSocket);
    on<DisconnectWebSocketEvent>(_onDisconnectWebSocket);
    on<RideRequestReceivedEvent>(_onRideRequestReceived);
    on<AcceptRideEvent>(_onAcceptRide);
    on<DeclineRideEvent>(_onDeclineRide);
    on<BookingSuccessEvent>(_onBookingSuccess);
    on<BookingErrorEvent>(_onBookingError);
    on<RideCancelledEvent>(_onRideCancelled);
    on<CancelRideEvent>(_onCancelRide);
    on<SendLocationPingEvent>(_onSendLocationPing);
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
    _cancelledSubscription = getRideCancelledStream().listen((data) {
      final reason = data['reason'] as String? ?? 'Ride cancelled by customer';
      add(RideCancelledEvent(reason: reason));
    });
  }

  void _onDisconnectWebSocket(DisconnectWebSocketEvent event, Emitter<BookingState> emit) {
    disconnectBookingSocket();
    _requestsSubscription?.cancel();
    _successSubscription?.cancel();
    _errorSubscription?.cancel();
    _cancelledSubscription?.cancel();
    emit(BookingInitial());
  }

  Future<void> _loadDeclinedBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList('declined_ride_ids') ?? [];
      final loaded = list.map((e) => int.tryParse(e)).whereType<int>().toSet();
      _declinedBookingIds.addAll(loaded);
    } catch (_) {}
  }

  Future<void> _saveDeclinedBooking(int bookingId) async {
    _declinedBookingIds.add(bookingId);
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _declinedBookingIds.map((e) => e.toString()).toList();
      await prefs.setStringList('declined_ride_ids', list);
    } catch (_) {}
  }

  void _onRideRequestReceived(RideRequestReceivedEvent event, Emitter<BookingState> emit) {
    final req = event.rideRequest as RideRequestEntity;
    if (_declinedBookingIds.contains(req.id)) {
      return;
    }
    emit(NewRideRequestState(req));
  }

  void _onAcceptRide(AcceptRideEvent event, Emitter<BookingState> emit) {
    emit(AcceptingRideState());
    acceptBooking(event.bookingId);
  }

  void _onDeclineRide(DeclineRideEvent event, Emitter<BookingState> emit) {
    if (event.bookingId != null) {
      _saveDeclinedBooking(event.bookingId!);
      declineBookingUseCase?.call(event.bookingId!);
    }
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

  void _onCancelRide(CancelRideEvent event, Emitter<BookingState> emit) {
    cancelBookingUseCase?.call(event.bookingId, reason: event.reason);
    emit(RideCancelledState(event.reason));
  }

  void _onSendLocationPing(SendLocationPingEvent event, Emitter<BookingState> emit) {
    sendLocationPing(
      lat: event.lat,
      lng: event.lng,
      heading: event.heading,
      speedKmh: event.speedKmh,
    );
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

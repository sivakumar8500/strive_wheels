import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/home/domain/entities/ride_request_entity.dart';
import 'package:wheels_rider/features/home/domain/usecases/booking_usecases.dart';
import 'package:wheels_rider/features/home/presentation/bloc/booking_bloc.dart';
import 'package:wheels_rider/features/home/presentation/bloc/booking_event.dart';
import 'package:wheels_rider/features/home/presentation/bloc/booking_state.dart';

class MockConnectToBookingSocketUseCase extends Mock implements ConnectToBookingSocketUseCase {}
class MockDisconnectBookingSocketUseCase extends Mock implements DisconnectBookingSocketUseCase {}
class MockAcceptBookingUseCase extends Mock implements AcceptBookingUseCase {}
class MockGetRideRequestsStreamUseCase extends Mock implements GetRideRequestsStreamUseCase {}
class MockGetBookingSuccessStreamUseCase extends Mock implements GetBookingSuccessStreamUseCase {}
class MockGetBookingErrorStreamUseCase extends Mock implements GetBookingErrorStreamUseCase {}
class MockGetRideCancelledStreamUseCase extends Mock implements GetRideCancelledStreamUseCase {}
class MockSendLocationPingUseCase extends Mock implements SendLocationPingUseCase {}

void main() {
  late MockConnectToBookingSocketUseCase mockConnectToBookingSocketUseCase;
  late MockDisconnectBookingSocketUseCase mockDisconnectBookingSocketUseCase;
  late MockAcceptBookingUseCase mockAcceptBookingUseCase;
  late MockGetRideRequestsStreamUseCase mockGetRideRequestsStreamUseCase;
  late MockGetBookingSuccessStreamUseCase mockGetBookingSuccessStreamUseCase;
  late MockGetBookingErrorStreamUseCase mockGetBookingErrorStreamUseCase;
  late MockGetRideCancelledStreamUseCase mockGetRideCancelledStreamUseCase;
  late MockSendLocationPingUseCase mockSendLocationPingUseCase;

  setUp(() {
    mockConnectToBookingSocketUseCase = MockConnectToBookingSocketUseCase();
    mockDisconnectBookingSocketUseCase = MockDisconnectBookingSocketUseCase();
    mockAcceptBookingUseCase = MockAcceptBookingUseCase();
    mockGetRideRequestsStreamUseCase = MockGetRideRequestsStreamUseCase();
    mockGetBookingSuccessStreamUseCase = MockGetBookingSuccessStreamUseCase();
    mockGetBookingErrorStreamUseCase = MockGetBookingErrorStreamUseCase();
    mockGetRideCancelledStreamUseCase = MockGetRideCancelledStreamUseCase();
    mockSendLocationPingUseCase = MockSendLocationPingUseCase();

    when(() => mockGetRideRequestsStreamUseCase()).thenAnswer((_) => const Stream.empty());
    when(() => mockGetBookingSuccessStreamUseCase()).thenAnswer((_) => const Stream.empty());
    when(() => mockGetBookingErrorStreamUseCase()).thenAnswer((_) => const Stream.empty());
    when(() => mockGetRideCancelledStreamUseCase()).thenAnswer((_) => const Stream.empty());
  });

  group('BookingBloc', () {
    const int tDriverId = 101;
    const String tToken = 'test_jwt_token';
    const int tBookingId = 505;

    BookingBloc buildBloc() {
      return BookingBloc(
        connectToBookingSocket: mockConnectToBookingSocketUseCase,
        disconnectBookingSocket: mockDisconnectBookingSocketUseCase,
        acceptBooking: mockAcceptBookingUseCase,
        getRideRequestsStream: mockGetRideRequestsStreamUseCase,
        getBookingSuccessStream: mockGetBookingSuccessStreamUseCase,
        getBookingErrorStream: mockGetBookingErrorStreamUseCase,
        getRideCancelledStream: mockGetRideCancelledStreamUseCase,
        sendLocationPing: mockSendLocationPingUseCase,
      );
    }

    test('initial state should be BookingInitial', () {
      expect(buildBloc().state, isA<BookingInitial>());
    });

    blocTest<BookingBloc, BookingState>(
      'emits [BookingConnected] when ConnectWebSocketEvent is added',
      build: () {
        when(() => mockConnectToBookingSocketUseCase(tDriverId, tToken)).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(ConnectWebSocketEvent(driverId: tDriverId, token: tToken)),
      expect: () => [isA<BookingConnected>()],
      verify: (_) {
        verify(() => mockConnectToBookingSocketUseCase(tDriverId, tToken)).called(1);
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits [BookingInitial] when DisconnectWebSocketEvent is added',
      build: () {
        when(() => mockDisconnectBookingSocketUseCase()).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(DisconnectWebSocketEvent()),
      expect: () => [isA<BookingInitial>()],
      verify: (_) {
        verify(() => mockDisconnectBookingSocketUseCase()).called(greaterThanOrEqualTo(1));
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits [AcceptingRideState] when AcceptRideEvent is added',
      build: () {
        when(() => mockAcceptBookingUseCase(tBookingId)).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(AcceptRideEvent(tBookingId)),
      expect: () => [isA<AcceptingRideState>()],
      verify: (_) {
        verify(() => mockAcceptBookingUseCase(tBookingId)).called(1);
      },
    );

    blocTest<BookingBloc, BookingState>(
      'calls SendLocationPingUseCase when SendLocationPingEvent is added',
      build: () {
        when(() => mockSendLocationPingUseCase(
              lat: 17.4126,
              lng: 78.3498,
              heading: 90.0,
              speedKmh: 25.5,
            )).thenReturn(null);
        return buildBloc();
      },
      act: (bloc) => bloc.add(SendLocationPingEvent(
        lat: 17.4126,
        lng: 78.3498,
        heading: 90.0,
        speedKmh: 25.5,
      )),
      expect: () => [],
      verify: (_) {
        verify(() => mockSendLocationPingUseCase(
              lat: 17.4126,
              lng: 78.3498,
              heading: 90.0,
              speedKmh: 25.5,
            )).called(1);
      },
    );

    blocTest<BookingBloc, BookingState>(
      'emits [NewRideRequestState] when RideRequestReceivedEvent is added',
      build: () => buildBloc(),
      act: (bloc) => bloc.add(RideRequestReceivedEvent(
        const RideRequestEntity(
          id: 105,
          pickupAddress: 'Hitech City',
          dropAddress: 'Gachibowli',
          estimatedFare: 185.0,
          pickupLat: 17.4126,
          pickupLng: 78.3498,
          dropLat: 17.4435,
          dropLng: 78.3772,
        ),
      )),
      expect: () => [isA<NewRideRequestState>()],
    );
  });
}

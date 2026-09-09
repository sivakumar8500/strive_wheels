import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/trip_overview/domain/entities/trip_overview_entity.dart';
import 'package:wheels_user/features/trip_overview/domain/usecases/get_trip_overview_usecase.dart';
import 'package:wheels_user/features/trip_overview/presentation/bloc/trip_overview_bloc.dart';
import 'package:wheels_user/features/trip_overview/presentation/bloc/trip_overview_event.dart';
import 'package:wheels_user/features/trip_overview/presentation/bloc/trip_overview_state.dart';

class MockGetTripOverviewUseCase extends Mock
    implements GetTripOverviewUseCase {}

void main() {
  late TripOverviewBloc bloc;
  late MockGetTripOverviewUseCase mockGetTripOverviewUseCase;

  const tEntity = TripOverviewEntity(
    pickupLocation: 'St. Regis Residences, Downtown Dubai',
    destination: 'Dubai International Airport (DXB) Terminal 3',
    tripType: 'One Way',
    distanceText: '14.2 km (Approx 18 mins)',
    vehicleName: 'Executive Luxury Sedan',
    vehicleSeats: '4 Seats',
    vehicleLuggage: '3 Luggage',
    vehicleAmenity: 'Complimentary Wi-Fi',
    vehicleImagePath: 'assets/images/vehicle_mercedes.png',
    walletBalance: 142.50,
    baseFare: 85.00,
    distanceCharge: 12.50,
    serviceSurcharge: 5.00,
    taxesFees: 5.12,
    grandTotal: 107.62,
    currency: 'USD',
  );

  setUp(() {
    mockGetTripOverviewUseCase = MockGetTripOverviewUseCase();
    bloc = TripOverviewBloc(
      getTripOverviewUseCase: mockGetTripOverviewUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is TripOverviewState with isLoading true', () {
    expect(bloc.state.isLoading, isTrue);
  });

  blocTest<TripOverviewBloc, TripOverviewState>(
    'emits [isLoading true, isLoading false with tripOverview] on LoadTripOverviewEvent',
    build: () {
      when(() => mockGetTripOverviewUseCase()).thenAnswer((_) async => tEntity);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadTripOverviewEvent()),
    expect: () => [
      isA<TripOverviewState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<TripOverviewState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.tripOverview, 'tripOverview', tEntity),
    ],
  );

  blocTest<TripOverviewBloc, TripOverviewState>(
    'updates isWalletSelected on ToggleWalletPaymentEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const ToggleWalletPaymentEvent(true)),
    expect: () => [
      isA<TripOverviewState>()
          .having((s) => s.isWalletSelected, 'isWalletSelected', isTrue),
    ],
  );

  blocTest<TripOverviewBloc, TripOverviewState>(
    'emits isBookingConfirmed true on ConfirmFinalBookingEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const ConfirmFinalBookingEvent()),
    expect: () => [
      isA<TripOverviewState>()
          .having((s) => s.isBookingConfirmed, 'isBookingConfirmed', isTrue),
    ],
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/booking/domain/entities/recent_journey_entity.dart';
import 'package:wheels_user/features/booking/domain/entities/vehicle_option_entity.dart';
import 'package:wheels_user/features/booking/domain/usecases/get_available_vehicles_usecase.dart';
import 'package:wheels_user/features/booking/domain/usecases/get_recent_journeys_usecase.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_event.dart';
import 'package:wheels_user/features/booking/presentation/bloc/booking_state.dart';

class MockGetRecentJourneysUseCase extends Mock
    implements GetRecentJourneysUseCase {}

class MockGetAvailableVehiclesUseCase extends Mock
    implements GetAvailableVehiclesUseCase {}

void main() {
  late BookingBloc bloc;
  late MockGetRecentJourneysUseCase mockGetRecentJourneysUseCase;
  late MockGetAvailableVehiclesUseCase mockGetAvailableVehiclesUseCase;

  const tJourneys = [
    RecentJourneyEntity(
      id: '1',
      title: 'JFK International Airport',
      origin: 'From Lower Manhattan',
      timestamp: '2 days ago',
      iconType: 'history',
    ),
  ];

  const tVehicles = [
    VehicleOptionEntity(
      id: 'v1',
      name: 'Mercedes E-Class',
      specs: '4 Seats · AC · Automatic',
      price: '₹450',
      rating: '4.9 (48)',
      eta: '4 min',
      imagePath: 'assets/images/mercedes_car.png',
    ),
  ];

  setUp(() {
    mockGetRecentJourneysUseCase = MockGetRecentJourneysUseCase();
    mockGetAvailableVehiclesUseCase = MockGetAvailableVehiclesUseCase();
    bloc = BookingBloc(
      getRecentJourneysUseCase: mockGetRecentJourneysUseCase,
      getAvailableVehiclesUseCase: mockGetAvailableVehiclesUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is BookingState with isLoading true', () {
    expect(bloc.state.isLoading, isTrue);
  });

  blocTest<BookingBloc, BookingState>(
    'emits state with journeys and vehicles on LoadBookingDataEvent success',
    build: () {
      when(() => mockGetRecentJourneysUseCase())
          .thenAnswer((_) async => tJourneys);
      when(() => mockGetAvailableVehiclesUseCase())
          .thenAnswer((_) async => tVehicles);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadBookingDataEvent()),
    expect: () => [
      isA<BookingState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<BookingState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.recentJourneys, 'recentJourneys', tJourneys)
          .having((s) => s.availableVehicles, 'availableVehicles', tVehicles),
    ],
  );

  blocTest<BookingBloc, BookingState>(
    'updates ride type tab index on SelectRideTypeTabEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const SelectRideTypeTabEvent(1)),
    expect: () => [
      isA<BookingState>()
          .having((s) => s.selectedRideTypeIndex, 'selectedRideTypeIndex', 1),
    ],
  );

  blocTest<BookingBloc, BookingState>(
    'sets isShowingVehicleResults true on SearchVehiclesEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const SearchVehiclesEvent()),
    expect: () => [
      isA<BookingState>().having(
        (s) => s.isShowingVehicleResults,
        'isShowingVehicleResults',
        isTrue,
      ),
    ],
  );

  blocTest<BookingBloc, BookingState>(
    'emits actionMessage on BookVehicleNowEvent',
    build: () => bloc,
    act: (bloc) => bloc.add(const BookVehicleNowEvent(
      vehicleId: 'v1',
      vehicleName: 'Mercedes E-Class',
    )),
    expect: () => [
      isA<BookingState>().having(
        (s) => s.actionMessage,
        'actionMessage',
        'Booking Mercedes E-Class... Ride confirmed!',
      ),
    ],
  );
}

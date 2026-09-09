import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/vehicle_details/domain/entities/vehicle_details_entity.dart';
import 'package:wheels_user/features/vehicle_details/domain/usecases/get_vehicle_details_usecase.dart';
import 'package:wheels_user/features/vehicle_details/presentation/bloc/vehicle_details_bloc.dart';
import 'package:wheels_user/features/vehicle_details/presentation/bloc/vehicle_details_event.dart';
import 'package:wheels_user/features/vehicle_details/presentation/bloc/vehicle_details_state.dart';

class MockGetVehicleDetailsUseCase extends Mock
    implements GetVehicleDetailsUseCase {}

void main() {
  late VehicleDetailsBloc bloc;
  late MockGetVehicleDetailsUseCase mockGetVehicleDetailsUseCase;

  const tDetails = VehicleDetailsEntity(
    id: 'v4',
    vehicleName: 'Range Rover Autobiography',
    operatorName: 'SilverStar Luxury Rentals',
    isEcoFriendly: true,
    isTopRated: true,
    capacity: '6 Seats',
    luggage: '4 Large',
    amenities: 'Free Wi-Fi',
    climate: 'Quad Zone',
    driverName: 'Michael Henderson',
    driverRating: '4.9',
    driverTrips: '240trips',
    driverBio: 'Elite-tier driver.',
    estimatedDuration: '42 mins est.',
    pickupLocation: 'Zurich Airport (ZRH)',
    dropoffLocation: 'Baur au Lac Hotel',
    price: '₹1,850',
    imagePath: 'assets/images/vehicle_range_rover.jpg',
  );

  setUp(() {
    mockGetVehicleDetailsUseCase = MockGetVehicleDetailsUseCase();
    bloc = VehicleDetailsBloc(
      getVehicleDetailsUseCase: mockGetVehicleDetailsUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is VehicleDetailsState with isLoading true', () {
    expect(bloc.state.isLoading, isTrue);
  });

  blocTest<VehicleDetailsBloc, VehicleDetailsState>(
    'emits state with vehicleDetails on LoadVehicleDetailsEvent success',
    build: () {
      when(() => mockGetVehicleDetailsUseCase(any()))
          .thenAnswer((_) async => tDetails);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadVehicleDetailsEvent('v4')),
    expect: () => [
      isA<VehicleDetailsState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<VehicleDetailsState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.vehicleDetails, 'vehicleDetails', tDetails),
    ],
  );

  blocTest<VehicleDetailsBloc, VehicleDetailsState>(
    'emits isBookingConfirmed true on ConfirmVehicleBookingEvent',
    build: () => bloc,
    seed: () => const VehicleDetailsState(vehicleDetails: tDetails),
    act: (bloc) => bloc.add(const ConfirmVehicleBookingEvent('v4')),
    expect: () => [
      isA<VehicleDetailsState>()
          .having((s) => s.isBookingConfirmed, 'isBookingConfirmed', isTrue)
          .having(
            (s) => s.actionMessage,
            'actionMessage',
            'Booking for Range Rover Autobiography confirmed successfully!',
          ),
    ],
  );
}

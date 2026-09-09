import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/home/domain/usecases/update_location_usecase.dart';
import 'package:wheels_rider/features/home/presentation/bloc/home_bloc.dart';
import 'package:wheels_rider/features/home/presentation/bloc/home_event.dart';
import 'package:wheels_rider/features/home/presentation/bloc/home_state.dart';
import 'package:wheels_rider/features/home/domain/usecases/update_availability_usecase.dart';

class MockUpdateLocationUseCase extends Mock implements UpdateLocationUseCase {}
class MockUpdateAvailabilityUseCase extends Mock implements UpdateAvailabilityUseCase {}

void main() {
  late MockUpdateLocationUseCase mockUpdateLocationUseCase;
  late MockUpdateAvailabilityUseCase mockUpdateAvailabilityUseCase;

  setUp(() {
    mockUpdateLocationUseCase = MockUpdateLocationUseCase();
    mockUpdateAvailabilityUseCase = MockUpdateAvailabilityUseCase();
  });

  group('HomeBloc', () {
    const double tLat = 12.34;
    const double tLng = 56.78;

    blocTest<HomeBloc, HomeState>(
      'emits [loading, success] when UpdateLocation is successful',
      build: () {
        when(() => mockUpdateLocationUseCase(tLat, tLng))
            .thenAnswer((_) async => Future.value());
        return HomeBloc(
          updateLocationUseCase: mockUpdateLocationUseCase,
          updateAvailabilityUseCase: mockUpdateAvailabilityUseCase,
        );
      },
      act: (bloc) => bloc.add(const HomeEvent.updateLocation(lat: tLat, lng: tLng)),
      expect: () => const [
        HomeState.loading(),
        HomeState.success(),
      ],
      verify: (_) {
        verify(() => mockUpdateLocationUseCase(tLat, tLng)).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [loading, failure] when UpdateLocation fails',
      build: () {
        when(() => mockUpdateLocationUseCase(tLat, tLng))
            .thenThrow(Exception('Server error'));
        return HomeBloc(
          updateLocationUseCase: mockUpdateLocationUseCase,
          updateAvailabilityUseCase: mockUpdateAvailabilityUseCase,
        );
      },
      act: (bloc) => bloc.add(const HomeEvent.updateLocation(lat: tLat, lng: tLng)),
      expect: () => [
        const HomeState.loading(),
        isA<HomeState>().having((s) => s.maybeMap(
          failure: (f) => f.message,
          orElse: () => null,
        ), 'message', contains('Server error')),
      ],
      verify: (_) {
        verify(() => mockUpdateLocationUseCase(tLat, tLng)).called(1);
      },
    );
  });
}

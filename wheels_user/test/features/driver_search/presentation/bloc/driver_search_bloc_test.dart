import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/driver_search/domain/entities/driver_search_entity.dart';
import 'package:wheels_user/features/driver_search/domain/usecases/get_driver_search_usecase.dart';
import 'package:wheels_user/features/driver_search/presentation/bloc/driver_search_bloc.dart';
import 'package:wheels_user/features/driver_search/presentation/bloc/driver_search_event.dart';
import 'package:wheels_user/features/driver_search/presentation/bloc/driver_search_state.dart';

class MockGetDriverSearchUseCase extends Mock
    implements GetDriverSearchUseCase {}

void main() {
  late DriverSearchBloc bloc;
  late MockGetDriverSearchUseCase mockGetDriverSearchUseCase;

  const tEntity = DriverSearchEntity(
    statusTitle: 'Searching for nearby drivers...',
    statusSubtitle: 'Connecting you to the nearest premium vehicle.',
    estimatedConfirmationText: '5 - 30 mins',
    orderTime: '10:42 AM',
    scanRadiusText: 'Scanning 1.2km radius...',
    activeStepIndex: 1,
  );

  setUp(() {
    mockGetDriverSearchUseCase = MockGetDriverSearchUseCase();
    bloc = DriverSearchBloc(getDriverSearchUseCase: mockGetDriverSearchUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is DriverSearchState with isLoading true', () {
    expect(bloc.state.isLoading, isTrue);
  });

  blocTest<DriverSearchBloc, DriverSearchState>(
    'emits [isLoading true, isLoading false with driverSearch] on LoadDriverSearchEvent',
    build: () {
      when(() => mockGetDriverSearchUseCase()).thenAnswer((_) async => tEntity);
      return bloc;
    },
    act: (DriverSearchBloc b) => b.add(const LoadDriverSearchEvent()),
    expect: () => [
      isA<DriverSearchState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<DriverSearchState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.driverSearch, 'driverSearch', tEntity),
    ],
  );

  blocTest<DriverSearchBloc, DriverSearchState>(
    'emits isCancelled true on CancelDriverSearchEvent',
    build: () => bloc,
    act: (DriverSearchBloc b) => b.add(const CancelDriverSearchEvent()),
    expect: () => [
      isA<DriverSearchState>()
          .having((s) => s.isCancelled, 'isCancelled', isTrue),
    ],
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:wheels_user/features/home/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_bloc.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_event.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_state.dart';

class MockGetHomeDashboardUseCase extends Mock
    implements GetHomeDashboardUseCase {}

void main() {
  late HomeBloc homeBloc;
  late MockGetHomeDashboardUseCase mockGetHomeDashboardUseCase;

  setUp(() {
    mockGetHomeDashboardUseCase = MockGetHomeDashboardUseCase();
    homeBloc = HomeBloc(getHomeDashboardUseCase: mockGetHomeDashboardUseCase);
  });

  tearDown(() {
    homeBloc.close();
  });

  const tEntity = HomeDashboardEntity(
    userName: 'JW',
    greetingTitle: 'Good Morning 👋',
    greetingSubtitle: 'Siri, ready for your next ride?',
    recentRideTitle: 'Office ➔ Home',
    recentRideDetails: 'Yesterday • Bike • ₹185',
  );

  test('initial state should be HomeState with isLoading true', () {
    expect(homeBloc.state.isLoading, isTrue);
  });

  blocTest<HomeBloc, HomeState>(
    'emits [isLoading: true, HomeState with entity] when LoadHomeDashboardEvent succeeds',
    build: () {
      when(() => mockGetHomeDashboardUseCase())
          .thenAnswer((_) async => tEntity);
      return homeBloc;
    },
    act: (bloc) => bloc.add(const LoadHomeDashboardEvent()),
    expect: () => [
      isA<HomeState>().having((s) => s.isLoading, 'isLoading', isTrue),
      isA<HomeState>()
          .having((s) => s.isLoading, 'isLoading', isFalse)
          .having((s) => s.dashboardEntity, 'dashboardEntity', equals(tEntity)),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with updated selectedNavIndex when ChangeNavTabEvent is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const ChangeNavTabEvent(2)),
    expect: () => [
      isA<HomeState>().having((s) => s.selectedNavIndex, 'selectedNavIndex', equals(2)),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with selectedService when SelectQuickServiceEvent is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const SelectQuickServiceEvent('Auto')),
    expect: () => [
      isA<HomeState>().having((s) => s.selectedService, 'selectedService', equals('Auto')),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with claimedOfferMessage when ClaimOfferEvent is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const ClaimOfferEvent('FLY30')),
    expect: () => [
      isA<HomeState>().having((s) => s.claimedOfferMessage, 'claimedOfferMessage', contains('FLY30')),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with repeat ride info when RepeatRideEvent is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const RepeatRideEvent()),
    expect: () => [
      isA<HomeState>().having((s) => s.selectedService, 'selectedService', contains('Repeat')),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with searchQuery when SearchQueryChangedEvent is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const SearchQueryChangedEvent('Airport')),
    expect: () => [
      isA<HomeState>().having((s) => s.searchQuery, 'searchQuery', equals('Airport')),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with actionMessage when SearchSubmittedEvent is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const SearchSubmittedEvent('Hyderabad')),
    expect: () => [
      isA<HomeState>().having((s) => s.actionMessage, 'actionMessage', contains('Hyderabad')),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with actionMessage when OpenMenuEvent is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const OpenMenuEvent()),
    expect: () => [
      isA<HomeState>().having((s) => s.actionMessage, 'actionMessage', contains('Menu')),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with actionMessage when OpenMicEvent is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const OpenMicEvent()),
    expect: () => [
      isA<HomeState>().having((s) => s.actionMessage, 'actionMessage', contains('Voice')),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with actionMessage when OpenNotificationsEvent is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const OpenNotificationsEvent()),
    expect: () => [
      isA<HomeState>().having((s) => s.actionMessage, 'actionMessage', contains('Notifications')),
    ],
  );

  blocTest<HomeBloc, HomeState>(
    'emits state with actionMessage when OpenProfileEvent is added',
    build: () => homeBloc,
    act: (bloc) => bloc.add(const OpenProfileEvent()),
    expect: () => [
      isA<HomeState>().having((s) => s.actionMessage, 'actionMessage', contains('profile')),
    ],
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/earnings/domain/entities/earnings_entity.dart';
import 'package:wheels_rider/features/earnings/domain/usecases/get_earnings_usecase.dart';
import 'package:wheels_rider/features/earnings/presentation/bloc/earnings_bloc.dart';
import 'package:wheels_rider/features/earnings/presentation/bloc/earnings_event.dart';
import 'package:wheels_rider/features/earnings/presentation/bloc/earnings_state.dart';

class MockGetEarningsUseCase extends Mock implements GetEarningsUseCase {}

void main() {
  late EarningsBloc bloc;
  late MockGetEarningsUseCase mockGetEarningsUseCase;

  setUp(() {
    mockGetEarningsUseCase = MockGetEarningsUseCase();
    bloc = EarningsBloc(getEarningsUseCase: mockGetEarningsUseCase);
  });

  final tEntity = EarningsEntity(
    totalEarnings: 1000.0,
    trips: 10,
    hours: 20.0,
    rating: 4.8,
    recentActivities: [],
  );

  test('initial state should be EarningsInitial', () {
    expect(bloc.state, isA<EarningsInitial>());
  });

  blocTest<EarningsBloc, EarningsState>(
    'should emit [EarningsLoading, EarningsLoaded] when success',
    build: () {
      when(() => mockGetEarningsUseCase(50, 0)).thenAnswer((_) async => tEntity);
      return bloc;
    },
    act: (bloc) => bloc.add(GetEarningsEvent()),
    expect: () => [
      isA<EarningsLoading>(),
      isA<EarningsLoaded>().having((s) => s.earnings, 'earnings', tEntity),
    ],
  );

  blocTest<EarningsBloc, EarningsState>(
    'should emit [EarningsLoading, EarningsError] when fails',
    build: () {
      when(() => mockGetEarningsUseCase(50, 0)).thenThrow(Exception('Error!'));
      return bloc;
    },
    act: (bloc) => bloc.add(GetEarningsEvent()),
    expect: () => [
      isA<EarningsLoading>(),
      isA<EarningsError>().having((s) => s.message, 'message', 'Exception: Error!'),
    ],
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/earnings/domain/entities/earnings_entity.dart';
import 'package:wheels_rider/features/earnings/domain/repositories/earnings_repository.dart';
import 'package:wheels_rider/features/earnings/domain/usecases/get_earnings_usecase.dart';

class MockEarningsRepository extends Mock implements EarningsRepository {}

void main() {
  late GetEarningsUseCase usecase;
  late MockEarningsRepository mockRepository;

  setUp(() {
    mockRepository = MockEarningsRepository();
    usecase = GetEarningsUseCase(mockRepository);
  });

  final tEntity = EarningsEntity(
    totalEarnings: 1000.0,
    trips: 10,
    hours: 20.0,
    rating: 4.8,
    recentActivities: [],
  );

  test('should get earnings from repository', () async {
    when(() => mockRepository.getEarnings(50, 0)).thenAnswer((_) async => tEntity);

    final result = await usecase(50, 0);

    expect(result, equals(tEntity));
    verify(() => mockRepository.getEarnings(50, 0)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

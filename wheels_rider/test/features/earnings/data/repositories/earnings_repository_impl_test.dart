import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/earnings/data/datasources/earnings_remote_data_source.dart';
import 'package:wheels_rider/features/earnings/data/models/earnings_model.dart';
import 'package:wheels_rider/features/earnings/data/repositories/earnings_repository_impl.dart';

class MockEarningsRemoteDataSource extends Mock implements EarningsRemoteDataSource {}

void main() {
  late EarningsRepositoryImpl repository;
  late MockEarningsRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockEarningsRemoteDataSource();
    repository = EarningsRepositoryImpl(mockRemoteDataSource);
  });

  final tModel = EarningsModel(
    totalEarnings: 1000.0,
    trips: 10,
    hours: 20.0,
    rating: 4.8,
    recentActivities: [],
  );

  test('should return EarningsEntity when success', () async {
    when(() => mockRemoteDataSource.getEarnings(50, 0)).thenAnswer((_) async => tModel);

    final result = await repository.getEarnings(50, 0);

    expect(result.totalEarnings, equals(1000.0));
    verify(() => mockRemoteDataSource.getEarnings(50, 0)).called(1);
  });

  test('should throw exception when fail', () async {
    when(() => mockRemoteDataSource.getEarnings(50, 0)).thenThrow(Exception('Error'));

    expect(() => repository.getEarnings(50, 0), throwsA(isA<Exception>()));
  });
}

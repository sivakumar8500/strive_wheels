import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/splash/data/datasources/splash_local_datasource.dart';
import 'package:wheels_rider/features/splash/data/repositories/splash_repository_impl.dart';

class MockSplashLocalDataSource extends Mock implements SplashLocalDataSource {}

void main() {
  late SplashRepositoryImpl repository;
  late MockSplashLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockSplashLocalDataSource();
    repository = SplashRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test('should return true when data source returns true', () async {
    when(
      () => mockLocalDataSource.isAuthenticated(),
    ).thenAnswer((_) async => true);

    final result = await repository.isUserAuthenticated();

    expect(result, isTrue);
    verify(() => mockLocalDataSource.isAuthenticated()).called(1);
  });

  test('should return false when data source returns false', () async {
    when(
      () => mockLocalDataSource.isAuthenticated(),
    ).thenAnswer((_) async => false);

    final result = await repository.isUserAuthenticated();

    expect(result, isFalse);
    verify(() => mockLocalDataSource.isAuthenticated()).called(1);
  });
}

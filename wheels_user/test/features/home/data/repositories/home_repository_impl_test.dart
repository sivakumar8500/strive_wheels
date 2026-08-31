import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/home/data/datasources/home_local_datasource.dart';
import 'package:wheels_user/features/home/data/models/home_dashboard_model.dart';
import 'package:wheels_user/features/home/data/repositories/home_repository_impl.dart';

import 'package:wheels_user/features/home/data/datasources/home_remote_data_source.dart';

class MockHomeLocalDataSource extends Mock implements HomeLocalDataSource {}
class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

void main() {
  late HomeRepositoryImpl repository;
  late MockHomeLocalDataSource mockLocalDataSource;
  late MockHomeRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockHomeLocalDataSource();
    mockRemoteDataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  const tModel = HomeDashboardModel(
    userName: 'JW',
    greetingTitle: 'Good Morning 👋',
    greetingSubtitle: 'Siri, ready for your next ride?',
    recentRideTitle: 'Office ➔ Home',
    recentRideDetails: 'Yesterday • Bike • ₹185',
  );

  test('should return HomeDashboardEntity when local data source succeeds', () async {
    // arrange
    when(() => mockLocalDataSource.getHomeDashboardData())
        .thenAnswer((_) async => tModel);
    when(() => mockRemoteDataSource.getQuickServices())
        .thenAnswer((_) async => []);
    when(() => mockRemoteDataSource.getPopularLocations())
        .thenAnswer((_) async => []);
    when(() => mockRemoteDataSource.getActiveCoupons())
        .thenAnswer((_) async => []);

    // act
    final result = await repository.getHomeDashboard();

    // assert
    expect(result.userName, equals('JW'));
    expect(result.greetingTitle, equals('Good Morning 👋'));
    verify(() => mockLocalDataSource.getHomeDashboardData()).called(1);
    verifyNoMoreInteractions(mockLocalDataSource);
  });
}

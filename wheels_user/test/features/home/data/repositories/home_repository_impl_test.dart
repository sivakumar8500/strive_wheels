import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/home/data/datasources/home_local_datasource.dart';
import 'package:wheels_user/features/home/data/models/home_dashboard_model.dart';
import 'package:wheels_user/features/home/data/repositories/home_repository_impl.dart';

class MockHomeLocalDataSource extends Mock implements HomeLocalDataSource {}

void main() {
  late HomeRepositoryImpl repository;
  late MockHomeLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockHomeLocalDataSource();
    repository = HomeRepositoryImpl(localDataSource: mockLocalDataSource);
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

    // act
    final result = await repository.getHomeDashboard();

    // assert
    expect(result.userName, equals('JW'));
    expect(result.greetingTitle, equals('Good Morning 👋'));
    verify(() => mockLocalDataSource.getHomeDashboardData()).called(1);
    verifyNoMoreInteractions(mockLocalDataSource);
  });
}

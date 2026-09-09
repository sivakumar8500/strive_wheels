import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/driver_search/data/datasources/driver_search_local_datasource.dart';
import 'package:wheels_user/features/driver_search/data/models/driver_search_model.dart';
import 'package:wheels_user/features/driver_search/data/repositories/driver_search_repository_impl.dart';

class MockDriverSearchLocalDataSource extends Mock
    implements DriverSearchLocalDataSource {}

void main() {
  late DriverSearchRepositoryImpl repository;
  late MockDriverSearchLocalDataSource mockLocalDataSource;

  const tModel = DriverSearchModel(
    statusTitle: 'Searching for nearby drivers...',
    statusSubtitle: 'Connecting you to the nearest premium vehicle.',
    estimatedConfirmationText: '5 - 30 mins',
    orderTime: '10:42 AM',
    scanRadiusText: 'Scanning 1.2km radius...',
    activeStepIndex: 1,
  );

  setUp(() {
    mockLocalDataSource = MockDriverSearchLocalDataSource();
    repository = DriverSearchRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test('should return DriverSearchEntity when localDataSource succeeds',
      () async {
    when(() => mockLocalDataSource.getDriverSearchDetails())
        .thenAnswer((_) async => tModel);

    final result = await repository.getDriverSearchDetails();

    expect(result.statusTitle, 'Searching for nearby drivers...');
    verify(() => mockLocalDataSource.getDriverSearchDetails()).called(1);
  });
}

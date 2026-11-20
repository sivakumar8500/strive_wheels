import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/history/data/datasources/ride_history_local_datasource.dart';
import 'package:wheels_user/features/history/data/models/past_ride_item_model.dart';
import 'package:wheels_user/features/history/data/models/ride_history_model.dart';
import 'package:wheels_user/features/history/data/repositories/ride_history_repository_impl.dart';

class MockRideHistoryLocalDataSource extends Mock
    implements RideHistoryLocalDataSource {}

void main() {
  late RideHistoryRepositoryImpl repository;
  late MockRideHistoryLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockRideHistoryLocalDataSource();
    repository =
        RideHistoryRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  const tModel = RideHistoryModel(
    monthlySummaryTitle: 'June ride summary',
    tripCountText: '12 trips',
    distanceText: '184 km this month',
    spentText: '₹2,486 spent',
    pastRides: [
      PastRideItemModel(
        id: '1',
        title: 'Mindspace IT Park ➔ Home',
        dateAndVehicle: 'Yesterday · 6:42 PM · Bike',
        status: 'Completed',
        amount: '₹185',
        serviceType: 'Bike',
      ),
    ],
  );

  test('should return RideHistoryEntity when local data source succeeds',
      () async {
    // arrange
    when(() => mockLocalDataSource.getRideHistoryData())
        .thenAnswer((_) async => tModel);

    // act
    final result = await repository.getRideHistory();

    // assert
    expect(result.monthlySummaryTitle, equals('June ride summary'));
    expect(result.pastRides.length, equals(1));
    expect(result.pastRides.first.title, equals('Mindspace IT Park ➔ Home'));
    verify(() => mockLocalDataSource.getRideHistoryData()).called(1);
    verifyNoMoreInteractions(mockLocalDataSource);
  });
}

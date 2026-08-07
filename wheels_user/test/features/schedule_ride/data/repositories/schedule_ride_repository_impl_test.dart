import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/schedule_ride/data/datasources/schedule_ride_local_datasource.dart';
import 'package:wheels_user/features/schedule_ride/data/models/schedule_ride_model.dart';
import 'package:wheels_user/features/schedule_ride/data/repositories/schedule_ride_repository_impl.dart';

class MockScheduleRideLocalDataSource extends Mock
    implements ScheduleRideLocalDataSource {}

void main() {
  late ScheduleRideRepositoryImpl repository;
  late MockScheduleRideLocalDataSource mockLocalDataSource;

  const tModel = ScheduleRideModel(
    pickupPoint: 'Harrods, 87–135 Brompton Rd',
    destination: 'The Ritz London, 150 Piccadilly',
    distanceKm: 18.2,
    durationMins: 42,
    fareAmount: 24.50,
    currencySymbol: '£',
    selectedDate: 'Fri 24',
    selectedTime: '10 : 45',
    isAm: true,
    instantNotification: true,
    checklistItems: ['Driver beta'],
  );

  setUp(() {
    mockLocalDataSource = MockScheduleRideLocalDataSource();
    repository = ScheduleRideRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  test('should return ScheduleRideEntity when localDataSource returns model',
      () async {
    when(() => mockLocalDataSource.getScheduleRideDetails())
        .thenAnswer((_) async => tModel);

    final result = await repository.getScheduleRideDetails();

    expect(result.pickupPoint, 'Harrods, 87–135 Brompton Rd');
    verify(() => mockLocalDataSource.getScheduleRideDetails()).called(1);
  });
}

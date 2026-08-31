import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/home/data/datasources/home_remote_data_source.dart';
import 'package:wheels_rider/features/home/data/repositories/home_repository_impl.dart';

class MockHomeRemoteDataSource extends Mock implements HomeRemoteDataSource {}

void main() {
  late HomeRepositoryImpl repository;
  late MockHomeRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockHomeRemoteDataSource();
    repository = HomeRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('updateLocation', () {
    const double tLat = 12.34;
    const double tLng = 56.78;

    test('should call remote data source to update location', () async {
      // arrange
      when(() => mockRemoteDataSource.updateLocation(
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
          )).thenAnswer((_) async => Future.value());

      // act
      await repository.updateLocation(lat: tLat, lng: tLng);

      // assert
      verify(() => mockRemoteDataSource.updateLocation(
            lat: tLat,
            lng: tLng,
          )).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should throw an exception when the remote call fails', () async {
      // arrange
      when(() => mockRemoteDataSource.updateLocation(
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
          )).thenThrow(Exception('Server error'));

      // act
      final call = repository.updateLocation;

      // assert
      expect(() => call(lat: tLat, lng: tLng), throwsException);
    });
  });
}

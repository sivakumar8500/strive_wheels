import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:wheels_rider/features/profile/data/models/profile_model.dart';
import 'package:wheels_rider/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:wheels_rider/features/profile/domain/entities/profile_entity.dart';

class MockProfileRemoteDataSource extends Mock implements ProfileRemoteDataSource {}

void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(mockRemoteDataSource);
  });

  const tProfileModel = ProfileModel(id: 1, rating: 4.98, totalEarnings: 0.0, walletBalance: 0.0, user: {'full_name': 'Alex', 'profile_image_url': 'url', 'phone': '1234567890', 'email': 'test@test.com', 'dob': '1990-01-01', 'gender': 'Male'});

  const tProfileEntity = ProfileEntity(id: 1, name: 'Alex', rating: 4.98, profileImageUrl: 'url', totalEarnings: 0.0, walletBalance: 0.0, phone: '1234567890', email: 'test@test.com', dob: '1990-01-01', gender: 'Male');

  test('should return ProfileEntity on getProfile success', () async {
    when(() => mockRemoteDataSource.getProfile()).thenAnswer((_) async => tProfileModel);

    final result = await repository.getProfile();

    expect(result, equals(tProfileEntity));
    verify(() => mockRemoteDataSource.getProfile());
    verifyNoMoreInteractions(mockRemoteDataSource);
  });

  test('should throw Exception on getProfile failure', () async {
    when(() => mockRemoteDataSource.getProfile()).thenThrow(Exception('Failed'));

    expect(() => repository.getProfile(), throwsException);
    verify(() => mockRemoteDataSource.getProfile());
    verifyNoMoreInteractions(mockRemoteDataSource);
  });
}

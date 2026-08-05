import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_user/features/onboarding/data/datasources/onboarding_local_datasource.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late OnboardingLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = OnboardingLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('OnboardingLocalDataSource', () {
    test('should return true when key is null (first launch)', () async {
      when(() => mockSharedPreferences.getBool(any()))
          .thenReturn(null);

      final result = await dataSource.isFirstTime();

      expect(result, isTrue);
      verify(() => mockSharedPreferences.getBool('is_first_time_launch'))
          .called(1);
    });

    test('should return false when set to false', () async {
      when(() => mockSharedPreferences.getBool(any()))
          .thenReturn(false);

      final result = await dataSource.isFirstTime();

      expect(result, isFalse);
    });

    test('should set key to false on setFirstTimeCompleted', () async {
      when(() => mockSharedPreferences.setBool(any(), any()))
          .thenAnswer((_) async => true);

      await dataSource.setFirstTimeCompleted();

      verify(() => mockSharedPreferences.setBool('is_first_time_launch', false))
          .called(1);
    });
  });
}

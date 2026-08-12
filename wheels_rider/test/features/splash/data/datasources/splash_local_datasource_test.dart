import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_rider/features/splash/data/datasources/splash_local_datasource.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SplashLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = SplashLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  test('should return true when shared_preferences has true', () async {
    when(
      () => mockSharedPreferences.getBool('is_authenticated'),
    ).thenReturn(true);

    final result = await dataSource.isAuthenticated();

    expect(result, isTrue);
  });

  test(
    'should return false when shared_preferences has false or null',
    () async {
      when(
        () => mockSharedPreferences.getBool('is_authenticated'),
      ).thenReturn(null);

      final result = await dataSource.isAuthenticated();

      expect(result, isFalse);
    },
  );
}

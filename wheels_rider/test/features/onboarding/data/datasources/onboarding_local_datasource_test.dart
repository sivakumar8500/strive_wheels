import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheels_rider/features/onboarding/data/datasources/onboarding_local_datasource.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late OnboardingLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = OnboardingLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  test('setOnboardingCompleted sets bool to true', () async {
    when(
      () => mockSharedPreferences.setBool('onboarding_completed', true),
    ).thenAnswer((_) async => true);

    await dataSource.setOnboardingCompleted();

    verify(
      () => mockSharedPreferences.setBool('onboarding_completed', true),
    ).called(1);
  });

  test('isOnboardingCompleted returns stored bool value', () async {
    when(
      () => mockSharedPreferences.getBool('onboarding_completed'),
    ).thenReturn(true);

    final result = await dataSource.isOnboardingCompleted();

    expect(result, isTrue);
  });
}

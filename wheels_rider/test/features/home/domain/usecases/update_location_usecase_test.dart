import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/home/domain/repositories/home_repository.dart';
import 'package:wheels_rider/features/home/domain/usecases/update_location_usecase.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late UpdateLocationUseCase usecase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    usecase = UpdateLocationUseCase(mockHomeRepository);
  });

  const double tLat = 12.34;
  const double tLng = 56.78;

  test('should update location via the repository', () async {
    // arrange
    when(() => mockHomeRepository.updateLocation(
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
        )).thenAnswer((_) async => Future.value());

    // act
    await usecase(tLat, tLng);

    // assert
    verify(() => mockHomeRepository.updateLocation(lat: tLat, lng: tLng)).called(1);
    verifyNoMoreInteractions(mockHomeRepository);
  });
}

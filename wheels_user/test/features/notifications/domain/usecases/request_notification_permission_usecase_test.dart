import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/notifications/domain/entities/notification_permission_entity.dart';
import 'package:wheels_user/features/notifications/domain/repositories/notification_repository.dart';
import 'package:wheels_user/features/notifications/domain/usecases/request_notification_permission_usecase.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late RequestNotificationPermissionUseCase useCase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    useCase = RequestNotificationPermissionUseCase(mockRepository);
  });

  const tEntity = NotificationPermissionEntity(isEnabled: true);

  test('should call repository.setPermissionStatus with correct entity', () async {
    when(() => mockRepository.setPermissionStatus(tEntity))
        .thenAnswer((_) async => true);

    final result = await useCase(tEntity);

    expect(result, isTrue);
    verify(() => mockRepository.setPermissionStatus(tEntity)).called(1);
  });
}

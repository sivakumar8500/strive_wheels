import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/notifications/domain/repositories/notification_repository.dart';
import 'package:wheels_user/features/notifications/domain/usecases/get_unread_count_usecase.dart';

class MockNotificationRepository extends Mock implements NotificationRepository {}

void main() {
  late GetUnreadCountUseCase useCase;
  late MockNotificationRepository mockRepository;

  setUp(() {
    mockRepository = MockNotificationRepository();
    useCase = GetUnreadCountUseCase(mockRepository);
  });

  test('GetUnreadCountUseCase retrieves count from repository', () async {
    when(() => mockRepository.getUnreadCount()).thenAnswer((_) async => 4);

    final result = await useCase();

    expect(result, 4);
    verify(() => mockRepository.getUnreadCount()).called(1);
  });
}

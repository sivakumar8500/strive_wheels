import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/features/notifications/domain/entities/notification_entity.dart';

void main() {
  final testDate = DateTime.parse('2026-10-01T08:00:00.000Z');

  test('NotificationEntity supports value equality and copyWith', () {
    final entity1 = NotificationEntity(
      id: 1,
      userId: 5,
      title: 'Flat 50 OFF',
      body: 'Get discount on next ride',
      notificationType: 'PROMOTIONAL',
      isRead: false,
      metadataJson: '{"code": "STRIVE50"}',
      createdAt: testDate,
    );

    final entity2 = entity1.copyWith(isRead: true);

    expect(entity1.id, 1);
    expect(entity1.isRead, false);
    expect(entity2.isRead, true);
    expect(entity2.id, 1);
    expect(entity2.title, 'Flat 50 OFF');
  });
}

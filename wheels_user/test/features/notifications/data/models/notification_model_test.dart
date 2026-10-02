import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/features/notifications/data/models/notification_model.dart';
import 'package:wheels_user/features/notifications/domain/entities/notification_entity.dart';

void main() {
  final testDate = DateTime.parse('2026-10-01T08:00:00.000Z');
  final testModel = NotificationModel(
    id: 1,
    userId: 10,
    title: 'Flat ₹50 OFF on Your Next 3 Rides',
    body: 'Welcome to StriveWheels!',
    notificationType: 'PROMOTIONAL',
    isRead: false,
    metadataJson: '{"code": "STRIVE50"}',
    createdAt: testDate,
  );

  final testJson = {
    'id': 1,
    'user_id': 10,
    'title': 'Flat ₹50 OFF on Your Next 3 Rides',
    'body': 'Welcome to StriveWheels!',
    'notification_type': 'PROMOTIONAL',
    'is_read': false,
    'metadata_json': '{"code": "STRIVE50"}',
    'created_at': '2026-10-01T08:00:00.000Z',
  };

  group('NotificationModel Tests', () {
    test('fromJson should create valid model from JSON map', () {
      final model = NotificationModel.fromJson(testJson);
      expect(model.id, 1);
      expect(model.userId, 10);
      expect(model.title, 'Flat ₹50 OFF on Your Next 3 Rides');
      expect(model.notificationType, 'PROMOTIONAL');
      expect(model.isRead, false);
    });

    test('toJson should output correct map representation', () {
      final json = testModel.toJson();
      expect(json['id'], 1);
      expect(json['title'], 'Flat ₹50 OFF on Your Next 3 Rides');
      expect(json['is_read'], false);
    });

    test('toEntity should map model to domain entity accurately', () {
      final entity = testModel.toEntity();
      expect(entity, isA<NotificationEntity>());
      expect(entity.id, 1);
      expect(entity.title, 'Flat ₹50 OFF on Your Next 3 Rides');
      expect(entity.notificationType, 'PROMOTIONAL');
    });
  });
}

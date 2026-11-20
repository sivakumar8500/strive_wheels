import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/features/notifications/data/models/notification_model.dart';
import 'package:wheels_rider/features/notifications/domain/entities/notification_entity.dart';

void main() {
  final testDate = DateTime.parse('2026-10-01T08:00:00.000Z');
  final testModel = NotificationModel(
    id: 1,
    userId: 10,
    title: 'Weekend Surge Bonus',
    body: 'Earn 20% extra during peak hours',
    notificationType: 'PROMOTIONAL',
    isRead: false,
    metadataJson: '{"promo_code": "SURGE20"}',
    createdAt: testDate,
  );

  final testJson = {
    'id': 1,
    'user_id': 10,
    'title': 'Weekend Surge Bonus',
    'body': 'Earn 20% extra during peak hours',
    'notification_type': 'PROMOTIONAL',
    'is_read': false,
    'metadata_json': '{"promo_code": "SURGE20"}',
    'created_at': '2026-10-01T08:00:00.000Z',
  };

  group('NotificationModel Tests', () {
    test('fromJson should create valid model from JSON map', () {
      final model = NotificationModel.fromJson(testJson);
      expect(model.id, 1);
      expect(model.userId, 10);
      expect(model.title, 'Weekend Surge Bonus');
      expect(model.notificationType, 'PROMOTIONAL');
      expect(model.isRead, false);
    });

    test('toJson should output correct map representation', () {
      final json = testModel.toJson();
      expect(json['id'], 1);
      expect(json['title'], 'Weekend Surge Bonus');
      expect(json['is_read'], false);
    });

    test('toEntity should map model to domain entity accurately', () {
      final entity = testModel.toEntity();
      expect(entity, isA<NotificationEntity>());
      expect(entity.id, 1);
      expect(entity.title, 'Weekend Surge Bonus');
      expect(entity.notificationType, 'PROMOTIONAL');
    });
  });
}

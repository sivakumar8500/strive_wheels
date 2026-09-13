import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/features/chat/data/models/chat_message_model.dart';
import 'package:wheels_user/features/chat/domain/entities/chat_message_entity.dart';

void main() {
  group('ChatMessageModel', () {
    const tJson = {
      'id': 1,
      'booking_id': 104,
      'sender_id': 15,
      'sender_role': 'CUSTOMER',
      'message': 'Hi driver, I am waiting near Gate 2.',
      'sent_at': '2026-09-13T00:10:00Z',
    };

    test('should parse JSON correctly into ChatMessageModel', () {
      final model = ChatMessageModel.fromJson(tJson);

      expect(model.id, 1);
      expect(model.bookingId, 104);
      expect(model.senderId, 15);
      expect(model.senderRole, 'CUSTOMER');
      expect(model.message, 'Hi driver, I am waiting near Gate 2.');
      expect(model.sentAt, '2026-09-13T00:10:00Z');
    });

    test('should convert ChatMessageModel to ChatMessageEntity correctly', () {
      final model = ChatMessageModel.fromJson(tJson);
      final entity = model.toEntity();

      expect(entity, isA<ChatMessageEntity>());
      expect(entity.id, 1);
      expect(entity.bookingId, 104);
      expect(entity.senderId, 15);
      expect(entity.senderRole, 'CUSTOMER');
      expect(entity.message, 'Hi driver, I am waiting near Gate 2.');
      expect(entity.sentAt, DateTime.parse('2026-09-13T00:10:00Z'));
      expect(entity.isSentByMe(15), isTrue);
      expect(entity.isSentByMe(8), isFalse);
    });

    test('should fallback to defaults when json contains null values', () {
      final model = ChatMessageModel.fromJson({});
      expect(model.id, 0);
      expect(model.bookingId, 0);
      expect(model.senderId, 0);
      expect(model.senderRole, 'CUSTOMER');
      expect(model.message, '');
      expect(model.sentAt, isNull);

      final entity = model.toEntity();
      expect(entity.sentAt, isNotNull);
    });
  });
}

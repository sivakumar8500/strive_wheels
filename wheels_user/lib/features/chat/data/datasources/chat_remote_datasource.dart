import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/customer_ws_controller.dart';
import '../../../../core/network/websocket_service.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatMessageModel>> getChatHistory(int bookingId);
  Future<ChatMessageModel?> sendMessageHttp(int bookingId, String message);
  void sendMessageWs(int bookingId, String message);
  Stream<Map<String, dynamic>> listenChatEvents(int bookingId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;
  final CustomerWSController customerWSController;
  final WebSocketService webSocketService;

  ChatRemoteDataSourceImpl({
    required this.dio,
    required this.customerWSController,
    required this.webSocketService,
  });

  @override
  Future<List<ChatMessageModel>> getChatHistory(int bookingId) async {
    try {
      final response = await dio.get('/api/v1/bookings/$bookingId/chat');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        List<dynamic> list = [];
        if (data is Map<String, dynamic>) {
          if (data['data'] is List) {
            list = data['data'] as List;
          }
        } else if (data is List) {
          list = data;
        }
        return list.map((item) => ChatMessageModel.fromJson(item as Map<String, dynamic>)).toList();
      }
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final resData = e.response!.data as Map<String, dynamic>;
        final msg = resData['message']?.toString();
        if (msg != null && (msg.contains('closed') || msg.contains('CANCELLED'))) {
          throw Exception(msg);
        }
      }
      debugPrint('[ChatRemoteDataSource] Error fetching chat history: $e');
    } catch (e) {
      debugPrint('[ChatRemoteDataSource] Error fetching chat history: $e');
    }
    return [];
  }

  @override
  Future<ChatMessageModel?> sendMessageHttp(int bookingId, String message) async {
    try {
      final response = await dio.post(
        '/api/v1/bookings/$bookingId/chat',
        data: {'message': message},
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] != null) {
          return ChatMessageModel.fromJson(data['data'] as Map<String, dynamic>);
        }
      }
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final resData = e.response!.data as Map<String, dynamic>;
        final msg = resData['message']?.toString();
        if (msg != null && (msg.contains('closed') || msg.contains('CANCELLED'))) {
          throw Exception(msg);
        }
      }
      debugPrint('[ChatRemoteDataSource] Error sending message via HTTP: $e');
    } catch (e) {
      debugPrint('[ChatRemoteDataSource] Error sending message via HTTP: $e');
    }
    return null;
  }

  @override
  void sendMessageWs(int bookingId, String message) {
    try {
      webSocketService.send('booking.chat_message', {
        'booking_id': bookingId,
        'message': message,
      });
    } catch (e) {
      debugPrint('[ChatRemoteDataSource] Error sending message via WS: $e');
    }
  }

  @override
  Stream<Map<String, dynamic>> listenChatEvents(int bookingId) {
    return customerWSController.bookingEventStream.where((eventMap) {
      final event = eventMap['event'] as String?;
      final data = eventMap['data'] as Map<String, dynamic>? ?? {};
      if (event == 'booking.chat_message' ||
          event == 'booking.chat_closed' ||
          event == 'booking.cancelled' ||
          event == 'booking.rider_cancelled') {
        final bId = data['booking_id'];
        return bId == null || bId == bookingId || bId.toString() == bookingId.toString();
      }
      return false;
    });
  }
}

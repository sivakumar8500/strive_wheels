import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/websocket_client.dart';
import '../models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatMessageModel>> getChatHistory(int bookingId);
  Future<ChatMessageModel?> sendMessageHttp(int bookingId, String message);
  void sendMessageWs(int bookingId, String message);
  Stream<Map<String, dynamic>> listenChatEvents(int bookingId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;
  final WebSocketClient webSocketClient;

  ChatRemoteDataSourceImpl({
    required this.dio,
    required this.webSocketClient,
  });

  @override
  Future<List<ChatMessageModel>> getChatHistory(int bookingId) async {
    try {
      final response = await dio.get('http://15.252.129.37:8200/api/v1/bookings/$bookingId/chat');
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
      debugPrint('[RiderChatRemoteDataSource] Error fetching chat history: $e');
    } catch (e) {
      debugPrint('[RiderChatRemoteDataSource] Error fetching chat history: $e');
    }
    return [];
  }

  @override
  Future<ChatMessageModel?> sendMessageHttp(int bookingId, String message) async {
    try {
      final response = await dio.post(
        'http://15.252.129.37:8200/api/v1/bookings/$bookingId/chat',
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
      debugPrint('[RiderChatRemoteDataSource] Error sending message via HTTP: $e');
    } catch (e) {
      debugPrint('[RiderChatRemoteDataSource] Error sending message via HTTP: $e');
    }
    return null;
  }

  @override
  void sendMessageWs(int bookingId, String message) {
    try {
      webSocketClient.sendMessage({
        'event': 'booking.chat_message',
        'data': {
          'booking_id': bookingId,
          'message': message,
        },
      });
    } catch (e) {
      debugPrint('[RiderChatRemoteDataSource] Error sending message via WS: $e');
    }
  }

  @override
  Stream<Map<String, dynamic>> listenChatEvents(int bookingId) {
    return webSocketClient.messageStream.where((eventMap) {
      final event = eventMap['event'] as String?;
      final data = (eventMap['data'] is Map)
          ? Map<String, dynamic>.from(eventMap['data'] as Map)
          : eventMap;
      if (event == 'booking.chat_message' ||
          event == 'booking.chat_closed' ||
          event == 'booking.cancelled' ||
          event == 'booking.customer_cancelled' ||
          event == 'booking.rider_cancelled') {
        final bId = data['booking_id'] ?? data['bookingId'];
        return bId == null || bId == bookingId || bId.toString() == bookingId.toString();
      }
      return false;
    });
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

import 'api_endpoints.dart';

class WebSocketClient {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void connect(String token) {
    if (_isConnected) return;

    try {
      final uri = Uri.parse('${ApiEndpoints.wsConnect}?token=$token');
      _channel = WebSocketChannel.connect(uri);
      
      _isConnected = true;
      _subscription = _channel?.stream.listen(
        (message) {
          try {
            final decoded = jsonDecode(message);
            _messageController.add(decoded);
          } catch (e) {
            debugPrint('WebSocket message decode error: $e');
          }
        },
        onDone: () {
          _isConnected = false;
          debugPrint('WebSocket closed');
        },
        onError: (error) {
          _isConnected = false;
          debugPrint('WebSocket error: $error');
        },
      );
    } catch (e) {
      _isConnected = false;
      debugPrint('WebSocket connection failed: $e');
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(jsonEncode(message));
    } else {
      debugPrint('Cannot send message. WebSocket is not connected.');
    }
  }

  void disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    _isConnected = false;
  }
}

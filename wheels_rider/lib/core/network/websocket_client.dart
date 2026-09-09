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

  void connect(int driverId, String token) {
    if (_isConnected) return;

    try {
      var cleanToken = token.trim();
      if (cleanToken.endsWith('#')) {
        cleanToken = cleanToken.substring(0, cleanToken.length - 1);
      }
      if (cleanToken.isEmpty) {
        cleanToken = 'demo_token';
      }
      final encodedToken = Uri.encodeComponent(cleanToken);
      var rawUrl = '${ApiEndpoints.wsDriverConnect(driverId)}?token=$encodedToken';
      if (rawUrl.startsWith('http://')) {
        rawUrl = rawUrl.replaceFirst('http://', 'ws://');
      } else if (rawUrl.startsWith('https://')) {
        rawUrl = rawUrl.replaceFirst('https://', 'wss://');
      }
      final uri = Uri.parse(rawUrl);
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

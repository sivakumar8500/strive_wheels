import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'api_endpoints.dart';

class WebSocketClient {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  int? _currentCustomerId;
  String? _currentToken;
  int _reconnectAttempts = 0;
  bool _explicitlyDisconnected = false;

  void connect(int customerId, String token) {
    _currentCustomerId = customerId;
    _currentToken = token;
    _explicitlyDisconnected = false;
    if (_isConnected) {
      debugPrint('[WebSocket Customer] Connect requested but already connected.');
      return;
    }
    _establishConnection();
  }

  Future<void> _establishConnection() async {
    if (_currentCustomerId == null || _currentToken == null) return;

    final candidateUrls = [
      '${ApiEndpoints.wsCustomerConnect(_currentCustomerId!)}?token=$_currentToken',
      'ws://15.252.129.37:8200/ws/customer/$_currentCustomerId?token=$_currentToken',
      '${ApiEndpoints.wsConnect}?token=$_currentToken',
      'ws://15.252.129.37:8200/ws/v1/connect?token=$_currentToken',
    ];

    for (final url in candidateUrls) {
      if (_explicitlyDisconnected) return;
      try {
        final uri = Uri.parse(url);
        debugPrint('[WebSocket Customer] Attempting connection to $uri');
        final channel = WebSocketChannel.connect(uri);

        await channel.ready;

        _channel = channel;
        _isConnected = true;
        _reconnectAttempts = 0;
        debugPrint('[WebSocket Customer] Connection established successfully via $uri');
        _startPingHeartbeat();

        _subscription?.cancel();
        _subscription = _channel?.stream.listen(
          (message) {
            try {
              final decoded = jsonDecode(message) as Map<String, dynamic>;
              final eventName = decoded['event'] ?? 'unknown';
              debugPrint('[WebSocket Customer] Received Event: "$eventName" -> $decoded');
              _messageController.add(decoded);
            } catch (e) {
              debugPrint('[WebSocket Customer] Message decode error: $e | Raw: $message');
            }
          },
          onDone: () {
            debugPrint('[WebSocket Customer] Connection closed (onDone)');
            _handleDisconnect();
          },
          onError: (error) {
            debugPrint('[WebSocket Customer] Connection error: $error');
            _handleDisconnect();
          },
        );
        return; // Successfully connected!
      } catch (e) {
        debugPrint('[WebSocket Customer] Failed connection to $url: $e');
      }
    }

    debugPrint('[WebSocket Customer] All endpoint candidates failed to upgrade connection.');
    _handleDisconnect();
  }

  void _startPingHeartbeat() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 25), (timer) {
      if (_isConnected) {
        sendMessage({
          'event': 'ping',
          'data': {'timestamp': DateTime.now().millisecondsSinceEpoch}
        });
      }
    });
  }

  void _handleDisconnect() {
    _isConnected = false;
    _pingTimer?.cancel();

    if (!_explicitlyDisconnected && _currentCustomerId != null && _currentToken != null) {
      _reconnectAttempts++;
      final delaySeconds = (_reconnectAttempts * 2).clamp(2, 30);
      debugPrint('[WebSocket Customer] Unexpected disconnect. Reconnecting in ${delaySeconds}s (attempt $_reconnectAttempts)...');
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
        if (!_isConnected && !_explicitlyDisconnected) {
          _establishConnection();
        }
      });
    } else if (_explicitlyDisconnected) {
      debugPrint('[WebSocket Customer] Closed due to explicit disconnect.');
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      final payloadStr = jsonEncode(message);
      _channel!.sink.add(payloadStr);
      debugPrint('[WebSocket Customer] Sent Event: "${message['event']}" -> $message');
    } else {
      debugPrint('[WebSocket Customer] Cannot send message "${message['event']}". Socket is not connected.');
    }
  }

  void disconnect() {
    debugPrint('[WebSocket Customer] Explicit disconnect requested.');
    _explicitlyDisconnected = true;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close(status.normalClosure);
    _isConnected = false;
    _currentCustomerId = null;
    _currentToken = null;
  }
}

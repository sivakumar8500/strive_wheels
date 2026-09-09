import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  bool _isConnected = false;
  String? _currentUrl;
  int _reconnectAttempts = 0;

  Stream<Map<String, dynamic>> get eventStream => _eventController.stream;
  bool get isConnected => _isConnected;

  /// Connect to WebSocket Endpoint with JWT Token
  void connect(String baseUrl, int userId, String token, {required String role}) {
    var formattedBase = baseUrl.trim();
    if (formattedBase.startsWith('http://')) {
      formattedBase = formattedBase.replaceFirst('http://', 'ws://');
    } else if (formattedBase.startsWith('https://')) {
      formattedBase = formattedBase.replaceFirst('https://', 'wss://');
    } else if (!formattedBase.startsWith('ws://') && !formattedBase.startsWith('wss://')) {
      formattedBase = 'ws://$formattedBase';
    }

    final cleanBase = formattedBase.endsWith('/')
        ? formattedBase.substring(0, formattedBase.length - 1)
        : formattedBase;

    var cleanToken = token.trim();
    if (cleanToken.endsWith('#')) {
      cleanToken = cleanToken.substring(0, cleanToken.length - 1);
    }
    if (cleanToken.isEmpty) {
      cleanToken = 'demo_token';
    }
    final encodedToken = Uri.encodeComponent(cleanToken);

    final wsUrl = '$cleanBase/ws/$role/$userId?token=$encodedToken';
    _currentUrl = wsUrl;
    _establishConnection(wsUrl);
  }

  void _establishConnection(String url) {
    try {
      debugPrint('[WebSocket] Connecting to $url');
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;
      _reconnectAttempts = 0;

      _channel!.stream.listen(
        (data) {
          _handleIncomingData(data);
        },
        onError: (error) {
          debugPrint('[WebSocket] Error: $error');
          _handleDisconnect();
        },
        onDone: () {
          debugPrint('[WebSocket] Connection closed.');
          _handleDisconnect();
        },
      );

      _startPingHeartbeat();
    } catch (e) {
      debugPrint('[WebSocket] Connection failure: $e');
      _handleDisconnect();
    }
  }

  void _handleIncomingData(dynamic data) {
    try {
      final decoded = jsonDecode(data.toString()) as Map<String, dynamic>;
      debugPrint('[WebSocket] Received event: ${decoded['event']}');
      _eventController.add(decoded);
    } catch (e) {
      debugPrint('[WebSocket] Error parsing message: $e');
    }
  }

  /// Send event to WebSocket server
  void send(String event, Map<String, dynamic> data) {
    if (_isConnected && _channel != null) {
      final payload = jsonEncode({'event': event, 'data': data});
      _channel!.sink.add(payload);
      debugPrint('[WebSocket] Sent event: $event payload: $payload');
    } else {
      debugPrint('[WebSocket] Cannot send, not connected.');
    }
  }

  void _startPingHeartbeat() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 25), (timer) {
      if (_isConnected) {
        send('ping', {'timestamp': DateTime.now().millisecondsSinceEpoch});
      }
    });
  }

  void _handleDisconnect() {
    _isConnected = false;
    _pingTimer?.cancel();
    _channel?.sink.close(status.goingAway);

    // Auto-Reconnect with exponential backoff (max 30s)
    if (_currentUrl != null) {
      _reconnectAttempts++;
      final delaySeconds = (_reconnectAttempts * 2).clamp(2, 30);
      debugPrint('[WebSocket] Reconnecting in $delaySeconds seconds...');
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
        if (!_isConnected && _currentUrl != null) {
          _establishConnection(_currentUrl!);
        }
      });
    }
  }

  void disconnect() {
    _currentUrl = null;
    _isConnected = false;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.normalClosure);
  }
}

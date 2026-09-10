import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter/foundation.dart';

import 'api_endpoints.dart';
import 'session_manager.dart';

class WebSocketClient {
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  SessionManager? _sessionManager;
  
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  int? _currentDriverId;
  String? _currentToken;
  int _reconnectAttempts = 0;
  bool _explicitlyDisconnected = false;

  void setSessionManager(SessionManager sessionManager) {
    _sessionManager = sessionManager;
  }

  void connect(int driverId, String token, {SessionManager? sessionManager}) {
    _currentDriverId = driverId;
    _currentToken = token;
    if (sessionManager != null) _sessionManager = sessionManager;
    _explicitlyDisconnected = false;
    if (_isConnected) {
      debugPrint('[WebSocket] Connect requested but already connected.');
      return;
    }
    _establishConnection();
  }

  Future<void> _establishConnection() async {
    if (_currentDriverId == null) return;

    if (_sessionManager != null) {
      final validToken = await _sessionManager!.getValidAccessToken();
      if (validToken != null && validToken.isNotEmpty) {
        _currentToken = validToken;
      }
    }

    if (_currentToken == null || _currentToken!.isEmpty) return;

    final candidateUrls = [
      '${ApiEndpoints.wsDriverConnect(_currentDriverId!)}?token=$_currentToken',
      'ws://15.252.129.37:8200/ws/driver/$_currentDriverId?token=$_currentToken',
      '${ApiEndpoints.wsConnect}?token=$_currentToken',
      'ws://15.252.129.37:8200/ws/v1/connect?token=$_currentToken',
    ];

    for (final url in candidateUrls) {
      if (_explicitlyDisconnected) return;
      try {
        final uri = Uri.parse(url);
        debugPrint('[WebSocket] Attempting connection to $uri');
        final channel = WebSocketChannel.connect(uri);

        await channel.ready;

        _channel = channel;
        _isConnected = true;
        _reconnectAttempts = 0;
        debugPrint('[WebSocket] Connection established successfully via $uri');
        _startPingHeartbeat();

        _subscription?.cancel();
        _subscription = _channel?.stream.listen(
          (message) {
            try {
              final decoded = jsonDecode(message) as Map<String, dynamic>;
              final eventName = decoded['event'] ?? 'unknown';
              debugPrint('[WebSocket] Received Event: "$eventName" -> $decoded');
              _messageController.add(decoded);
            } catch (e) {
              debugPrint('[WebSocket] Message decode error: $e | Raw: $message');
            }
          },
          onDone: () {
            final closeCode = _channel?.closeCode;
            debugPrint('[WebSocket] Connection closed (onDone). Code: $closeCode');
            final isAuthClose = closeCode == 4001 || closeCode == 4003;
            _handleDisconnect(isAuthError: isAuthClose);
          },
          onError: (error) {
            debugPrint('[WebSocket] Connection error: $error');
            _handleDisconnect(isAuthError: true);
          },
        );
        return; // Successfully connected!
      } catch (e) {
        debugPrint('[WebSocket] Failed connection to $url: $e');
      }
    }

    // If all candidate URLs failed
    debugPrint('[WebSocket] All endpoint candidates failed to upgrade connection.');
    _handleDisconnect(isAuthError: false);
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

  void _handleDisconnect({bool isAuthError = false}) async {
    _isConnected = false;
    _pingTimer?.cancel();

    if (_explicitlyDisconnected) {
      debugPrint('[WebSocket] Closed due to explicit disconnect (Off Duty / Logout).');
      return;
    }

    if (isAuthError && _sessionManager != null) {
      debugPrint('[WebSocket Rider] Auth error detected on socket. Triggering token refresh...');
      await _sessionManager!.refreshSession(force: true);
    }

    if (_currentDriverId != null) {
      _reconnectAttempts++;
      final delaySeconds = (_reconnectAttempts * 2).clamp(2, 30);
      debugPrint('[WebSocket] Unexpected disconnect. Reconnecting in ${delaySeconds}s (attempt $_reconnectAttempts)...');
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
        if (!_isConnected && !_explicitlyDisconnected) {
          _establishConnection();
        }
      });
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      final payloadStr = jsonEncode(message);
      _channel!.sink.add(payloadStr);
      debugPrint('[WebSocket] Sent Event: "${message['event']}" -> $message');
    } else {
      debugPrint('[WebSocket] Cannot send message "${message['event']}". Socket is not connected.');
    }
  }

  void sendLocationPing({
    required double lat,
    required double lng,
    double heading = 0.0,
    double speedKmh = 0.0,
  }) {
    sendMessage({
      'event': 'rider.location',
      'data': {
        'lat': lat,
        'lng': lng,
        'heading': heading,
        'speed_kmh': speedKmh,
      }
    });
  }

  void disconnect() {
    debugPrint('[WebSocket] Explicit disconnect requested by rider (Off Duty).');
    _explicitlyDisconnected = true;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close(status.normalClosure);
    _isConnected = false;
    _currentDriverId = null;
    _currentToken = null;
  }
}

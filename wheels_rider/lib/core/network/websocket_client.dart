import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  int? _currentDriverId;
  String? _currentToken;
  int _reconnectAttempts = 0;
  bool _explicitlyDisconnected = false;

  void connect(int driverId, String token) {
    _currentDriverId = driverId;
    _currentToken = token;
    _explicitlyDisconnected = false;
    if (_isConnected) {
      debugPrint('[WebSocket] Connect requested but already connected.');
      return;
    }
    _establishConnection();
  }

  Future<void> _establishConnection() async {
    if (_currentDriverId == null || _currentToken == null) return;

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
          onDone: () async {
            final closeCode = _channel?.closeCode;
            debugPrint('[WebSocket] Connection closed (onDone) code: $closeCode');
            if (closeCode == 4001) {
              debugPrint('[WebSocket] Received close code 4001 (TOKEN_EXPIRED). Triggering token refresh...');
              final newToken = await _refreshAccessToken();
              if (newToken != null && newToken.isNotEmpty) {
                _currentToken = newToken;
                _establishConnection();
                return;
              }
            }
            _handleDisconnect();
          },
          onError: (error) {
            debugPrint('[WebSocket] Connection error: $error');
            _handleDisconnect();
          },
        );
        return; // Successfully connected!
      } catch (e) {
        debugPrint('[WebSocket] Failed connection to $url: $e');
      }
    }

    // If all candidate URLs failed
    debugPrint('[WebSocket] All endpoint candidates failed to upgrade connection.');
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

    if (!_explicitlyDisconnected && _currentDriverId != null && _currentToken != null) {
      _reconnectAttempts++;
      final delaySeconds = (_reconnectAttempts * 2).clamp(2, 30);
      debugPrint('[WebSocket] Unexpected disconnect. Reconnecting in ${delaySeconds}s (attempt $_reconnectAttempts)...');
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
        if (!_isConnected && !_explicitlyDisconnected) {
          _establishConnection();
        }
      });
    } else if (_explicitlyDisconnected) {
      debugPrint('[WebSocket] Closed due to explicit disconnect (Off Duty / Logout).');
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

  Future<String?> _refreshAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('user_refresh_token') ?? prefs.getString('refresh_token');

      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('[WebSocket] No refresh token found.');
        return null;
      }

      final refreshDio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ));

      const refreshUrl = 'http://15.252.129.37:8200/api/v1/auth/refresh';
      final response = await refreshDio.post(
        refreshUrl,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final resData = response.data;
        if (resData['success'] == true && resData['data'] != null) {
          final data = resData['data'] as Map<String, dynamic>;
          final newAccess = data['access_token'] as String?;
          final newRefresh = data['refresh_token'] as String?;

          if (newAccess != null && newAccess.isNotEmpty) {
            await prefs.setString('user_token', newAccess);
            await prefs.setString('access_token', newAccess);
            if (newRefresh != null && newRefresh.isNotEmpty) {
              await prefs.setString('user_refresh_token', newRefresh);
              await prefs.setString('refresh_token', newRefresh);
            }
            debugPrint('[WebSocket] Token refresh successful.');
            return newAccess;
          }
        }
      }
    } catch (e) {
      debugPrint('[WebSocket] Refresh token error: $e');
    }
    return null;
  }
}

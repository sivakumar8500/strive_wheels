import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    final candidateUrls = [
      '$cleanBase/ws/$role/$userId?token=$encodedToken',
      'ws://15.252.129.37:8200/ws/$role/$userId?token=$encodedToken',
      'ws://15.252.129.37:8200/ws/customer/$userId?token=$encodedToken',
      'ws://15.252.129.37:8200/ws/v1/connect?token=$encodedToken',
    ];

    _establishConnectionWithCandidates(candidateUrls);
  }

  Future<void> _establishConnectionWithCandidates(List<String> candidateUrls) async {
    for (final url in candidateUrls) {
      try {
        debugPrint('[WebSocket] Attempting connection to $url');
        final channel = WebSocketChannel.connect(Uri.parse(url));
        await channel.ready;

        _channel = channel;
        _currentUrl = url;
        _isConnected = true;
        _reconnectAttempts = 0;
        debugPrint('[WebSocket] Connection established successfully via $url');

        _flushPendingQueue();
        _startPingHeartbeat();

        _channel!.stream.listen(
          (data) {
            _handleIncomingData(data);
          },
          onError: (error) {
            debugPrint('[WebSocket] Error: $error');
            _handleDisconnect();
          },
          onDone: () async {
            final closeCode = _channel?.closeCode;
            debugPrint('[WebSocket] Connection closed. Code: $closeCode');
            if (closeCode == 4001) {
              debugPrint('[WebSocket] Received 4001 (TOKEN_EXPIRED). Refreshing token...');
              final newToken = await _refreshAccessToken();
              if (newToken != null && newToken.isNotEmpty) {
                if (_currentUrl != null) {
                  final updatedUrl = _currentUrl!.replaceAll(RegExp(r'token=[^&]+'), 'token=${Uri.encodeComponent(newToken)}');
                  _currentUrl = updatedUrl;
                  _establishConnectionWithCandidates([updatedUrl]);
                  return;
                }
              }
            }
            _handleDisconnect();
          },
        );
        return; // Connected successfully!
      } catch (e) {
        debugPrint('[WebSocket] Connection failed for $url: $e');
      }
    }

    _handleDisconnect();
  }

  final List<String> _pendingQueue = [];

  void _flushPendingQueue() {
    if (!_isConnected || _channel == null) return;
    while (_pendingQueue.isNotEmpty) {
      final msg = _pendingQueue.removeAt(0);
      try {
        _channel!.sink.add(msg);
        debugPrint('[WebSocket] Flushed pending message: $msg');
      } catch (e) {
        debugPrint('[WebSocket] Error flushing pending message: $e');
      }
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

  /// Send event to WebSocket server (or queue if connection in progress)
  void send(String event, Map<String, dynamic> data) {
    final payload = jsonEncode({'event': event, 'data': data});
    if (_isConnected && _channel != null) {
      _channel!.sink.add(payload);
      debugPrint('[WebSocket] Sent event: $event payload: $payload');
    } else {
      debugPrint('[WebSocket] Not connected yet. Queuing event: $event payload: $payload');
      _pendingQueue.add(payload);
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
          _establishConnectionWithCandidates([_currentUrl!]);
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

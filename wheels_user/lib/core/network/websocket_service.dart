import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'session_manager.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  WebSocketChannel? _channel;
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  Timer? _pingTimer;
  Timer? _reconnectTimer;

  bool _isConnected = false;
  String? _baseUrl;
  int? _userId;
  String? _role;
  String? _latestToken;
  SessionManager? _sessionManager;

  int _reconnectAttempts = 0;
  bool _explicitlyDisconnected = false;

  Stream<Map<String, dynamic>> get eventStream => _eventController.stream;
  bool get isConnected => _isConnected;

  void setSessionManager(SessionManager sessionManager) {
    _sessionManager = sessionManager;
  }

  /// Connect to WebSocket Endpoint with JWT Token
  void connect(String baseUrl, int userId, String token, {required String role, SessionManager? sessionManager}) {
    _baseUrl = baseUrl;
    _userId = userId;
    _role = role;
    _latestToken = token;
    if (sessionManager != null) _sessionManager = sessionManager;
    _explicitlyDisconnected = false;

    _reconnectAttempts = 0;
    _establishConnection();
  }

  Future<void> _establishConnection() async {
    if (_baseUrl == null || _userId == null || _role == null || _explicitlyDisconnected) return;

    if (_sessionManager != null) {
      final freshToken = await _sessionManager!.getValidAccessToken();
      if (freshToken != null && freshToken.isNotEmpty) {
        _latestToken = freshToken;
      }
    }

    var formattedBase = _baseUrl!.trim();
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

    var cleanToken = (_latestToken ?? '').trim();
    if (cleanToken.endsWith('#')) {
      cleanToken = cleanToken.substring(0, cleanToken.length - 1);
    }
    if (cleanToken.isEmpty) {
      cleanToken = 'demo_token';
    }
    final encodedToken = Uri.encodeComponent(cleanToken);
    final wsUrl = '$cleanBase/ws/$_role/$_userId?token=$encodedToken';

    try {
      debugPrint('[WebSocket] Connecting to $wsUrl');
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _isConnected = true;
      _reconnectAttempts = 0;

      _channel!.stream.listen(
        (data) {
          _handleIncomingData(data);
        },
        onError: (error) {
          debugPrint('[WebSocket] Error: $error');
          _handleDisconnect(isAuthError: true);
        },
        onDone: () {
          final closeCode = _channel?.closeCode;
          debugPrint('[WebSocket] Connection closed. Code: $closeCode');
          final isAuthClose = closeCode == 4001 || closeCode == 4003;
          _handleDisconnect(isAuthError: isAuthClose);
        },
      );

      _startPingHeartbeat();
    } catch (e) {
      debugPrint('[WebSocket] Connection failure: $e');
      _handleDisconnect(isAuthError: false);
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

  void _handleDisconnect({bool isAuthError = false}) async {
    _isConnected = false;
    _pingTimer?.cancel();

    if (_explicitlyDisconnected) return;

    if (isAuthError && _sessionManager != null) {
      debugPrint('[WebSocket] Auth expiry detected on WebSocket. Triggering session refresh...');
      await _sessionManager!.refreshSession(force: true);
    }

    _reconnectAttempts++;
    final delaySeconds = (_reconnectAttempts * 2).clamp(2, 30);
    debugPrint('[WebSocket] Reconnecting in $delaySeconds seconds...');
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      if (!_isConnected && !_explicitlyDisconnected) {
        _establishConnection();
      }
    });
  }

  void disconnect() {
    _explicitlyDisconnected = true;
    _isConnected = false;
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.normalClosure);
  }
}

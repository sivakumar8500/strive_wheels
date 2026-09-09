# Flutter WebSocket Integration & Expiration Solution Guide

## Overview

This document provides a comprehensive solution for the WebSocket connection failures observed in the Flutter applications and confirms the update of JWT Access Token expiration to **7 days**.

---

## 1. Summary of Fixes Applied

### A. Access Token Expiry Updated to 7 Days
- **Configuration Key**: `ACCESS_TOKEN_EXPIRE_MINUTES`
- **Previous Value**: `30` (30 minutes)
- **New Value**: `10080` (7 days = 7 × 24 × 60 minutes)
- **Files Modified**:
  - `app/core/config.py`
  - `.env`
  - `.env.example`

### B. Dual-Route Alignment for WebSockets
- **Issue**: Flutter app requested `ws://15.252.129.37:8200/api/v1/ws/customer/...` and `ws://15.252.129.37:8200/api/v1/ws/driver/...`, but FastAPI router was only registered under `/ws/customer/...` and `/ws/driver/...`.
- **Symptom**: FastAPI returned HTTP `404 Not Found` for `/api/v1/ws/...` paths, throwing `WebSocketChannelException: Connection was not upgraded to websocket` in Flutter.
- **Fix**: Updated `app/websocket/router.py` to register route aliases for **both** `/ws/...` and `/api/v1/ws/...` paths.

### C. Clean Handshake & Connection Close Frame (Code 4001)
- **Issue**: Calling `websocket.close()` on an un-accepted WebSocket connection can cause unexpected connection drops or missing close frames.
- **Fix**: Ensured `websocket.accept()` is executed before calling `websocket.close(code=4001, reason="Unauthorized access token")` when token validation fails.

---

## 2. Root Cause & Technical Details

### Error 1: "Connection was not upgraded to websocket"
```text
WebSocketChannelException: WebSocketException: Connection to 'http://15.252.129.37:8200/api/v1/ws/driver/4?token=...' was not upgraded to websocket
```
**Why it occurred**:
1. The Flutter client attempted to open a WebSocket connection at `ws://15.252.129.37:8200/api/v1/ws/driver/4`.
2. The server endpoint was registered at `/ws/driver/4` (without `/api/v1`).
3. FastAPI returned a standard HTTP `404 Not Found` response instead of upgrading the HTTP connection to WebSocket (HTTP status 101 Switching Protocols).
4. The Flutter Dart HTTP client failed the WebSocket upgrade handshake and threw `Connection was not upgraded to websocket`.

### Error 2: "[WebSocket] Connection closed"
```text
[WebSocket] Connection closed.
I/flutter (19693): [WebSocket] Reconnecting in 4 seconds...
```
**Why it occurred**:
1. When Flutter connected to `ws://15.252.129.37:8200/ws/driver/4`, the path matched, but token validation failed (e.g. invalid signature, missing token, or server secret key mismatch).
2. The server closed the socket immediately. Without a proper WebSocket HTTP 101 handshake, Flutter logged connection closed and began auto-reconnecting in a loop.

---

## 3. Supported Backend Endpoints Matrix

Both `/ws/...` and `/api/v1/ws/...` paths are now fully supported:

| Role | Endpoint URL (Prefix 1) | Endpoint URL (Prefix 2) |
| :--- | :--- | :--- |
| **Driver / Rider** | `ws://15.252.129.37:8200/api/v1/ws/driver/{driver_id}?token={TOKEN}` | `ws://15.252.129.37:8200/ws/driver/{driver_id}?token={TOKEN}` |
| **Customer** | `ws://15.252.129.37:8200/api/v1/ws/customer/{user_id}?token={TOKEN}` | `ws://15.252.129.37:8200/ws/customer/{user_id}?token={TOKEN}` |
| **Unified Connect** | `ws://15.252.129.37:8200/api/v1/ws/v1/connect?token={TOKEN}` | `ws://15.252.129.37:8200/ws/v1/connect?token={TOKEN}` |

---

## 4. Flutter Integration Code Fixes

### A. Flutter Base URL & Path Construction

In your Flutter app (`websocket_service.dart` or WS manager), ensure the WS URL format matches the backend:

```dart
// Recommended Base WebSocket URL (without trailing slash)
const String wsBaseUrl = 'ws://15.252.129.37:8200/api/v1';

/// Connect Driver
void connectDriver(int driverId, String accessToken) {
  final url = '$wsBaseUrl/ws/driver/$driverId?token=$accessToken';
  WebSocketService().connect(url);
}

/// Connect Customer
void connectCustomer(int customerId, String accessToken) {
  final url = '$wsBaseUrl/ws/customer/$customerId?token=$accessToken';
  WebSocketService().connect(url);
}
```

---

### B. Flutter Robust WebSocket Service (`websocket_service.dart`)

Below is the complete, recommended implementation for Flutter:

```dart
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

  void connect(String fullUrl) {
    _currentUrl = fullUrl;
    _establishConnection();
  }

  void _establishConnection() {
    if (_currentUrl == null) return;
    try {
      debugPrint('[WebSocket] Connecting to $_currentUrl');
      _channel = WebSocketChannel.connect(Uri.parse(_currentUrl!));
      _isConnected = true;
      _reconnectAttempts = 0;

      _channel!.stream.listen(
        (data) {
          _handleIncomingData(data);
        },
        onError: (error) {
          debugPrint('[WebSocket] Connection Error: $error');
          _handleDisconnect();
        },
        onDone: () {
          debugPrint('[WebSocket] Connection Closed cleanly by server or network.');
          _handleDisconnect();
        },
      );

      _startPingHeartbeat();
    } catch (e) {
      debugPrint('[WebSocket] Handshake Failure: $e');
      _handleDisconnect();
    }
  }

  void _handleIncomingData(dynamic data) {
    try {
      final decoded = jsonDecode(data.toString()) as Map<String, dynamic>;
      debugPrint('[WebSocket] Received event: ${decoded['event']}');
      _eventController.add(decoded);
    } catch (e) {
      debugPrint('[WebSocket] Error parsing message payload: $e');
    }
  }

  void send(String event, Map<String, dynamic> data) {
    if (_isConnected && _channel != null) {
      final payload = jsonEncode({'event': event, 'data': data});
      _channel!.sink.add(payload);
      debugPrint('[WebSocket] Sent event: $event');
    } else {
      debugPrint('[WebSocket] Cannot send message - socket not connected.');
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

    if (_currentUrl != null) {
      _reconnectAttempts++;
      final delaySeconds = (_reconnectAttempts * 2).clamp(2, 30);
      debugPrint('[WebSocket] Reconnecting in $delaySeconds seconds...');
      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
        if (!_isConnected && _currentUrl != null) {
          _establishConnection();
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
```

---

## 5. Verification Checklist

1. **Token Duration**: Login via `/api/v1/auth/login`. Verify `exp` field in decoded JWT is set 7 days (168 hours) into the future.
2. **WebSocket Upgrade**: Connect Flutter client to `ws://15.252.129.37:8200/api/v1/ws/driver/{driver_id}?token={token}` or `ws://15.252.129.37:8200/api/v1/ws/customer/{user_id}?token={token}`. Handshake will complete with HTTP 101 Switching Protocols.
3. **Event Exchange**: Test sending `rider.location` or `booking.create` events over the WebSocket connection.

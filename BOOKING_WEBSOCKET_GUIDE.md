# Real-Time Booking WebSocket Integration Guide

Comprehensive guide for integrating real-time WebSockets in both **Customer** and **Rider/Driver** Flutter applications.

---

## 1. Overview & Architecture

The Strive backend uses FastAPI WebSockets synchronized with Redis Pub/Sub for real-time bidirection communication:
- **Customer App**: Listens for driver assignment, rider arrival, trip start, and trip completion events. Can also initiate ride bookings directly over WS.
- **Rider App**: Streams live GPS location, receives incoming ride requests within matching radius, accepts rides, and receives trip updates.

```
┌─────────────────┐             ┌──────────────────────────┐             ┌──────────────────┐
│  Customer App   │ ◄─── WS ───►│      Strive Backend      │◄─── WS ────►│    Rider App     │
│    (Flutter)    │             │   FastAPI + Connection   │             │    (Flutter)     │
└─────────────────┘             │         Manager          │             └──────────────────┘
                                └────────────┬─────────────┘
                                             │
                                             ▼
                                     ┌───────────────┐
                                     │ Redis Pub/Sub │
                                     └───────────────┘
```

---

## 2. Server Endpoints & Authentication

### Base WebSocket URLs

| App Type | WebSocket Endpoint URL |
| :--- | :--- |
| **Unified / Standard** | `ws://15.252.129.37:8200/api/v1/ws/v1/connect?token={JWT_ACCESS_TOKEN}` |
| **Customer App** | `ws://15.252.129.37:8200/api/v1/ws/customer/{user_id}?token={JWT_ACCESS_TOKEN}` |
| **Rider / Driver App** | `ws://15.252.129.37:8200/api/v1/ws/driver/{driver_id}?token={JWT_ACCESS_TOKEN}` |

> **Authentication**:
> Pass the JWT access token received during login as a URL query parameter `?token=YOUR_JWT_ACCESS_TOKEN`. If the token is invalid or expired, the server closes the connection with code `4001` (`Unauthorized access token`).

---

## 3. Payload Protocol Format

All WebSocket messages sent and received use standard JSON strings in the following structure:

```json
{
  "event": "event_name",
  "data": { ... }
}
```

---

## 4. Customer App WebSocket Events

### 4.1 Client to Server (Actions)

#### Create Booking via WebSocket
- **Event**: `booking.create`
- **Payload**:
```json
{
  "event": "booking.create",
  "data": {
    "service_mode": "NORMAL",
    "booking_mode": "INSTANT",
    "trip_type": "ONE_WAY",
    "vehicle_type_id": 1,
    "pickup_lat": 17.4126,
    "pickup_lng": 78.3498,
    "pickup_address": "Hitech City, Hyderabad",
    "drop_lat": 17.4435,
    "drop_lng": 78.3772,
    "drop_address": "Gachibowli, Hyderabad",
    "payment_method": "CASH"
  }
}
```

---

### 4.2 Server to Client (Notifications)

#### 1. Booking Created Confirmation
- **Event**: `booking.created`
- **Payload**:
```json
{
  "event": "booking.created",
  "data": {
    "booking": {
      "id": 105,
      "customer_id": 301,
      "status": "SEARCHING_RIDER",
      "pickup_address": "Hitech City, Hyderabad",
      "drop_address": "Gachibowli, Hyderabad",
      "estimated_fare": 185.00,
      "created_at": "2026-09-07T17:00:00Z"
    }
  }
}
```

#### 2. Rider Accepted Ride Request
- **Event**: `booking.rider_accepted`
- **Payload**:
```json
{
  "event": "booking.rider_accepted",
  "data": {
    "booking": {
      "id": 105,
      "rider_id": 401,
      "status": "RIDER_ASSIGNED",
      "start_otp": "4821",
      "estimated_fare": 185.00,
      "rider": {
        "id": 401,
        "full_name": "Ramesh Kumar",
        "phone": "+919876543210",
        "rating": 4.85
      },
      "vehicle": {
        "make": "Honda",
        "model": "Amaze",
        "license_plate": "TS09FA1234",
        "color": "White"
      }
    }
  }
}
```

#### 3. General Notifications (Trip Updates)
- **Event**: `notification.new`
- **Payload**:
```json
{
  "event": "notification.new",
  "data": {
    "notification": {
      "id": 12,
      "title": "Driver Arrived",
      "body": "Your driver Ramesh has arrived at the pickup location.",
      "notification_type": "TRIP_UPDATE",
      "metadata_json": "{\"booking_id\": 105}"
    }
  }
}
```

---

## 5. Rider / Driver App WebSocket Events

### 5.1 Client to Server (Actions)

#### 1. Stream Live GPS Location
- **Event**: `rider.location`
- **Payload**:
```json
{
  "event": "rider.location",
  "data": {
    "lat": 17.4126,
    "lng": 78.3498,
    "heading": 90.0,
    "speed_kmh": 25.5
  }
}
```

#### 2. Accept Incoming Ride Request
- **Event**: `booking.accept`
- **Payload**:
```json
{
  "event": "booking.accept",
  "data": {
    "booking_id": 105
  }
}
```

---

### 5.2 Server to Client (Notifications)

#### 1. Incoming Ride Request Notification
- **Event**: `booking.new_request`
- **Payload**:
```json
{
  "event": "booking.new_request",
  "data": {
    "request_id": 501,
    "booking": {
      "id": 105,
      "customer_id": 301,
      "pickup_lat": 17.4126,
      "pickup_lng": 78.3498,
      "pickup_address": "Hitech City, Hyderabad",
      "drop_lat": 17.4435,
      "drop_lng": 78.3772,
      "drop_address": "Gachibowli, Hyderabad",
      "estimated_fare": 185.00,
      "status": "SEARCHING_RIDER"
    }
  }
}
```

#### 2. Booking Accept Success Confirmation
- **Event**: `booking.accepted_success`
- **Payload**:
```json
{
  "event": "booking.accepted_success",
  "data": {
    "booking_id": 105
  }
}
```

---

## 6. Flutter Step-by-Step Implementation

### Step 1: Add Dependencies to `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter
  web_socket_channel: ^3.0.1
  async: ^2.11.0
```

---

### Step 2: Create Core WebSocket Service (`websocket_service.dart`)

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

  /// Connect to WebSocket Endpoint with JWT Token
  void connect(String baseUrl, int userId, String token, {required String role}) {
    final wsUrl = '$baseUrl/ws/$role/$userId?token=$token';
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
      debugPrint('[WebSocket] Sent event: $event');
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
```

---

### Step 3: Customer App Implementation (`customer_ws_controller.dart`)

```dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'websocket_service.dart';

class CustomerWSController {
  final WebSocketService _ws = WebSocketService();
  StreamSubscription? _subscription;

  void initCustomerWebSocket(int customerId, String jwtToken) {
    const baseUrl = 'ws://15.252.129.37:8200/api/v1';
    _ws.connect(baseUrl, customerId, jwtToken, role: 'customer');

    _subscription = _ws.eventStream.listen((message) {
      final event = message['event'];
      final data = message['data'] ?? {};

      switch (event) {
        case 'booking.created':
          debugPrint('Booking created: ${data['booking']['id']}');
          break;
        case 'booking.rider_accepted':
          final booking = data['booking'];
          final rider = booking['rider'];
          final otp = booking['start_otp'];
          debugPrint('Rider Accepted! Driver: ${rider['full_name']}, OTP: $otp');
          break;
        case 'notification.new':
          final notif = data['notification'];
          debugPrint('New Notification: ${notif['title']} - ${notif['body']}');
          break;
      }
    });
  }

  /// Request new ride booking
  void requestRide({
    required int vehicleTypeId,
    required double pickupLat,
    required double pickupLng,
    required String pickupAddress,
    required double dropLat,
    required double dropLng,
    required String dropAddress,
  }) {
    _ws.send('booking.create', {
      'service_mode': 'NORMAL',
      'booking_mode': 'INSTANT',
      'trip_type': 'ONE_WAY',
      'vehicle_type_id': vehicleTypeId,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'pickup_address': pickupAddress,
      'drop_lat': dropLat,
      'drop_lng': dropLng,
      'drop_address': dropAddress,
      'payment_method': 'CASH',
    });
  }

  void dispose() {
    _subscription?.cancel();
    _ws.disconnect();
  }
}
```

---

### Step 4: Rider App Implementation (`rider_ws_controller.dart`)

```dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'websocket_service.dart';

class RiderWSController {
  final WebSocketService _ws = WebSocketService();
  StreamSubscription? _subscription;

  void initRiderWebSocket(int riderId, String jwtToken) {
    const baseUrl = 'ws://15.252.129.37:8200/api/v1';
    _ws.connect(baseUrl, riderId, jwtToken, role: 'driver');

    _subscription = _ws.eventStream.listen((message) {
      final event = message['event'];
      final data = message['data'] ?? {};

      switch (event) {
        case 'booking.new_request':
          final booking = data['booking'];
          final requestId = data['request_id'];
          debugPrint('New Ride Request! Booking ID: ${booking['id']}, Request ID: $requestId');
          // Trigger Rider Accept Popup in Flutter UI
          break;
        case 'booking.accepted_success':
          debugPrint('Successfully accepted booking ${data['booking_id']}');
          break;
      }
    });
  }

  /// Send live GPS location ping to server
  void sendLocationPing({required double lat, required double lng, double heading = 0.0, double speedKmh = 0.0}) {
    _ws.send('rider.location', {
      'lat': lat,
      'lng': lng,
      'heading': heading,
      'speed_kmh': speedKmh,
    });
  }

  /// Accept incoming ride request
  void acceptRide(int bookingId) {
    _ws.send('booking.accept', {
      'booking_id': bookingId,
    });
  }

  void dispose() {
    _subscription?.cancel();
    _ws.disconnect();
  }
}
```

---

## 7. Best Practices & Troubleshooting

1. **Authentication Failures**:
   - Verify that `?token=` parameter is passed in the URL.
   - If token expires during session, disconnect WS, refresh JWT token via `/api/v1/auth/refresh`, and reconnect with the new access token.

2. **Network Reconnection**:
   - The Flutter `WebSocketService` automatically handles reconnection using exponential backoff (2s, 4s, 8s up to max 30s).

3. **Background Location for Riders**:
   - Use Flutter packages like `geolocator` or `flutter_background_service` to trigger `sendLocationPing()` every 5-10 seconds when rider is online.

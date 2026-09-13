# StriveWheels End-to-End Booking WebSocket Specification

This document provides a comprehensive, event-by-event technical specification for all WebSocket communications across the entire booking lifecycle between the **Customer App (`wheels_user`)**, **Backend Gateway (`strive-backend`)**, and **Rider App (`wheels_rider`)**.

---

## 1. Connection & Authentication Architecture

### 1.1 WebSocket Endpoints
- **Rider Channel**: `ws://<host>:8200/api/v1/ws/driver/{driver_id}?token={JWT_ACCESS_TOKEN}` (or `/ws/rider/{rider_id}`)
- **Customer Channel**: `ws://<host>:8200/api/v1/ws/customer/{user_id}?token={JWT_ACCESS_TOKEN}`
- **Unified Channel**: `ws://<host>:8200/api/v1/ws/v1/connect?token={JWT_ACCESS_TOKEN}`

### 1.2 Authentication & Heartbeat
- **Handshake Token**: Passed as query parameter `?token=<JWT_ACCESS_TOKEN>`.
- **Ping / Pong (Heartbeat)**: Either party sends `ping` event every 25 seconds; recipient responds with `pong`.

---

## 2. End-to-End Booking Lifecycle Sequence Diagram

```
+------------------+                   +------------------+                   +------------------+
| Customer App     |                   | Backend Gateway  |                   | Rider App        |
+------------------+                   +------------------+                   +------------------+
         |                                       |                                      |
         | --- POST /bookings (Create) --------> |                                      |
         | <--- 200 OK (Booking Created) ------- |                                      |
         | <--- WS: booking.searching_driver --- |                                      |
         |                                       | --- WS: booking.request_sent ------> | (Plays Alert Audio)
         |                                       |                                      |
         |                                       | <--- WS: booking.accept ------------ |
         | <--- WS: booking.accepted ----------- | --- WS: booking.accepted ----------> | (Locks Ride Match)
         |                                       |                                      |
         |                                       | <--- WS: rider.location ------------ | (Live GPS Stream)
         | <--- WS: rider.location_updated ----- |                                      |
         |                                       |                                      |
         |                                       | <--- WS: booking.arrived ----------- |
         | <--- WS: booking.rider_arrived ------ |                                      | (Displays Start OTP)
         |                                       |                                      |
         |                                       | <--- WS: booking.start ------------- | (Submits Pickup OTP)
         | <--- WS: booking.trip_started ------- | --- WS: booking.trip_started ------> | (Starts Navigation)
         |                                       |                                      |
         |                                       | <--- WS: rider.location (Geofence) - | (Within 500 meters)
         | <--- WS: booking.reached_drop_loc --- | --- WS: booking.reached_drop_loc --> | (Enables Complete Button)
         |                                       |                                      |
         | --- WS: booking.drop_requested -----> |                                      | (Optional Early Drop)
         |                                       | --- WS: booking.drop_requested ----> | (Displays Confirm Modal)
         |                                       | <--- WS: booking.drop_accepted ----- |
         | <--- WS: booking.drop_accepted ------ | --- WS: booking.drop_accepted -----> | (Unlocks Completion)
         |                                       |                                      |
         |                                       | <--- POST /bookings/{id}/complete - |
         | <--- WS: booking.completed ---------- | --- WS: booking.completed ---------> | (Awaiting Payment)
         |                                       |                                      |
```

---

## 3. Detailed Event Reference Dictionary

### Event 1: `ping` / `pong` (Connection Liveness Check)
- **Sender**: Customer / Rider App (every 25 seconds)
- **Receiver**: Backend Gateway (and vice versa)

#### Request Payload:
```json
{
  "event": "ping",
  "data": {
    "timestamp": 1789024301078
  }
}
```

#### Response Payload (`pong`):
```json
{
  "event": "pong",
  "data": {
    "timestamp": 1789024301090
  }
}
```

---

### Event 2: `booking.searching_driver` (Driver Search Broadcast)
- **Sender**: Backend Gateway
- **Receiver**: Customer App
- **Trigger**: Customer creates a booking via `POST /api/v1/bookings`.

#### Payload:
```json
{
  "event": "booking.searching_driver",
  "data": {
    "booking_id": 12345,
    "booking_code": "BK-20260911-A89F",
    "status": "SEARCHING_DRIVER",
    "radius_km": 5.0,
    "search_timeout_seconds": 15
  }
}
```

---

### Event 3: `booking.request_sent` (Driver Ride Request Alert)
- **Sender**: Backend Gateway
- **Receiver**: Matching Rider App(s)
- **Trigger**: Backend matches an available online rider within radius.

#### Payload:
```json
{
  "event": "booking.request_sent",
  "data": {
    "booking_id": 12345,
    "request_id": 987,
    "booking_code": "BK-20260911-A89F",
    "service_mode": "NORMAL",
    "pickup_address": "Financial District, Nanakramguda, Hyderabad",
    "pickup_lat": 17.4126,
    "pickup_lng": 78.3498,
    "drop_address": "Hitech City, Hyderabad",
    "drop_lat": 17.4435,
    "drop_lng": 78.3772,
    "estimated_fare": 245.50,
    "estimated_distance_km": 8.25,
    "expires_at": "2026-09-11T10:15:30Z"
  }
}
```

---

### Event 4: `booking.accept` / `booking.accepted` (Acceptance & Match Lock)
- **Step A**: Rider App sends `booking.accept` (or HTTP `POST /api/v1/rider/booking-requests/{id}/accept`).
- **Step B**: Backend performs atomic database claim lock and broadcasts `booking.accepted` to both Customer & Rider.

#### Rider Sent Event (`booking.accept`):
```json
{
  "event": "booking.accept",
  "data": {
    "booking_id": 12345
  }
}
```

#### Broadcast Event to Customer & Rider (`booking.accepted`):
```json
{
  "event": "booking.accepted",
  "data": {
    "booking_id": 12345,
    "booking_code": "BK-20260911-A89F",
    "status": "DRIVER_ASSIGNED",
    "rider": {
      "id": 67,
      "full_name": "Rajesh Kumar",
      "phone_number": "+919876543210",
      "rating": 4.85,
      "profile_photo_url": "http://15.252.129.37:8200/static/uploads/profile.jpg"
    },
    "vehicle": {
      "make": "Toyota",
      "model": "Etios",
      "license_plate": "TS09EA1234",
      "color": "White"
    },
    "start_otp": "4829"
  }
}
```

---

### Event 5: `booking.request_cancelled` (Request Expired or Accepted by Another)
- **Sender**: Backend Gateway
- **Receiver**: Counterpart Rider Apps (who received request but didn't win claim)

#### Payload:
```json
{
  "event": "booking.request_cancelled",
  "data": {
    "booking_id": 12345,
    "reason": "Accepted by another driver or expired"
  }
}
```

---

### Event 6: `rider.location` / `rider.location_updated` (Live Tracking)
- **Rider Sent (`rider.location`)**: Rider app streams GPS coordinates every 3–5 seconds.
- **Customer Broadcast (`rider.location_updated`)**: Backend updates Redis Geo index and broadcasts updated position to Customer app.

#### Rider Sent Event (`rider.location`):
```json
{
  "event": "rider.location",
  "data": {
    "lat": 17.41285,
    "lng": 78.33507,
    "heading": 186.5,
    "speed_kmh": 24.2
  }
}
```

#### Customer Broadcast Event (`rider.location_updated`):
```json
{
  "event": "rider.location_updated",
  "data": {
    "booking_id": 12345,
    "rider_id": 67,
    "lat": 17.41285,
    "lng": 78.33507,
    "heading": 186.5
  }
}
```

---

### Event 7: `booking.arrived` / `booking.rider_arrived` (Arrival at Pickup)
- **Sender**: Rider App (when reaching pickup location)
- **Receiver**: Customer App

#### Rider Sent Event (`booking.arrived`):
```json
{
  "event": "booking.arrived",
  "data": {
    "booking_id": 12345
  }
}
```

#### Customer Received Event (`booking.rider_arrived`):
```json
{
  "event": "booking.rider_arrived",
  "data": {
    "booking_id": 12345,
    "status": "RIDER_ARRIVED",
    "message": "Your driver has arrived at the pickup location. Share OTP to start trip.",
    "start_otp": "4829"
  }
}
```

---

### Event 8: `booking.start` / `booking.trip_started` (Trip Start with OTP)
- **Sender**: Rider App (submits 4-digit OTP supplied by Customer)

#### Rider Sent Event (`booking.start`):
```json
{
  "event": "booking.start",
  "data": {
    "booking_id": 12345,
    "otp": "4829"
  }
}
```

#### Broadcast to Customer & Rider (`booking.trip_started`):
```json
{
  "event": "booking.trip_started",
  "data": {
    "booking_id": 12345,
    "status": "TRIP_STARTED",
    "started_at": "2026-09-11T10:20:00Z"
  }
}
```

---

### Event 9: `booking.reached_drop_location` (Geofence Proximity Alert)
- **Sender**: Backend Gateway (Automatic)
- **Receiver**: Both Customer & Rider Apps
- **Trigger**: Rider live location comes within **500 meters** of destination `(drop_lat, drop_lng)`. Automatically enables the **"Complete Trip"** button in Rider app.

#### Payload:
```json
{
  "event": "booking.reached_drop_location",
  "data": {
    "booking_id": 12345,
    "rider_id": 67,
    "distance_meters": 182.4,
    "is_within_drop_zone": true
  }
}
```

---

### Event 10: `booking.drop_requested` (Request Early / Custom Drop)
- **Sender**: Customer OR Rider App
- **Receiver**: Counterpart App & Backend
- **Trigger**: Rider or Customer taps **"Request Drop"** and enters a reason (e.g. road blocked, early exit).

#### Payload:
```json
{
  "event": "booking.drop_requested",
  "data": {
    "booking_id": 12345,
    "requested_by": "RIDER",
    "reason": "Road block ahead / early exit requested",
    "is_drop_requested": true,
    "timestamp": "2026-09-11T10:32:15Z"
  }
}
```

---

### Event 11: `booking.drop_accepted` (Confirm / Accept Drop Request)
- **Sender**: Counterpart App (e.g. Customer approving Rider's drop request)
- **Receiver**: Both Customer & Rider Apps
- **Trigger**: Unlocks location-gated trip completion on backend even if rider is outside 500m geofence.

#### Payload:
```json
{
  "event": "booking.drop_accepted",
  "data": {
    "booking_id": 12345,
    "accepted_by": "CUSTOMER",
    "is_drop_accepted": true,
    "timestamp": "2026-09-11T10:32:45Z"
  }
}
```

---

### Event 12: `booking.completed` (Ride Completion & Fare Invoice)
- **Sender**: Backend Gateway
- **Receiver**: Both Customer & Rider Apps
- **Trigger**: Rider submits `POST /api/v1/bookings/{id}/complete`. Status transitions to `TRIP_COMPLETED` / `PAYMENT_PENDING`.

#### Payload:
```json
{
  "event": "booking.completed",
  "data": {
    "booking_id": 12345,
    "status": "COMPLETED",
    "final_fare": 245.50,
    "payment_status": "PAYMENT_PENDING"
  }
}
```

---

### Event 13: `booking.cancel` / `booking.cancelled` (Trip Cancellation)
- **Sender**: Customer OR Rider App
- **Receiver**: Counterpart App & Backend

#### Sent Payload (`booking.cancel`):
```json
{
  "event": "booking.cancel",
  "data": {
    "booking_id": 12345,
    "reason": "Change of plans"
  }
}
```

#### Broadcast Payload to Counterpart (`booking.cancelled`):
```json
{
  "event": "booking.cancelled",
  "data": {
    "booking_id": 12345,
    "cancelled_by": "CUSTOMER",
    "status": "CUSTOMER_CANCELLED",
    "reason": "Change of plans"
  }
}
```

---

### Event 14: `booking.no_driver_found` (Search Timeout Failure)
- **Sender**: Backend Gateway
- **Receiver**: Customer App
- **Trigger**: Search radius exhausted after 15 seconds without driver acceptance.

#### Payload:
```json
{
  "event": "booking.no_driver_found",
  "data": {
    "booking_id": 12345,
    "status": "NO_DRIVER_AVAILABLE",
    "message": "No nearby driver accepted your request. Please try again."
  }
}
```

---

## 4. WebSocket Close Codes & Reconnection Standards

| Close Code | Name | Trigger Condition | Recommended Flutter Handling |
| :---: | :--- | :--- | :--- |
| **`4001`** | `TOKEN_EXPIRED` | Access Token JWT signature expired. | Intercept `4001`, call `POST /api/v1/auth/refresh`, obtain new token, and automatically reconnect WebSocket. |
| **`4003`** | `UNAUTHORIZED` | Invalid JWT signature or session revoked in Redis. | Clear local auth tokens and navigate user to Login Screen. |
| **`1000`** | `NORMAL_CLOSURE` | Clean disconnect on app logout or exit. | No action needed. |

---

## 5. Flutter Client Implementation Snippet (`WebSocketClient`)

```dart
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  IOWebSocketChannel? _channel;
  StreamSubscription? _subscription;

  void connect(String url) {
    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    _subscription = _channel?.stream.listen(
      (message) {
        final Map<String, dynamic> data = jsonDecode(message);
        final String event = data['event'] ?? '';
        _handleEvent(event, data['data'] ?? {});
      },
      onError: (error) => debugPrint('WS Error: $error'),
      onDone: () {
        final closeCode = _channel?.closeCode;
        if (closeCode == 4001) {
          // Token expired -> refresh token & reconnect
          refreshTokenAndReconnect();
        }
      },
    );
  }

  void sendMessage(Map<String, dynamic> payload) {
    _channel?.sink.add(jsonEncode(payload));
  }

  void _handleEvent(String event, Map<String, dynamic> payload) {
    switch (event) {
      case 'booking.accepted':
        // Update UI with assigned rider & start OTP
        break;
      case 'booking.reached_drop_location':
        // Enable complete ride button in Rider app
        break;
      case 'booking.drop_requested':
        // Show drop request confirmation dialog
        break;
      case 'booking.completed':
        // Show payment screen
        break;
    }
  }
}
```

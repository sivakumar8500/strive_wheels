# StriveWheels Backend Developer Specification: WebSocket & HTTP Handoff Guide

This guide details the exact WebSocket events and HTTP endpoints required by the **Flutter Customer App (`wheels_user`)** and **Rider App (`wheels_rider`)** for OTP verification, trip state updates, and real-time location streaming.

---

## 1. WebSocket Endpoint Connections

The backend must accept WebSocket upgrade requests on the following channels:

- **Rider Channel**: `ws://<host>:8200/api/v1/ws/driver/{driver_id}?token={JWT_ACCESS_TOKEN}`
- **Customer Channel**: `ws://<host>:8200/api/v1/ws/customer/{user_id}?token={JWT_ACCESS_TOKEN}`
- **Unified Channel**: `ws://<host>:8200/api/v1/ws/v1/connect?token={JWT_ACCESS_TOKEN}`

*Note: All messages are formatted in JSON with `event` and `data` properties.*

---

## 2. OTP Verification & Trip Start Flow (CRITICAL)

When the Rider arrives at the pickup location, the Rider asks the Customer for their 4-digit start OTP (e.g. `4829`) and taps **"Start Trip"**.

### Step 2.1: Rider Submits OTP (WS or HTTP)

#### Option A: WebSocket Request (Sent by Rider App)
```json
{
  "event": "booking.start",
  "data": {
    "booking_id": 100,
    "otp": "4829"
  }
}
```

#### Option B: HTTP REST Endpoint (Fallback used by Rider App)
- **Method**: `POST`
- **URL**: `/api/v1/rider/bookings/{booking_id}/start`
- **Headers**: `Authorization: Bearer <RIDER_JWT>`
- **Body**:
```json
{
  "otp": "4829"
}
```

---

### Step 2.2: Backend Action upon Validating OTP

When the backend receives the OTP and verifies it:
1. Update database booking status to `TRIP_STARTED`.
2. **Multi-Broadcast** the success event to **BOTH** the Rider's socket AND the Customer's socket.

#### Mandatory Multi-Broadcast Event Payload:
Send this event to both Customer & Rider WebSocket connections:

```json
{
  "event": "booking.trip_started",
  "data": {
    "booking_id": 100,
    "status": "TRIP_STARTED",
    "otp_verified": true,
    "started_at": "2026-09-11T18:50:00Z"
  }
}
```

*Supported Event Name Aliases*: Backend should send under `booking.trip_started`. (The Flutter app also listens to `booking.started`, `rider.trip_started`, `trip_started`, `booking.otp_verified`, `booking.updated`).

---

## 3. Real-Time Rider Location Streaming

### Rider Stream (Sent by Rider App every 3-5 seconds)
```json
{
  "event": "rider.location",
  "data": {
    "booking_id": 100,
    "rider_id": 7,
    "lat": 17.4128791,
    "lng": 78.3350568,
    "heading": 186.5,
    "speed_kmh": 24.2
  }
}
```

### Customer Broadcast (Relayed by Backend to Customer App)
```json
{
  "event": "rider.location_updated",
  "data": {
    "booking_id": 100,
    "rider_id": 7,
    "lat": 17.4128791,
    "lng": 78.3350568,
    "heading": 186.5
  }
}
```

---

## 4. Required HTTP REST Endpoints

### 4.1 Booking Status Check Endpoint (Used for Backup Polling)
- **Method**: `GET`
- **URL**: `/api/v1/bookings/{booking_id}` (or `/api/v1/customer/bookings/{booking_id}`)
- **Headers**: `Authorization: Bearer <CUSTOMER_JWT>`
- **Response Format (200 OK)**:
```json
{
  "status": "success",
  "data": {
    "booking_id": 100,
    "status": "TRIP_STARTED",
    "rider_id": 7,
    "pickup_address": "Financial District",
    "drop_address": "Hitech City"
  }
}
```

---

## 5. Early / Custom Drop Request Flow

### Request Sent by Customer or Rider
```json
{
  "event": "booking.drop_requested",
  "data": {
    "booking_id": 100,
    "requested_by": "RIDER",
    "reason": "Road blocked ahead"
  }
}
```

### Acceptance Broadcast by Counterpart
```json
{
  "event": "booking.drop_accepted",
  "data": {
    "booking_id": 100,
    "accepted_by": "CUSTOMER",
    "status": "DROP_ACCEPTED"
  }
}
```

---

## 6. Trip Completion Flow

### Request (Sent by Rider App)
- **Method**: `POST`
- **URL**: `/api/v1/rider/bookings/{booking_id}/complete`
- **Headers**: `Authorization: Bearer <RIDER_JWT>`

### Broadcast Event (Sent to Customer & Rider Sockets)
```json
{
  "event": "booking.completed",
  "data": {
    "booking_id": 100,
    "status": "COMPLETED",
    "final_fare": 245.50
  }
}
```

---

## Summary Checklist for Backend Developer:
- [ ] Connect WebSocket on `/api/v1/ws/customer/{user_id}` and `/api/v1/ws/driver/{driver_id}`.
- [ ] Handle `booking.start` event or `POST /api/v1/rider/bookings/{id}/start` HTTP endpoint.
- [ ] Broadcast `booking.trip_started` to **BOTH** customer & rider sockets upon valid OTP.
- [ ] Relay `rider.location` as `rider.location_updated` to the customer socket.
- [ ] Ensure `GET /api/v1/bookings/{id}` accepts `Authorization: Bearer <token>` and returns `"status": "TRIP_STARTED"`.

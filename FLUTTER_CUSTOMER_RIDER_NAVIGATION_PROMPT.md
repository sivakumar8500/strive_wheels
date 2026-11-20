# Codex prompt: Flutter customer route view and rider navigation

## Task and inputs

Implement map route views and live tracking in my Flutter customer application, and live turn-by-turn navigation in my Flutter rider/driver application. The backend uses Python FastAPI, WebSockets, and Redis Pub/Sub. Booking already works.

Read `BOOKING_WEBSOCKET_GUIDE.md`, inspect both Flutter apps and available backend handlers, and use `NAVIGATION_API_CONTRACT.md` if produced by the companion backend prompt. Use the attached screenshot as the existing driver UI reference. Preserve current booking, OTP, payment, fare, and trip actions.

Inspect `pubspec.yaml`, map integration, location service, socket service, routing, and state management before editing. Use the project's established architecture. Implement actual repository changes, not a standalone demo. Verify current official documentation before selecting or changing map/navigation dependencies.

## 1. Integrate the existing protocol

Keep the envelope `{"event":"event_name","data":{...}}` and existing authenticated app-owned socket.

| Event | Required integration |
| --- | --- |
| `booking.new_request` | Keep booking pickup/drop coordinates and existing request UI |
| `booking.accept` | Send existing `booking_id` action |
| `booking.accepted_success` | Confirm acceptance; resolve full booking from store or actual retrieval contract |
| `rider.location` | Publish driver `lat`, `lng`, `heading`, `speed_kmh` |
| `booking.created` | Preserve customer booking flow |
| `booking.rider_accepted` | Update assigned driver/vehicle and route tracking |
| `notification.new` | Preserve notifications; do not parse titles to decide trip state |

The guide does not define trip-start/completion/cancellation events or customer-facing driver-location events. Use actual backend contracts. If support is missing, identify the exact dependency for the companion backend task; do not silently invent frontend-only event names or treat missing data as success.

## 2. Shared state behavior

The following phases are UI concepts, not new backend enum values. Map them to actual authoritative statuses:

| Phase | Customer app | Rider/driver app |
| --- | --- | --- |
| Searching | Existing search experience; pickup/drop route preview where available | Existing incoming requests |
| Assigned / approaching pickup | Live driver-to-pickup route, driver marker, pickup ETA | Navigate to pickup |
| Arrived / waiting | Arrival state and existing OTP display | Existing arrival and OTP/start actions |
| Trip in progress | Live driver-to-drop route and destination ETA | Navigate to destination |
| Completed / cancelled | Existing result screen; stop live trip tracking | Stop trip guidance; existing completion/cancellation screen |

Switch to destination navigation only after the server confirms trip start through the existing validated flow. Do not start or complete based solely on proximity. Reconcile from the backend after reconnect/resume. Handle duplicate events and ignore updates for unrelated or ended bookings.

## 3. Customer application: route view and live tracking

- Display pickup and drop markers with actual road geometry from the selected routing integration.
- After assignment, show a single vehicle marker driven by the authorized backend location stream. The customer's phone GPS must not substitute for the driver's position.
- Before pickup, emphasize driver-to-pickup route and pickup ETA. During the ride, emphasize driver-to-drop route and arrival ETA.
- Smoothly interpolate valid received positions and heading without implying indefinite movement after updates stop.
- Provide route overview and a follow-driver control. Respect manual panning and avoid fitting bounds on every GPS update.
- Use map padding so the route and markers remain visible above the trip panel.
- Show driver/vehicle details and existing call, cancellation, payment, and trip actions appropriate to the authoritative state.
- Show “Updating location” or a clear stale/offline state when data ages past the configured threshold. Do not show stale ETA as live.
- Handle missing route data with an honest unavailable/retry state; never draw a straight line and label it a road route.
- Customer tracking needs a route overview and progress, not driver voice guidance.
- Preserve the existing fare source. Route estimates must not recalculate charges locally.

## 4. Rider application: dedicated navigation screen

After confirmed acceptance, support pickup navigation. Once trip start is confirmed, automatically navigate toward the drop.

During active guidance:

- Hide the large profile/duty/earnings card, Corporate/Self selector, and bottom tabs shown in the screenshot.
- Show a full-screen map with one clear vehicle marker.
- Add a compact top maneuver banner with the next turn arrow, distance, and road name, using real navigation data.
- Add recenter, route overview, and supported voice mute controls.
- Add a compact bottom panel for remaining time, distance, arrival time, destination, and expandable passenger/trip details.
- Keep existing arrival/start/end actions in the appropriate phase. Confirm End Ride and wait for backend completion before displaying success.
- Preserve navy and bright-blue visual styling, with readable text and touch targets.
- Fix the visible RenderFlex overflow with appropriate constraints, Flexible/Expanded where suitable, text handling, and safe-area padding. Verify small screens and increased text size.
- Keep map attribution visible; do not cover the vehicle or important upcoming road with panels.

### Camera and marker behavior

- Follow local driver GPS smoothly, without waiting for backend echoes.
- Use a supported navigation camera with bearing and tilt; place the vehicle below center to show the road ahead.
- Smooth heading changes, including wraparound at north, and avoid jitter when stationary or heading is unreliable.
- Pause following while the driver pans; show Recenter and restore following on tap.
- Fit the whole route for overview only when requested or appropriate on initial display. Do not repeatedly reset the camera as updates arrive.
- Avoid duplicate native/custom location markers.

### Routing and guidance

- Reuse a compatible supported navigation SDK for the existing provider where practical. A map widget alone does not establish turn-by-turn guidance.
- Use real road routes, maneuvers, ETA, and supported voice instructions. Do not infer turns from an arbitrary polyline.
- Use the SDK's route-progress and rerouting features where available. If custom rerouting is necessary, require sustained deviation, account for GPS accuracy, debounce requests, and discard responses for an outdated booking, phase, or destination.
- Keep calculations consistent with the backend handoff's route/ETA ownership. Do not run competing SDK and custom rerouting loops.
- Clearly identify required keys, platform setup, or unavailable functionality. Production guidance must not use mock coordinates or fabricated ETAs.

## 5. Location source and socket publishing

Use one shared driver location source with separate local navigation and network publishing consumers. Reuse an existing source, or an SDK-owned source if suitable, rather than creating competing GPS subscriptions.

Preserve this inbound backend schema:

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

The values above are examples. Use live fixes. Verify source speed units and convert meters/second to km/h when required. Handle invalid/unavailable speed or heading according to the contract instead of sending invalid numeric values.

- Local map motion can update more frequently than socket publication.
- Configure publication cadence against backend expectations; the guide suggests 5–10 seconds, but confirm the actual deployment contract and tracking needs.
- Send only the latest valid fix after reconnection; do not replay a backlog of obsolete positions.
- Use optional timestamp/accuracy/sequence fields only if supported by the backend contract.
- Distinguish location failure, server connectivity failure, and routing-provider failure in the UI.
- Stop trip-specific guidance on completion/cancellation while retaining on-duty location sharing needed for matching.

## 6. Socket ownership, recovery, and lifecycle

Inspect the actual service before editing. The guide's sample marks connection readiness immediately and its stated exponential backoff differs from its linear calculation; check whether these issues exist in project code.

- Wait for connection readiness before reporting connected.
- Prevent duplicate stream listeners, timers, and reconnect attempts.
- Use capped exponential backoff with jitter; reset retries after a successful connection.
- Handle close code `4001` with the existing token-refresh/session flow; do not reconnect indefinitely with an expired token.
- Use only the backend-supported heartbeat.
- Do not log token-bearing URLs or OTPs.
- A screen's dispose must release its own resources without closing an app-owned shared socket.
- Reconcile booking state and latest tracking on reconnect, resume, and cold start; locally cached state is provisional until reconciled.
- Respect event ordering/version semantics documented by the backend.
- Handle permission denial, disabled GPS, poor accuracy, stale fixes, and network loss without crashes or misleading live indicators.
- Configure platform background location only as required for driver tracking and supported by the selected implementation. Do not request driver-style background tracking for the customer route view.

## 7. Implementation boundaries

Keep responsibilities clear using the existing project conventions: socket transport, booking state/repository, location source, navigation provider adapter/controller, and separate customer/rider presentation. Do not introduce a new state-management framework unnecessarily.

Use existing environment configuration and appropriately restricted client SDK keys. Backend-only routing secrets must remain on the backend. Any missing contract must be described concretely for backend implementation, including the exact frontend data requirement.

## 8. Verify and deliver

Run Flutter analysis and existing relevant tests. Add focused tests where needed for state transitions, stream ownership, and stale/duplicate message behavior. Use development-only simulated location traces to verify navigation if device testing is unavailable; state that limitation.

Check:

1. Acceptance enters pickup navigation and customer tracking uses driver coordinates.
2. Confirmed OTP/start switches both apps to destination progress.
3. Marker movement, route overview, camera follow, pan/recenter, and mute work where supported.
4. Off-route movement produces controlled rerouting without stale-response overwrite.
5. Network loss shows stale state and recovery restores the correct booking.
6. Repeated messages and reopening screens do not duplicate subscriptions or trip transitions.
7. Completion/cancellation removes customer tracking and driver guidance appropriately.
8. No layout overflow on a small screen or with larger text; attribution remains visible.
9. Existing booking, fare, payment, and trip actions still work.

Finish with changes separated by customer app and rider app, shared-service changes, verification results, and precise remaining SDK or backend dependencies. State which behavior was tested on a real device, simulated, or not yet verified. Do not claim production navigation is working when credentials or required backend contracts remain missing.

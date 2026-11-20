# Codex prompt: fix the Flutter customer live-trip map

## Goal and scope

My rider/driver navigation is working correctly. Update only the Flutter customer/user application's live-trip map and related customer tracking logic. Preserve the working rider application and existing booking flow.

Inspect the project and implement the fixes directly. Read the attached customer screenshot and `BOOKING_WEBSOCKET_GUIDE.md`. If available, read the implemented `NAVIGATION_API_CONTRACT.md`. Follow the existing Flutter state management, map provider, routing service, and shared socket architecture.

This is a customer tracking screen: show the driver's route and progress, with a clear overview. It does not need driver-style maneuver instructions or voice navigation.

## Screenshot observations to investigate

- There is no clearly visible continuous road-route line between the vehicle and pickup in the screenshot. Only a small colored segment appears near the vehicle. Determine whether this is missing data, incorrect geometry, clipping, styling, or camera framing; do not assume the cause.
- The header displays `NAVIGATING TO PICKUP`, `1 mins`, `0.0 miles`, and a clock ETA. Verify phase selection, source values, units, formatting, and freshness rather than replacing them with hardcoded values.
- The map is closely zoomed and the pickup marker is near the left edge. Both route endpoints and the full relevant route should fit in overview mode.
- The bottom driver card is partly obscured by the Android system navigation area. Its content, contact buttons, and text need safe-area handling and responsive layout.

## 1. Trace the customer data path before changing the UI

Find the actual source of:

1. Active booking ID and authoritative status.
2. Pickup and drop coordinates.
3. Driver live coordinates and heading.
4. Road-route geometry, distance, duration, and calculation timestamp.
5. Booking lifecycle updates and reconnection recovery.

Inspect incoming payload parsing, state updates, route decoding, map overlays, and camera updates. Diagnose whether the problem comes from data, calculation, rendering, or layout. Keep sensitive credentials, OTPs, and unnecessary location details out of debug output.

The supplied guide documents `booking.created`, `booking.rider_accepted`, and `notification.new` for the customer, but does not name the customer-facing live driver-location event or all lifecycle events. Inspect actual handlers and use their real contracts. Do not invent a socket event or infer trip state from a notification title.

Reuse the existing app-owned socket. The customer must consume authorized backend driver updates, not publish `rider.location` or use the customer's own GPS as the driver's position.

## 2. Display the correct route for each phase

Map these conceptual phases to the actual backend status values:

| Authoritative phase | Main route | Customer wording | ETA meaning |
| --- | --- | --- | --- |
| Driver assigned / approaching | Driver current position to pickup | Driver arriving | Time until pickup |
| Driver arrived / waiting | Show driver and pickup clearly | Driver has arrived | Arrival state; avoid a misleading countdown |
| Trip started / in progress | Driver current position to drop | On your way | Time until destination |
| Completed / cancelled | Existing result screen | Existing terminal-state wording | Stop active tracking |

Switch to the drop route only after the existing backend confirms trip start. Avoid defaulting an unknown status to pickup. Reconcile unknown or reconnecting state from the backend.

Keep existing OTP visibility rules, driver details, call/chat controls, cancellation, sharing, fare, and payment behavior. Arrival proximity must not start or complete the booking.

## 3. Make the road route clearly visible

- Reuse actual directions geometry from the project's implemented route provider or backend. Never substitute a straight line between coordinates.
- Verify coordinate order, valid values, geometry encoding and precision, decoded point count, and correct pickup/drop selection against the actual contract.
- Render a continuous, prominent blue route with suitable width and contrast; optionally use a contrasting outline if supported.
- Verify overlay visibility, z-order, stable polyline identity, state notification, and map rebuild/update behavior.
- If the UI trims completed route portions, inspect that logic so it does not accidentally remove nearly the entire route. Route progress should come from supported route matching, not arbitrary nearest-point slicing that can jump across loops.
- Keep geometry tied to booking ID, route phase, destination, and request generation. Discard late responses for an old phase or booking.
- Reuse the implemented route/ETA owner. Do not add competing route calculations or call directions on every location message. Use controlled refresh/rerouting when genuinely needed.
- Represent route loading, unavailable geometry, and provider failure explicitly. Do not display a fabricated route or zero distance as a successful fallback.
- If a usable previous route is retained during refresh, associate it with the same booking/phase and show that progress is updating when necessary.

## 4. Fix camera framing and markers

- On initial valid route load and pickup-to-drop transition, fit the relevant route bounds, driver, and active target inside the unobscured map viewport.
- Calculate padding from the actual top banner, bottom sheet height, safe areas, and floating controls. Update padding as the bottom sheet changes.
- Use a sensible fallback camera for a single point or extremely short route; do not zoom excessively when driver and pickup nearly coincide.
- Show exactly one driver vehicle marker and clear pickup/drop markers as appropriate. Avoid duplicate native/custom location markers.
- Animate received driver positions smoothly with sensible heading behavior. Do not keep extrapolating when updates stop, and do not snap to a road without supported matching data.
- Provide distinct route-overview and follow-driver controls. Recenter/follow must target the driver, not the customer's phone.
- Respect manual pan/zoom. Do not call fit-bounds on every GPS update or rebuild.
- Keep map provider attribution visible.

## 5. Correct distance and ETA presentation

- Use remaining road-route distance and duration for the active phase, not a straight-line calculation or total original trip distance.
- Verify source units before conversion. Keep internal units explicit and apply the app's locale/product unit setting. For the existing India experience, use meters/kilometers unless an established user setting chooses otherwise.
- Avoid rounding a small nonzero distance to `0.0 miles`. In metric mode, examples are `250 m` and `1.2 km`; round display values consistently.
- Format singular/plural correctly: `1 min`, `5 min`. A value below one minute may display `<1 min` without declaring the driver arrived.
- Distinguish remaining duration from arrival clock time. Label the clock clearly, such as `Arrives at 14:45`, and format in the user's local time convention.
- Missing or invalid distance/duration should display an unavailable/updating state, not zero or a default one minute.
- Do not decrement ETA indefinitely or present an expired estimate as fresh. Follow actual calculation/fix timestamps and the existing refresh policy.
- Apply authoritative driver-arrival status even when routing has not yet refreshed. Preserve the server's lifecycle rules.

## 6. Fix customer layout

- Keep the Wheels brand styling and existing Share Live Trip action.
- Replace driver-facing `NAVIGATING TO PICKUP` wording with customer-facing phase text.
- Keep the top status card compact and responsive, with clear time/distance hierarchy.
- Put the driver card inside appropriate bottom safe-area handling so it remains above gesture/three-button system navigation.
- Ensure the collapsed sheet fully shows its essential content. Use a scrollable expanded sheet if content exceeds available height.
- Use proper layout constraints rather than fixed widths that clip the driver name, vehicle details, OTP badge, or contact controls.
- Support small screens and increased text scale. Keep contact buttons readable and tappable.
- Place floating map controls above the current sheet height, outside system insets and away from key route content.

## 7. Customer stream lifecycle and recovery

- Filter updates to the active booking and assigned driver according to the real payload contract.
- Respect backend ordering/version information where supplied. Prevent older updates from overwriting newer state.
- Use one customer tracking subscription; clean up screen-owned listeners without disconnecting the shared socket.
- On reconnect/resume, retrieve authoritative active-booking state and latest permitted location using existing contracts.
- Show stale location/connectivity indicators based on documented freshness semantics. Server receive time alone is not proof of a fresh GPS fix.
- On cancellation/completion, remove trip-specific tracking and prevent late location or route responses from reviving it.

## 8. Backend boundary

Keep implementation in the customer application wherever the existing data supports it. Do not change working rider navigation, outbound driver location payloads, shared contracts, or backend behavior merely to restyle the screen.

If the backend does not provide a required customer location stream, status, or route/ETA source, document the exact missing contract as a dependency. Do not fabricate data or silently implement an incompatible protocol. Complete the customer work that can be done and clearly state the blocked functionality.

## 9. Verification and completion

Run Flutter analysis and relevant focused tests. Verify on a device/emulator when available:

1. Approaching pickup: continuous visible road route, driver and pickup within overview, meaningful remaining distance and ETA.
2. Short route: nonzero distance is formatted sensibly and camera is not excessively zoomed.
3. Driver arrived: correct customer wording and preserved OTP/start behavior.
4. Confirmed trip start: route and ETA switch to the destination without an old request restoring the pickup route.
5. Driver movement: marker updates smoothly without repeated camera resets or unnecessary directions requests.
6. Manual pan, follow-driver, and overview controls behave distinctly.
7. Network loss/reconnect: stale state is honest and the correct booking is recovered.
8. Completion/cancellation: no late updates revive the live trip.
9. Android gesture and three-button navigation, small screens, and increased text size: no bottom overlap or RenderFlex overflow.
10. Rider app files and functioning navigation remain unchanged.

Use simulated coordinates only for development verification and label that limitation. Finish with root cause findings, changed customer files, verification results, before/after screenshots when possible, and any concrete backend/provider dependency. Do not claim the issue is fixed solely because the UI compiles.

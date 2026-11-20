# Codex prompt: rider-style navigation after customer taps Track Vehicle

## Goal

My rider application navigation is working correctly. In the Flutter `wheels_user` customer application, make tapping **Track Vehicle** open a full-screen navigation view with the same visual experience as the working rider navigation: visible road route, moving vehicle pointer, following camera, next-turn banner, remaining distance, and ETA.

Implement this in the actual project. Inspect and reuse the working rider navigation design and compatible components where available, while preserving its behavior. The customer screen must follow the **driver's live position**, not navigate from the customer's phone position.

Read the supplied Customer Live Trip Map & Navigation Flow document, `BOOKING_WEBSOCKET_GUIDE.md`, and actual Flutter/backend contracts. Treat documentation claims and checked test boxes as inputs to verify, not proof of implementation.

## 1. Inspect the existing integration

Locate these files/classes using the repository structure:

- `LiveTripTrackingPage` in `live_trip_tracking_page.dart`.
- `BookingConfirmedPage` in `booking_confirmed_page.dart`.
- `HomePage` in `home_page.dart`.
- `ActiveBookingService` in `active_booking_service.dart`.
- `CustomerWSController` and its existing event streams.
- `NavigationService` and current OSRM route integration.
- The working rider navigation screen, if its source is available.

Use the existing state-management approach, socket service, map provider, and navigation abstractions. Inspect package versions and current official provider documentation before changing dependencies or selecting SDK features.

## 2. Track Vehicle entry flow

When the customer taps **Track Vehicle** in `BookingConfirmedPage`:

1. Resolve the authoritative active booking and current phase.
2. Open `LiveTripTrackingPage` in navigation-follow mode.
3. Load the latest valid driver location and the appropriate road route.
4. Frame the route once if needed, then smoothly follow the driver with the navigation camera.
5. Show an honest loading state until location/route data is available.

Make **Go to Active Ride** on Home open the same experience. Repeated taps must not push duplicate tracking pages.

Preserve the existing automatic transition after confirmed OTP/start. If the tracking screen is already visible, update its phase and route in place instead of pushing another copy. Coordinate Home's embedded tracking and pushed pages so only one foreground map owns camera control and screen-specific listeners.

Back navigation must not cancel the trip, disconnect the app-owned socket, or clear active-booking state. Reopening tracking must recover the current trip.

## 3. Rider-style customer navigation screen

Match the working rider navigation's visual language where source or references are available:

- Full-screen map with a prominent blue road-following route.
- One clear rotating vehicle pointer at the driver's position.
- A tilted, bearing-aware following camera showing the road ahead.
- A compact top banner containing the next maneuver arrow, distance to that maneuver, and road name when genuine guidance data is available.
- A compact summary showing remaining travel time, remaining road distance, and arrival time.
- Recenter/follow and route-overview buttons.
- A collapsible bottom panel with driver/vehicle details and existing customer trip actions.
- Existing Wheels branding, blue theme, and Share Live Trip behavior.

Keep customer actions appropriate to the customer role: existing call/chat, OTP visibility, permitted cancellation, safety, sharing, and payment behavior. Driver-only arrival/start/end controls must not appear in this screen.

The requested matching experience covers the navigation view. Customer voice guidance is optional and should be muted by default if supported; do not make it a prerequisite for route tracking.

## 4. Phase-specific routes

Map these UI concepts to the actual authoritative backend statuses:

| Trip phase | Route followed on customer map | Customer status |
| --- | --- | --- |
| Driver accepted / approaching pickup | Driver current position to pickup | Driver arriving at pickup |
| Driver arrived / waiting | Driver and pickup shown clearly; pause unnecessary guidance | Driver has arrived |
| Backend-confirmed OTP/start | Driver current position to destination | On your way to destination |
| Completed | End tracking and open existing receipt/rating flow | Trip completed |
| Cancelled | End tracking and open existing cancellation/home flow | Trip cancelled |

Do not switch phase based on notification titles, estimated arrival, or GPS proximity. On start confirmation, clear obsolete pickup guidance and reject late pickup-route responses.

## 5. Real road geometry and next-turn information

- Inspect the working route provider and reuse its real route geometry. Never use a straight line as a road route.
- Verify latitude/longitude order, polyline precision or GeoJSON format, decoded route points, and active target.
- Draw the full relevant remaining route with stable overlay identity and good contrast. Diagnose any current bug that leaves only a short segment near the driver.
- Route geometry alone is insufficient to show genuine turn instructions. Use actual maneuver/step data from the established routing provider, or an existing authorized driver route-progress broadcast.
- If using OSRM, inspect whether the current integration requests and parses route steps. Verify the actual provider response and documentation before implementing maneuver handling. Use its returned steps and geometry to calculate progress along the route; do not fabricate road names, turns, or fixed distances.
- Keep distance to the next maneuver separate from distance to the destination.
- Prefer the actual active driver route/progress when the backend exposes it. If the customer independently calculates an OSRM route while the rider uses another route/provider, do not claim the two routes or maneuvers are identical. Document that limitation and the exact shared-route dependency needed for identical guidance.
- Never feed remote driver coordinates into a navigation SDK through a production mock-location workaround. Use supported remote tracking/progress APIs or a custom tracking presentation over the map and genuine routing data.
- If maneuver data is unavailable, show the route and trip progress with an explicit guidance-unavailable state. Do not display invented turns.

## 6. Following camera and moving vehicle

- Use the backend's authorized driver location stream as the position source. Customer phone GPS must not drive the vehicle marker, camera, route origin, or ETA.
- Interpolate successive valid fixes smoothly without extrapolating indefinitely after updates stop.
- Prefer reliable provided heading; otherwise derive bearing from meaningful movement. Smooth the 359-to-0-degree transition and avoid stationary jitter.
- Use a centered vehicle icon anchor with appropriate map rotation behavior. Prevent duplicate default/custom vehicle markers.
- Place the vehicle below the unobscured viewport center, with road ahead visible. Use supported tilt/zoom and padding rather than hardcoded screen coordinates.
- Follow updates must not trigger route fit-bounds repeatedly.
- Manual pan/zoom pauses following. Recenter resumes following the driver. Route Overview explicitly fits route bounds and active endpoints.
- Account for top cards, changing bottom-sheet height, safe areas, and map controls when framing the route.
- Preserve map attribution and handle nearly coincident endpoints without excessive zoom.

## 7. Distance, ETA, and route refresh

- Use provider-derived remaining road distance/duration for the active phase.
- Use the app's established unit preference; default to meters/kilometers for the existing India experience if no preference exists. Show useful small distances, such as `250 m`, rather than `0.0 miles`.
- Format `1 min`, `5 min`, or `<1 min` appropriately. Do not use zero/one-minute defaults for missing data.
- Label the arrival clock clearly and format it in the user's local time convention.
- Refresh route/progress using the existing ownership model. Do not call routing APIs for every animation frame or every socket message.
- Debounce rerouting after sustained deviation, account for GPS accuracy, and prevent old asynchronous responses from replacing a newer route or phase.
- Associate estimates with timestamps. Display stale or unavailable values honestly rather than maintaining a misleading live countdown.
- Preserve backend fare/payment authority; customer route estimates must not alter charges.

## 8. Socket contracts and state ownership

The supplied documents contain alternative event names such as `rider.location`, `rider.location_updated`, `booking.started`, `rider.trip_started`, `booking.arrived`, and `rider.arrived`, and both `bookingId` and `booking_id` forms.

Inspect actual backend and customer handlers. Normalize only supported contracts in one existing controller/adapter. Do not assume all aliases exist or rename working backend events.

- Filter updates by the active booking and assigned driver wherever identifiers are available.
- If location messages omit booking identity, verify server-side subscription isolation and reconcile on booking changes; do not silently assume every update belongs to this trip.
- Respect existing ordering/version semantics and ignore obsolete updates.
- Reuse the app-owned socket and avoid duplicate location listeners on navigation/rebuild.
- Reconcile authoritative booking state and latest location after reconnect, resume, and restart.
- Release screen-owned animation/controllers/listeners on disposal without closing the shared socket.
- Completion/cancellation must invalidate pending route work and stop trip-specific updates from reviving the page.

## 9. Layout and stale states

- Use safe-area padding so Android system navigation does not overlap the bottom driver panel.
- Keep the collapsed sheet large enough for essential content; do not force all content into a fixed 14% height on every device.
- Support the existing intermediate and expanded sheet states, with scrolling where needed and dynamically updated map padding.
- Prevent overflow of driver name, vehicle details, OTP badge, and call/chat controls on small screens and at increased text size.
- Show separate loading, routing failure, server disconnection, and stale-location states when known.
- Use neutral wording such as `Driver location hasn't updated`. Do not diagnose weak driver connectivity from delay alone.
- Use actual freshness metadata when available. If only receipt time exists, treat it as time since receipt rather than proof of GPS fix age.
- If no valid driver position is available, show known booking endpoints and an updating state rather than substituting the customer's location or sample coordinates.

## 10. Scope protection and missing dependencies

Preserve the working rider app. Reuse compatible design/components without changing its navigation behavior. Avoid backend modifications unless a concrete missing contract prevents the requested customer tracking feature.

If the actual driver route/maneuvers cannot be obtained with existing contracts, complete the supported customer map improvements and report the precise additional payload or provider setup needed for matching guidance. Do not claim exact rider/customer route parity without evidence.

## 11. Verification and delivery

Run Flutter analysis and relevant targeted tests. Verify with a device/emulator or clearly identified development-only location traces:

1. Track Vehicle opens the full-screen rider-style customer navigation experience.
2. The marker and camera follow the driver's coordinates even when the customer phone is elsewhere.
3. Pickup phase shows an actual road route to pickup; confirmed start switches to destination without duplicate screens.
4. Next-turn data is genuine when available, and missing guidance has an honest fallback.
5. Driver movement updates the marker/camera smoothly without repeated fit-bounds or excessive routing requests.
6. Pan, Recenter, and Route Overview work as distinct modes.
7. Short distances, ETA formatting, stale updates, and reconnect recovery behave correctly.
8. Bottom-sheet content remains visible above Android system navigation on small screens and larger text settings.
9. Back/reopen, repeated taps, and duplicate socket events do not duplicate pages or subscriptions.
10. Completion/cancellation terminates customer tracking while existing rider behavior remains intact.

Finish with root causes addressed, changed files, verification results, screenshots if available, and exact remaining backend/provider dependencies. Clearly distinguish implementation from device-tested behavior. Do not mark unperformed checks as passed.

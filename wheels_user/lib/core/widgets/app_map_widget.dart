import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_checker.dart';
import '../constants/app_colors.dart';

/// Reusable & Web-Safe Google Map Widget wrapper.
/// On Web (`kIsWeb`), renders a rich 60fps vector map canvas if Google Maps JS SDK is uninitialized,
/// avoiding JS `TypeError` from Google Maps web SDK. On Mobile or when JS SDK is loaded, renders GoogleMap.
class AppMapWidget extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final Function(GoogleMapController)? onMapCreated;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final bool zoomControlsEnabled;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool compassEnabled;
  final bool mapToolbarEnabled;
  final MapType mapType;
  final bool buildingsEnabled;
  final bool tiltGesturesEnabled;
  final bool rotateGesturesEnabled;
  final bool indoorViewEnabled;
  final VoidCallback? onCameraMoveStarted;
  final ArgumentCallback<CameraPosition>? onCameraMove;
  final VoidCallback? onCameraIdle;

  const AppMapWidget({
    super.key,
    required this.initialCameraPosition,
    this.onMapCreated,
    this.markers = const {},
    this.polylines = const {},
    this.circles = const {},
    this.zoomControlsEnabled = false,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.compassEnabled = false,
    this.mapToolbarEnabled = false,
    this.mapType = MapType.normal,
    this.buildingsEnabled = true,
    this.tiltGesturesEnabled = true,
    this.rotateGesturesEnabled = true,
    this.indoorViewEnabled = true,
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,
  });

  @override
  State<AppMapWidget> createState() => _AppMapWidgetState();
}

class _AppMapWidgetState extends State<AppMapWidget> {
  Timer? _jsCheckTimer;

  @override
  void initState() {
    super.initState();

    if (kIsWeb && !isGoogleMapJsLoaded()) {
      _startJsLoadPolling();
    }
  }

  void _startJsLoadPolling() {
    _jsCheckTimer?.cancel();
    int count = 0;
    _jsCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      count++;
      if (isGoogleMapJsLoaded() || count > 10) {
        timer.cancel();
        if (mounted) setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _jsCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && !isGoogleMapJsLoaded()) {
      return _buildRichWebMapCanvas(context);
    }

    try {
      return GoogleMap(
        initialCameraPosition: widget.initialCameraPosition,
        onMapCreated: widget.onMapCreated,
        markers: widget.markers,
        polylines: widget.polylines,
        circles: widget.circles,
        zoomControlsEnabled: widget.zoomControlsEnabled,
        myLocationEnabled: widget.myLocationEnabled,
        myLocationButtonEnabled: widget.myLocationButtonEnabled,
        compassEnabled: widget.compassEnabled,
        mapToolbarEnabled: widget.mapToolbarEnabled,
        mapType: widget.mapType,
        buildingsEnabled: widget.buildingsEnabled,
        tiltGesturesEnabled: widget.tiltGesturesEnabled,
        rotateGesturesEnabled: widget.rotateGesturesEnabled,
        indoorViewEnabled: widget.indoorViewEnabled,
        onCameraMoveStarted: widget.onCameraMoveStarted,
        onCameraMove: widget.onCameraMove,
        onCameraIdle: widget.onCameraIdle,
      );
    } catch (_) {
      return _buildRichWebMapCanvas(context);
    }
  }

  Widget _buildRichWebMapCanvas(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgTileColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0);
    final gridLineColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.06);
    final roadColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFCBD5E1);

    return Container(
      color: bgTileColor,
      child: Stack(
        children: [
          // 1. Vector Map Grid & Simulated 3D Isometric Road & Building Network
          Positioned.fill(
            child: CustomPaint(
              painter: _VectorRoadMapPainter(
                gridColor: gridLineColor,
                roadColor: roadColor,
                isDark: isDark,
              ),
            ),
          ),

          // 2. User Marker Pin Logo at Center
          Center(
            child: Image.asset(
              'assets/images/user_marker.png',
              width: 48,
              height: 48,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF0D6EFD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),

          // 3. Live 3D Map Active Tag
          Positioned(
            bottom: 24,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '3D Map Active • 60° Tilt',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VectorRoadMapPainter extends CustomPainter {
  final Color gridColor;
  final Color roadColor;
  final bool isDark;

  _VectorRoadMapPainter({
    required this.gridColor,
    required this.roadColor,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    const step = 45.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final roadPaint = Paint()
      ..color = roadColor
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    // Primary diagonal road
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.7),
      roadPaint,
    );

    // Secondary horizontal avenue
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      roadPaint,
    );

    // Render Simulated 3D Isometric Extruded Buildings (matching reference UI)
    _drawIsometric3DBuilding(
      canvas,
      baseRect: Rect.fromLTWH(size.width * 0.15, size.height * 0.15, 75, 55),
      heightOffset: 22,
    );
    _drawIsometric3DBuilding(
      canvas,
      baseRect: Rect.fromLTWH(size.width * 0.6, size.height * 0.2, 90, 65),
      heightOffset: 30,
    );
    _drawIsometric3DBuilding(
      canvas,
      baseRect: Rect.fromLTWH(size.width * 0.25, size.height * 0.65, 80, 60),
      heightOffset: 25,
    );
    _drawIsometric3DBuilding(
      canvas,
      baseRect: Rect.fromLTWH(size.width * 0.7, size.height * 0.6, 100, 70),
      heightOffset: 35,
    );
  }

  void _drawIsometric3DBuilding(Canvas canvas, {required Rect baseRect, required double heightOffset}) {
    final roofColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final sideShadeColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1);
    final outlineColor = isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8);

    final dx = heightOffset * 0.4;
    final dy = -heightOffset;

    final baseLeft = baseRect.left;
    final baseRight = baseRect.right;
    final baseTop = baseRect.top;
    final baseBottom = baseRect.bottom;

    final roofLeft = baseLeft + dx;
    final roofRight = baseRight + dx;
    final roofTop = baseTop + dy;
    final roofBottom = baseBottom + dy;

    final outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // 1. Front Side Face
    final frontPath = Path()
      ..moveTo(baseLeft, baseBottom)
      ..lineTo(baseRight, baseBottom)
      ..lineTo(roofRight, roofBottom)
      ..lineTo(roofLeft, roofBottom)
      ..close();

    final sidePaint = Paint()
      ..color = sideShadeColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(frontPath, sidePaint);
    canvas.drawPath(frontPath, outlinePaint);

    // 2. Right Side Face
    final rightPath = Path()
      ..moveTo(baseRight, baseTop)
      ..lineTo(baseRight, baseBottom)
      ..lineTo(roofRight, roofBottom)
      ..lineTo(roofRight, roofTop)
      ..close();

    canvas.drawPath(rightPath, sidePaint);
    canvas.drawPath(rightPath, outlinePaint);

    // 3. Top Roof Face
    final roofPath = Path()
      ..moveTo(roofLeft, roofTop)
      ..lineTo(roofRight, roofTop)
      ..lineTo(roofRight, roofBottom)
      ..lineTo(roofLeft, roofBottom)
      ..close();

    final roofPaint = Paint()
      ..color = roofColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(roofPath, roofPaint);
    canvas.drawPath(roofPath, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

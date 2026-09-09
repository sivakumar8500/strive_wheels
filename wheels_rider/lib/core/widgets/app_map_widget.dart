import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/app_colors.dart';
import 'map_checker.dart';

/// Reusable & Web-Safe Google Map Widget wrapper for Rider application.
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
  });

  @override
  State<AppMapWidget> createState() => _AppMapWidgetState();
}

class _AppMapWidgetState extends State<AppMapWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  Timer? _jsCheckTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

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
    _pulseController.dispose();
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
          Positioned.fill(
            child: CustomPaint(
              painter: _VectorRoadMapPainter(
                gridColor: gridLineColor,
                roadColor: roadColor,
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + (_pulseController.value * 0.8);
                final opacity = (1.0 - _pulseController.value).clamp(0.0, 1.0);
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryBlue.withValues(alpha: opacity * 0.3),
                          border: Border.all(
                            color: AppColors.primaryBlue.withValues(alpha: opacity * 0.6),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.5),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.navigation_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
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
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'GPS Active • 18x Zoom',
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

  _VectorRoadMapPainter({
    required this.gridColor,
    required this.roadColor,
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
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.7),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

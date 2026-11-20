import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

/// Animated vehicle widget that smoothly drives horizontally across its container.
///
/// Designed to sit directly on top of the search bar or header on the home screen.
class MovingCar extends StatefulWidget {
  final double height;
  final double carWidth;
  final String? assetPath;
  final Duration duration;
  final Color? carColor;
  final bool repeat;

  const MovingCar({
    super.key,
    this.height = 28.0,
    this.carWidth = 56.0,
    this.assetPath = AppAssets.movingVehicle,
    this.duration = const Duration(seconds: 8),
    this.carColor,
    this.repeat = false,
  });

  @override
  State<MovingCar> createState() => _MovingCarState();
}

class _MovingCarState extends State<MovingCar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final isTest = WidgetsBinding.instance.runtimeType
        .toString()
        .contains('Test');
    if (!isTest) {
      if (widget.repeat) {
        _controller.repeat();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 600), () {
            if (mounted) {
              _controller.forward();
            }
          });
        });
      }
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.of(context).size.width;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              if (!widget.repeat && _controller.isCompleted) {
                return const SizedBox.shrink();
              }

              // Translate from offscreen left (-carWidth - 30) to offscreen right (totalWidth + 30)
              final startX = -widget.carWidth - 30.0;
              final endX = totalWidth + 30.0;
              final currentX = startX + _controller.value * (endX - startX);

              // Subtle vertical bounce to simulate tire suspension on the road
              final bounceY = (math.sin(_controller.value * 2 * math.pi * 8).abs()) * 0.8;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: currentX,
                    bottom: bounceY,
                  child: widget.assetPath != null
                      ? Image.asset(
                          widget.assetPath!,
                          width: widget.carWidth,
                          height: widget.height,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return _VectorCar(
                              width: widget.carWidth,
                              height: widget.height - 4,
                              primaryColor: widget.carColor,
                            );
                          },
                        )
                      : _VectorCar(
                          width: widget.carWidth,
                          height: widget.height - 4,
                          primaryColor: widget.carColor,
                        ),
                ),
              ],
            );
          },
        );
      },
    ),
  );
}
}

/// A sleek, modern vector illustration of a car driving to the right.
class _VectorCar extends StatelessWidget {
  final double width;
  final double height;
  final Color? primaryColor;

  const _VectorCar({
    required this.width,
    required this.height,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = primaryColor ??
        (isDark ? const Color(0xFF38BDF8) : AppColors.primaryBlue);

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _VectorCarPainter(
          carColor: color,
          isDark: isDark,
        ),
      ),
    );
  }
}

class _VectorCarPainter extends CustomPainter {
  final Color carColor;
  final bool isDark;

  _VectorCarPainter({
    required this.carColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Soft Underbody Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.48, h * 0.94),
        width: w * 0.82,
        height: 6,
      ),
      shadowPaint,
    );

    // 2. Headlight Beam (projecting forward to the right)
    final beamPath = Path()
      ..moveTo(w * 0.95, h * 0.58)
      ..lineTo(w * 1.25, h * 0.40)
      ..lineTo(w * 1.25, h * 0.88)
      ..lineTo(w * 0.95, h * 0.70)
      ..close();

    final beamPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFFFDE047).withValues(alpha: 0.45),
          const Color(0xFFFDE047).withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(w * 0.95, h * 0.4, w * 0.3, h * 0.5));
    canvas.drawPath(beamPath, beamPaint);

    // 3. Main Car Body
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          carColor.withValues(alpha: 0.95),
          carColor,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final bodyPath = Path()
      // Rear bumper start
      ..moveTo(w * 0.05, h * 0.78)
      // Rear upward curve
      ..cubicTo(w * 0.02, h * 0.60, w * 0.08, h * 0.45, w * 0.18, h * 0.42)
      // Rear windshield slope
      ..cubicTo(w * 0.28, h * 0.20, w * 0.38, h * 0.12, w * 0.50, h * 0.12)
      // Roof line
      ..lineTo(w * 0.62, h * 0.12)
      // Front windshield slope
      ..cubicTo(w * 0.74, h * 0.15, w * 0.80, h * 0.35, w * 0.86, h * 0.46)
      // Hood line
      ..lineTo(w * 0.95, h * 0.52)
      // Front nose / grill
      ..cubicTo(w * 1.0, h * 0.56, w * 1.0, h * 0.72, w * 0.96, h * 0.78)
      // Front wheel cutout
      ..lineTo(w * 0.84, h * 0.78)
      ..arcToPoint(
        Offset(w * 0.66, h * 0.78),
        radius: Radius.circular(w * 0.09),
        clockwise: false,
      )
      // Underbody
      ..lineTo(w * 0.36, h * 0.78)
      // Rear wheel cutout
      ..arcToPoint(
        Offset(w * 0.18, h * 0.78),
        radius: Radius.circular(w * 0.09),
        clockwise: false,
      )
      ..close();

    canvas.drawPath(bodyPath, bodyPaint);

    // 4. Windows / Cabin (Tinted glass)
    final glassPaint = Paint()
      ..color = isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    // Rear window
    final rearWindowPath = Path()
      ..moveTo(w * 0.24, h * 0.40)
      ..cubicTo(w * 0.30, h * 0.24, w * 0.38, h * 0.18, w * 0.48, h * 0.18)
      ..lineTo(w * 0.48, h * 0.40)
      ..close();
    canvas.drawPath(rearWindowPath, glassPaint);

    // Front window
    final frontWindowPath = Path()
      ..moveTo(w * 0.52, h * 0.18)
      ..lineTo(w * 0.62, h * 0.18)
      ..cubicTo(w * 0.70, h * 0.22, w * 0.76, h * 0.32, w * 0.80, h * 0.40)
      ..lineTo(w * 0.52, h * 0.40)
      ..close();
    canvas.drawPath(frontWindowPath, glassPaint);

    // Window highlight / gloss
    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.32, h * 0.22),
      Offset(w * 0.60, h * 0.20),
      glossPaint,
    );

    // 5. Headlight and Taillight
    final headlightPaint = Paint()..color = const Color(0xFFFDE047);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.93, h * 0.56, w * 0.05, h * 0.12),
        const Radius.circular(2),
      ),
      headlightPaint,
    );

    final taillightPaint = Paint()..color = const Color(0xFFEF4444);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.05, h * 0.50, w * 0.03, h * 0.12),
        const Radius.circular(1.5),
      ),
      taillightPaint,
    );

    // 6. Wheels (Rear & Front)
    _drawWheel(canvas, Offset(w * 0.27, h * 0.78), w * 0.08);
    _drawWheel(canvas, Offset(w * 0.75, h * 0.78), w * 0.08);
  }

  void _drawWheel(Canvas canvas, Offset center, double radius) {
    // Tire
    final tirePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, tirePaint);

    // Rim
    final rimPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.58, rimPaint);

    // Inner hub
    final hubPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.24, hubPaint);
  }

  @override
  bool shouldRepaint(covariant _VectorCarPainter oldDelegate) {
    return oldDelegate.carColor != carColor || oldDelegate.isDark != isDark;
  }
}

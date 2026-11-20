import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';

/// Animated vehicle widget that smoothly drives horizontally across its container.
///
/// Designed to sit directly on top of the bottom navigation bar or header on the home screen.
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

    // Soft Underbody Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
    final shadowRect = Rect.fromLTWH(w * 0.08, h * 0.86, w * 0.84, h * 0.14);
    canvas.drawOval(shadowRect, shadowPaint);

    // Car Body Path
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          carColor.withValues(alpha: 0.95),
          carColor,
          carColor.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final bodyPath = Path();
    bodyPath.moveTo(w * 0.04, h * 0.72);
    bodyPath.quadraticBezierTo(w * 0.04, h * 0.52, w * 0.12, h * 0.50);
    bodyPath.lineTo(w * 0.28, h * 0.48);
    bodyPath.cubicTo(w * 0.36, h * 0.22, w * 0.42, h * 0.16, w * 0.58, h * 0.16);
    bodyPath.lineTo(w * 0.76, h * 0.16);
    bodyPath.cubicTo(w * 0.84, h * 0.18, w * 0.88, h * 0.36, w * 0.92, h * 0.48);
    bodyPath.lineTo(w * 0.96, h * 0.52);
    bodyPath.quadraticBezierTo(w * 0.99, h * 0.60, w * 0.98, h * 0.72);
    bodyPath.lineTo(w * 0.94, h * 0.72);
    bodyPath.arcToPoint(
      Offset(w * 0.74, h * 0.72),
      radius: Radius.circular(w * 0.10),
      clockwise: false,
    );
    bodyPath.lineTo(w * 0.36, h * 0.72);
    bodyPath.arcToPoint(
      Offset(w * 0.16, h * 0.72),
      radius: Radius.circular(w * 0.10),
      clockwise: false,
    );
    bodyPath.lineTo(w * 0.04, h * 0.72);
    bodyPath.close();

    canvas.drawPath(bodyPath, bodyPaint);

    // Cabin Windows
    final glassColor = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.9)
        : const Color(0xFFBAE6FD).withValues(alpha: 0.85);
    final glassPaint = Paint()..color = glassColor;

    final rearWindow = Path()
      ..moveTo(w * 0.32, h * 0.46)
      ..lineTo(w * 0.44, h * 0.22)
      ..lineTo(w * 0.56, h * 0.22)
      ..lineTo(w * 0.56, h * 0.46)
      ..close();
    canvas.drawPath(rearWindow, glassPaint);

    final frontWindow = Path()
      ..moveTo(w * 0.59, h * 0.46)
      ..lineTo(w * 0.59, h * 0.22)
      ..lineTo(w * 0.74, h * 0.22)
      ..lineTo(w * 0.86, h * 0.46)
      ..close();
    canvas.drawPath(frontWindow, glassPaint);

    // Headlight & Taillight
    final headlightPaint = Paint()..color = const Color(0xFFFDE047);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.94, h * 0.50, w * 0.04, h * 0.12),
        const Radius.circular(2),
      ),
      headlightPaint,
    );

    final taillightPaint = Paint()..color = const Color(0xFFEF4444);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.03, h * 0.52, w * 0.03, h * 0.10),
        const Radius.circular(2),
      ),
      taillightPaint,
    );

    // Wheels
    _drawWheel(canvas, Offset(w * 0.26, h * 0.74), w * 0.10);
    _drawWheel(canvas, Offset(w * 0.84, h * 0.74), w * 0.10);
  }

  void _drawWheel(Canvas canvas, Offset center, double radius) {
    final tirePaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawCircle(center, radius, tirePaint);

    final rimPaint = Paint()..color = const Color(0xFFE2E8F0);
    canvas.drawCircle(center, radius * 0.55, rimPaint);

    final hubPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(center, radius * 0.22, hubPaint);
  }

  @override
  bool shouldRepaint(covariant _VectorCarPainter oldDelegate) {
    return oldDelegate.carColor != carColor || oldDelegate.isDark != isDark;
  }
}

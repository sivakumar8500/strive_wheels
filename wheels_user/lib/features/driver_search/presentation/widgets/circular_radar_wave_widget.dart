import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Animated circular wave radar widget expanding outwards around a vehicle pin icon.
class CircularRadarWaveWidget extends StatefulWidget {
  final double size;
  final IconData vehicleIcon;

  const CircularRadarWaveWidget({
    super.key,
    this.size = 280.0,
    this.vehicleIcon = Icons.directions_car_rounded,
  });

  @override
  State<CircularRadarWaveWidget> createState() => _CircularRadarWaveWidgetState();
}

class _CircularRadarWaveWidgetState extends State<CircularRadarWaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated concentric ripple waves
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RadarWavePainter(_controller.value),
              );
            },
          ),
          // Central vehicle icon container
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.35),
                  blurRadius: 16,
                  spreadRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                widget.vehicleIcon,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarWavePainter extends CustomPainter {
  final double progress;

  _RadarWavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 - 10;
    const minRadius = 40.0;
    const waveCount = 3;

    for (int i = 0; i < waveCount; i++) {
      // Stagger progress for each wave ring
      final waveProgress = (progress + (i / waveCount)) % 1.0;
      final currentRadius = minRadius + (maxRadius - minRadius) * waveProgress;

      // Fade opacity as circle grows larger
      final opacity = math.sin(waveProgress * math.pi) * 0.45;

      final paint = Paint()
        ..color = AppColors.primaryBlue.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 + (1.5 * (1.0 - waveProgress));

      canvas.drawCircle(center, currentRadius, paint);

      // Solid outer boundary guide
      if (i == waveCount - 1) {
        final outerPaint = Paint()
          ..color = AppColors.primaryBlue.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        canvas.drawCircle(center, maxRadius, outerPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RadarWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Configurable dotted/dashed divider widget supporting both horizontal
/// and vertical orientations, following app theme guidelines.
class DottedDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double dashWidth;
  final double dashSpace;
  final Color? color;
  final Axis direction;

  const DottedDivider({
    super.key,
    this.height = 1.0,
    this.thickness = 1.0,
    this.dashWidth = 4.0,
    this.dashSpace = 3.0,
    this.color,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ??
        (isDark
            ? AppColors.dividerDark.withValues(alpha: 0.6)
            : const Color(0xFFCBD5E1));

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (direction == Axis.horizontal) {
          final boxWidth = constraints.constrainWidth();
          final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
          return SizedBox(
            width: boxWidth,
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(dashCount, (_) {
                return SizedBox(
                  width: dashWidth,
                  height: thickness,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: effectiveColor),
                  ),
                );
              }),
            ),
          );
        } else {
          final boxHeight = constraints.constrainHeight();
          final dashCount = (boxHeight / (dashWidth + dashSpace)).floor();
          return SizedBox(
            width: thickness,
            height: boxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(dashCount, (_) {
                return SizedBox(
                  width: thickness,
                  height: dashWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: effectiveColor),
                  ),
                );
              }),
            ),
          );
        }
      },
    );
  }
}

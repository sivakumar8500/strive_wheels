import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/dotted_divider.dart';

/// Interactive Route Input Card matching the design reference with
/// green pickup indicator, vertical dotted connector, and orange drop indicator.
class RouteInputCard extends StatelessWidget {
  final TextEditingController pickupController;
  final TextEditingController dropController;
  final FocusNode? pickupFocusNode;
  final FocusNode? dropFocusNode;
  final ValueChanged<String>? onPickupChanged;
  final ValueChanged<String>? onDropChanged;
  final VoidCallback? onPickupTap;
  final VoidCallback? onDropTap;
  final VoidCallback? onClearDrop;
  final VoidCallback? onClearPickup;
  final bool isPickupActive;

  const RouteInputCard({
    super.key,
    required this.pickupController,
    required this.dropController,
    this.pickupFocusNode,
    this.dropFocusNode,
    this.onPickupChanged,
    this.onDropChanged,
    this.onPickupTap,
    this.onDropTap,
    this.onClearDrop,
    this.onClearPickup,
    this.isPickupActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final borderColor = isDark
        ? AppColors.dividerDark
        : const Color(0xFFE2E8F0);
    final textPrimary = isDark ? AppColors.white : AppColors.textPrimaryLight;
    final hintColor = isDark
        ? AppColors.textSecondaryDark
        : const Color(0xFF94A3B8);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Route Line Indicator (Green Dot -> Dotted Line -> Orange Dot)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pickup Circle (Green)
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF16A34A),
                    width: 3.5,
                  ),
                  color: Colors.white,
                ),
              ),
              // Vertical Dotted Connector
              const SizedBox(
                height: 28,
                child: DottedDivider(
                  direction: Axis.vertical,
                  dashWidth: 3.0,
                  dashSpace: 3.0,
                  thickness: 1.8,
                  color: Color(0xFF94A3B8),
                ),
              ),
              // Drop Circle (Orange / Terracotta)
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD9531E),
                    width: 3.5,
                  ),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Right Inputs Column (Pickup & Drop)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Pickup Input Row
                TextField(
                  key: const Key('route_pickup_text_field'),
                  controller: pickupController,
                  focusNode: pickupFocusNode,
                  onTap: onPickupTap,
                  onChanged: onPickupChanged,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    hintText: AppStrings.pickupLocation,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: hintColor,
                    ),
                    border: InputBorder.none,
                    suffixIcon: pickupController.text.isNotEmpty && isPickupActive
                        ? GestureDetector(
                            onTap: onClearPickup,
                            child: Icon(Icons.close, size: 18, color: hintColor),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ),

                // Separator Line
                Divider(
                  height: 14,
                  thickness: 1,
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFF1F5F9),
                ),

                // 2. Drop Input Row
                TextField(
                  key: const Key('route_drop_text_field'),
                  controller: dropController,
                  focusNode: dropFocusNode,
                  onTap: onDropTap,
                  onChanged: onDropChanged,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    hintText: AppStrings.dropLocation,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: hintColor,
                    ),
                    border: InputBorder.none,
                    suffixIcon: dropController.text.isNotEmpty
                        ? GestureDetector(
                            key: const Key('clear_drop_location_button'),
                            onTap: onClearDrop,
                            child: Icon(Icons.close, size: 18, color: hintColor),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

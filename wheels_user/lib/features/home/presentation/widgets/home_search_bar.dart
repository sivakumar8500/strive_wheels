import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Fully functional, interactive top floating search bar widget.
class HomeSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final VoidCallback? onMenuTap;
  final VoidCallback? onMicTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;

  const HomeSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onMenuTap,
    this.onMicTap,
    this.onNotificationTap,
    this.onAvatarTap,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  late final TextEditingController _effectiveController;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController();
    _effectiveController.addListener(_onTextChange);
  }

  void _onTextChange() {
    final text = _effectiveController.text;
    final hasText = text.isNotEmpty;
    if (hasText != _showClear) {
      setState(() {
        _showClear = hasText;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _effectiveController.dispose();
    } else {
      _effectiveController.removeListener(_onTextChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;
    final textColor = isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight;
    final hintColor = isDark ? AppColors.textSecondaryDark : AppColors.onboardingTextSecondaryLight;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Hamburger Menu
          IconButton(
            key: const Key('home_search_menu_button'),
            icon: Icon(Icons.menu, color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight),
            onPressed: widget.onMenuTap,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
            tooltip: 'Menu',
          ),

          // Search Field Prefix Icon
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: Icon(
              Icons.search,
              color: hintColor,
              size: 20,
            ),
          ),

          // Interactive Editable TextField
          Expanded(
            child: TextField(
              key: const Key('home_search_text_field'),
              controller: _effectiveController,
              onTap: widget.onTap,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.searchPlaceholder,
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: hintColor,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),

          // Clear Text Button (visible when text entered)
          if (_showClear)
            IconButton(
              key: const Key('home_search_clear_button'),
              icon: Icon(Icons.close, color: hintColor, size: 18),
              onPressed: () {
                _effectiveController.clear();
                widget.onChanged?.call('');
              },
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
              tooltip: 'Clear',
            ),

          // Microphone Icon Button
          IconButton(
            key: const Key('home_search_mic_button'),
            icon: Icon(
              Icons.mic_none_outlined,
              color: hintColor,
            ),
            onPressed: widget.onMicTap,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(6),
            tooltip: 'Voice Search',
          ),

          // Notification Bell with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                key: const Key('home_search_notifications_button'),
                icon: Icon(
                  Icons.notifications_none_outlined,
                  color: hintColor,
                ),
                onPressed: widget.onNotificationTap,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                tooltip: 'Notifications',
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 4),

          // Avatar Circle with Initials
          GestureDetector(
            key: const Key('home_search_avatar_button'),
            onTap: widget.onAvatarTap,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryBlue,
              child: Text(
                'JW',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

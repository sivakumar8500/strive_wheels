import 'package:flutter/material.dart';

/// Centralized App Colors supporting Light & Dark theme requirements.
abstract class AppColors {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF0038A8);
  static const Color accentOrange = Color(0xFFFF6600);
  static const Color darkBlue = Color(0xFF002266);

  // Gradient Colors
  static const List<Color> splashGradientLight = [
    Color(0xFFDDF0FF),
    Color(0xFF5B9DED),
    Color(0xFF1058CD),
    Color(0xFF00329A),
  ];

  static const List<Color> splashGradientDark = [
    Color(0xFF0D254C),
    Color(0xFF091B3A),
    Color(0xFF041026),
    Color(0xFF010816),
  ];

  // Theme Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0xFFE0E0E0);
  
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0BEC5);

  // Separator & Border Colors
  static const Color dividerLight = Color(0x66FFFFFF);
  static const Color dividerDark = Color(0x33FFFFFF);

  // Onboarding Colors
  static const Color onboardingBgLight = Color(0xFFF8F9FD);
  static const Color onboardingBgDark = Color(0xFF0F172A);
  static const Color onboardingTextPrimaryLight = Color(0xFF1E293B);
  static const Color onboardingTextSecondaryLight = Color(0xFF64748B);
  static const Color indicatorActive = Color(0xFF0038A8);
  static const Color indicatorInactiveLight = Color(0xFFCBD5E1);
  static const Color indicatorInactiveDark = Color(0xFF334155);
}

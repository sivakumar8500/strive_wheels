import 'package:flutter/material.dart';

/// Centralized App Colors supporting Light & Dark theme requirements.
abstract class AppColors {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF0038A8);
  static const Color accentOrange = Color(0xFFFF6600);
  static const Color darkBlue = Color(0xFF002266);

  // Surface & Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FD);
  static const Color backgroundDark = Color(0xFF0F172A);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);

  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E293B);

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
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Separator & Border Colors
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF334155);

  // Onboarding Colors
  static const Color onboardingBgLight = Color(0xFFF8F9FD);
  static const Color onboardingBgDark = Color(0xFF0F172A);
  static const Color onboardingTextPrimaryLight = Color(0xFF1E293B);
  static const Color onboardingTextSecondaryLight = Color(0xFF64748B);
  // Home Dashboard Service Colors
  static const Color bikeServiceBg = Color(0xFFE8F0FE);
  static const Color bikeServiceIcon = Color(0xFF1A73E8);
  static const Color autoServiceBg = Color(0xFFE6F4EA);
  static const Color autoServiceIcon = Color(0xFF137333);
  static const Color cabServiceBg = Color(0xFFEEF2FF);
  static const Color cabServiceIcon = Color(0xFF4F46E5);
  static const Color rentalServiceBg = Color(0xFFFEF7E0);
  static const Color rentalServiceIcon = Color(0xFFB06000);
  static const Color parcelServiceBg = Color(0xFFFCE8E6);
  static const Color parcelServiceIcon = Color(0xFFC5221F);
  static const Color courierServiceBg = Color(0xFFE6FFFA);
  static const Color courierServiceIcon = Color(0xFF0D9488);
  static const Color airportServiceBg = Color(0xFFF3E8FF);
  static const Color airportServiceIcon = Color(0xFF7E22CE);
  static const Color corporateServiceBg = Color(0xFFF1F5F9);
  static const Color corporateServiceIcon = Color(0xFF475569);

  // Home Offer Gradient
  static const List<Color> offerCardGradient = [
    Color(0xFF0F4CBA),
    Color(0xFF002673),
  ];

  // Surface & Card Colors
  static const Color cardBgLight = Color(0xFFF3F4F6);
  static const Color cardBgDark = Color(0xFF1E293B);
  static const Color serviceTileBgLight = Color(0xFFFFFFFF);
  static const Color serviceTileBgDark = Color(0xFF1E293B);

  // History & Favourites & Settings Colors
  static const Color completedGreen = Color(0xFF16A34A);
  static const Color filterBgLight = Color(0xFFF1F5F9);
  static const Color filterBgDark = Color(0xFF1E293B);
  static const Color miniServiceBg = Color(0xFFEEF2FF);
  static const Color miniServiceIcon = Color(0xFF4F46E5);

  static const Color favouriteHeartBg = Color(0xFFFFE4E6);
  static const Color favouriteHeartIcon = Color(0xFFF43F5E);
  static const Color shortcutShelfBgLight = Color(0xFFEBF3FF);
  static const Color logoutBgLight = Color(0xFFFFE4E6);
  static const Color logoutText = Color(0xFFDC2626);

  // Booking & Vehicle Search Colors
  static const Color pickupBlueRing = Color(0xFF0066FF);
  static const Color destinationRedPin = Color(0xFFDC2626);
  static const Color rideTypeActiveBg = Color(0xFF0066FF);
  static const Color rideTypeInactiveBg = Color(0xFFF1F5F9);

  static const Color indicatorActive = Color(0xFF0038A8);
  static const Color indicatorInactiveLight = Color(0xFFCBD5E1);
  static const Color indicatorInactiveDark = Color(0xFF334155);
}

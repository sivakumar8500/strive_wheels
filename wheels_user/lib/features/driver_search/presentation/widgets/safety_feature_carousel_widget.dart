import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class SafetyCardItem {
  final String category;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color iconBgColor;

  const SafetyCardItem({
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.accentColor,
    required this.iconBgColor,
  });
}

/// A dynamic 4-card carousel showcasing ride safety, verified captains,
/// live tracking, and upfront pricing while searching for drivers.
class SafetyFeatureCarouselWidget extends StatefulWidget {
  const SafetyFeatureCarouselWidget({super.key});

  @override
  State<SafetyFeatureCarouselWidget> createState() =>
      _SafetyFeatureCarouselWidgetState();
}

class _SafetyFeatureCarouselWidgetState
    extends State<SafetyFeatureCarouselWidget> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  static const List<SafetyCardItem> _cards = [
    SafetyCardItem(
      category: 'SAFETY FIRST',
      title: '100% Verified Captains',
      description:
          'Background-checked & professionally vetted drivers for your peace of mind.',
      icon: Icons.verified_user_rounded,
      gradientColors: [Color(0xFF0F2756), Color(0xFF1E3A8A)],
      accentColor: Color(0xFF60A5FA),
      iconBgColor: Color(0xFF1E40AF),
    ),
    SafetyCardItem(
      category: '24x7 MONITORING',
      title: 'Live GPS & Emergency SOS',
      description:
          'Share real-time trip status with family with instant 1-tap emergency support.',
      icon: Icons.shield_rounded,
      gradientColors: [Color(0xFF064E3B), Color(0xFF047857)],
      accentColor: Color(0xFF34D399),
      iconBgColor: Color(0xFF059669),
    ),
    SafetyCardItem(
      category: 'PREMIUM COMFORT',
      title: 'Clean & Sanitized Fleet',
      description:
          'AC-inspected, spotless interiors and well-maintained rides every single time.',
      icon: Icons.auto_awesome_rounded,
      gradientColors: [Color(0xFF7C2D12), Color(0xFFC2410C)],
      accentColor: Color(0xFFFDBA74),
      iconBgColor: Color(0xFFEA580C),
    ),
    SafetyCardItem(
      category: 'TRANSPARENT FARES',
      title: 'Guaranteed Upfront Pricing',
      description:
          'Zero hidden charges and no unexpected surge price fluctuations.',
      icon: Icons.price_check_rounded,
      gradientColors: [Color(0xFF4C1D95), Color(0xFF6D28D9)],
      accentColor: Color(0xFFA78BFA),
      iconBgColor: Color(0xFF7C3AED),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 3800), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final nextPage = (_currentPage + 1) % _cards.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 124,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              final item = _cards[index];
              return _buildCarouselCard(item, isDark);
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _cards.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.primaryBlue
                    : (isDark
                        ? const Color(0xFF475569)
                        : const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselCard(SafetyCardItem item, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  item.gradientColors[0].withValues(alpha: 0.9),
                  item.gradientColors[1].withValues(alpha: 0.8),
                ]
              : [
                  item.gradientColors[0],
                  item.gradientColors[1],
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: item.gradientColors[0].withValues(alpha: isDark ? 0.4 : 0.25),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background decorative glow shapes
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Left-side safety artwork & glowing icon container
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: item.iconBgColor.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        item.icon,
                        color: Colors.white.withValues(alpha: 0.2),
                        size: 40,
                      ),
                      Icon(
                        item.icon,
                        color: Colors.white,
                        size: 26,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                // Right-side text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: item.accentColor.withValues(alpha: 0.4),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          item.category,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: item.accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          height: 1.25,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
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

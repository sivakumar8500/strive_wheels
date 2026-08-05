import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/splash_bloc.dart';
import '../bloc/splash_event.dart';
import '../bloc/splash_state.dart';

/// Splash Screen page matching exact design layout guidelines.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(const StartSplashEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDark
        ? AppColors.splashGradientDark
        : AppColors.splashGradientLight;

    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashCompleted) {
          // Navigation logic after splash screen completes
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Center Brand Icon & Title
                _buildCenterLogo(),

                const Spacer(flex: 3),

                // Bottom Footer Section
                _buildFooterSection(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppAssets.splashLogo,
          width: 240,
          height: 240,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.appName,
          style: GoogleFonts.poppins(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.35),
                offset: const Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Owned by Column
          Expanded(
            child: _buildFooterBrandColumn(
              title: AppStrings.ownedBy,
              logoAsset: AppAssets.striveLogo,
              brandName: AppStrings.striveGroup,
              subText: AppStrings.striveSubtext,
            ),
          ),

          // Central Vertical Divider with Accent Dots
          _buildCenterDivider(),

          // Backed by Column
          Expanded(
            child: _buildFooterBrandColumn(
              title: AppStrings.backedBy,
              logoAsset: AppAssets.infinitumLogo,
              brandName: AppStrings.infinitumTechniques,
              subText: AppStrings.infinitumSubtext,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterBrandColumn({
    required String title,
    required String logoAsset,
    required String brandName,
    required String subText,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            logoAsset,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          brandName,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        Text(
          subText,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w300,
            color: AppColors.white.withValues(alpha: 0.75),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCenterDivider() {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.arrow_drop_up,
            size: 14,
            color: AppColors.white.withValues(alpha: 0.7),
          ),
          Container(
            width: 1,
            height: 25,
            color: AppColors.white.withValues(alpha: 0.4),
          ),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 1,
            height: 25,
            color: AppColors.white.withValues(alpha: 0.4),
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 14,
            color: AppColors.white.withValues(alpha: 0.7),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../registration/domain/usecases/submit_instant_registration_usecase.dart';
import '../../../registration/presentation/pages/registration_page.dart';

class RegistrationLandingPage extends StatefulWidget {
  final String phoneNumber;

  const RegistrationLandingPage({super.key, required this.phoneNumber});

  @override
  State<RegistrationLandingPage> createState() => _RegistrationLandingPageState();
}

class _RegistrationLandingPageState extends State<RegistrationLandingPage> {
  bool _isLoading = false;

  Future<void> _handleInstantRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final useCase = sl<SubmitInstantRegistrationUseCase>();
      final response = await useCase();
      
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      final targetStep = response.data?.nextStep ?? 2;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegistrationPage(
            phoneNumber: widget.phoneNumber,
            initialStep: targetStep,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      // Show error snackbar or proceed to registration page gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration setup failed: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.onboardingBgDark : AppColors.onboardingBgLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Illustration
                Center(
                  child: Image.asset(
                    'assets/images/registration_landing.png', // Placeholder for the actual image
                    height: 240,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 240,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.directions_car,
                          size: 80,
                          color: AppColors.primaryBlue,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: isDark
                          ? AppColors.white
                          : AppColors.darkBlue, // Using dark blue based on design
                    ),
                    children: [
                      const TextSpan(text: 'Drive with\n'),
                      TextSpan(
                        text: 'DrivePro',
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryBlue,
                          decorationThickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Join our community of elite drivers and earn on your own terms.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.onboardingTextSecondaryLight,
                  ),
                ),
                const SizedBox(height: 24),

                // Features Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.25,
                  children: [
                    _buildFeatureCard(
                      context,
                      icon: Icons.trending_up,
                      title: 'Earn More',
                      subtitle: 'Industry leading commission rates.',
                      isDark: isDark,
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.access_time,
                      title: 'Flexible',
                      subtitle: 'Drive when you want.',
                      isDark: isDark,
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.shield_outlined,
                      title: 'Safe Platform',
                      subtitle: '24/7 emergency support.',
                      isDark: isDark,
                    ),
                    _buildFeatureCard(
                      context,
                      icon: Icons.credit_card,
                      title: 'Weekly Payouts',
                      subtitle: 'Direct deposit every Tuesday.',
                      isDark: isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Register Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleInstantRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1), // Darker blue for button based on design
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Register as Driver',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Terms and Privacy
                Text(
                  'BY CONTINUING, YOU AGREE TO DRIVEPRO\'S TERMS OF SERVICE AND PRIVACY POLICY.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondaryDark.withValues(alpha: 0.7)
                        : AppColors.onboardingTextSecondaryLight.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.onboardingTextSecondaryLight,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

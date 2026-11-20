import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_phone_input.dart';
import '../../../../core/di/injection_container.dart';
import '../../../otp/presentation/bloc/otp_bloc.dart';
import '../../../otp/presentation/pages/otp_verification_page.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

/// Welcome Back (Mobile Login) Page matching the exact reference UI design.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.onboardingBgDark
        : AppColors.onboardingBgLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              (!previous.isSuccess && current.isSuccess) ||
              (current.errorMessage != null &&
                  current.errorMessage != previous.errorMessage),
          listener: (context, state) {
            if (state.isSuccess) {
              final fullPhone = '${state.countryCode}${state.phoneNumber}';
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider<OtpBloc>(
                    create: (_) => sl<OtpBloc>(param1: fullPhone),
                    child: const OtpVerificationPage(),
                  ),
                ),
              );
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Top Header Illustration
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: Image.asset(
                        AppAssets.loginIllustration,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.phonelink_lock,
                            size: 140,
                            color: AppColors.primaryBlue,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Welcome Back Header Title
                  Text(
                    AppStrings.welcomeBack,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: isDark
                          ? AppColors.white
                          : AppColors.onboardingTextPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    AppStrings.bookRidesInSeconds,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.onboardingTextSecondaryLight,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Phone Number Input Component
                  AppPhoneInput(
                    controller: _phoneController,
                    selectedCountryCode: state.countryCode,
                    onChanged: (value) {
                      context
                          .read<LoginBloc>()
                          .add(PhoneNumberChangedEvent(value));
                    },
                  ),

                  const SizedBox(height: 32),

                  // Continue Action Button
                  AppButton(
                    title: AppStrings.continueButton,
                    isEnabled: state.isPhoneNumberValid,
                    isLoading: state.isSubmitting,
                    onTap: () {
                      context.read<LoginBloc>().add(const SubmitLoginEvent());
                    },
                  ),

                  const SizedBox(height: 24),

                  // Terms & Privacy Notice
                  Center(
                    child: _buildTermsAndPrivacyText(context, isDark),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacyText(BuildContext context, bool isDark) {
    final defaultStyle = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: isDark
          ? AppColors.textSecondaryDark
          : AppColors.onboardingTextSecondaryLight,
    );

    final linkStyle = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
      decoration: TextDecoration.underline,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultStyle,
        children: [
          const TextSpan(text: AppStrings.byContinuing),
          TextSpan(
            text: AppStrings.termsAndConditions,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Terms & Conditions tapped')),
                );
              },
          ),
          const TextSpan(text: AppStrings.andWord),
          TextSpan(
            text: AppStrings.privacyPolicy,
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy Policy tapped')),
                );
              },
          ),
        ],
      ),
    );
  }
}

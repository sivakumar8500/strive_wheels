import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_otp_input.dart';
import '../../../../core/di/injection_container.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/pages/notification_permission_page.dart';
import '../bloc/otp_bloc.dart';
import '../bloc/otp_event.dart';
import '../bloc/otp_state.dart';

/// Verify Your Number (OTP Verification) Screen matching design layout guidelines.
class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({super.key});

  String _formatPhoneNumber(String fullPhone) {
    // Format "+919876543210" as "+91 98765 43210"
    if (fullPhone.length >= 13) {
      final code = fullPhone.substring(0, 3);
      final p1 = fullPhone.substring(3, 8);
      final p2 = fullPhone.substring(8);
      return '$code $p1 $p2';
    }
    return fullPhone;
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
        child: BlocConsumer<OtpBloc, OtpState>(
          listenWhen: (previous, current) =>
              (!previous.isSuccess && current.isSuccess) ||
              (current.errorMessage != null &&
                  current.errorMessage != previous.errorMessage),
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => BlocProvider<NotificationBloc>(
                    create: (_) => sl<NotificationBloc>(),
                    child: const NotificationPermissionPage(),
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
            final timerString =
                '00:${state.countdownSeconds.toString().padLeft(2, '0')}';
            final canResend = state.countdownSeconds == 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Header Illustration
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 240),
                      child: Image.asset(
                        AppAssets.otpIllustration,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.verified_user,
                            size: 140,
                            color: AppColors.primaryBlue,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  Text(
                    AppStrings.verifyYourNumber,
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

                  // Subtitle & Edit Phone Number Row
                  Text(
                    AppStrings.weSentVerificationCodeTo,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.onboardingTextSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _formatPhoneNumber(state.fullPhoneNumber),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.white
                                : AppColors.onboardingTextPrimaryLight,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: AppStrings.editLink,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pop();
                            },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // 6-digit OTP Box Input Field Component
                  AppOtpInput(
                    length: 6,
                    onChanged: (code) {
                      context.read<OtpBloc>().add(OtpCodeChangedEvent(code));
                    },
                    onCompleted: (code) {
                      context.read<OtpBloc>().add(const SubmitOtpEvent());
                    },
                  ),

                  const SizedBox(height: 24),

                  // Resend Code & Countdown Row
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timerString,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.onboardingTextSecondaryLight,
                          ),
                        ),
                        const SizedBox(width: 24),
                        GestureDetector(
                          onTap: canResend
                              ? () {
                                  context
                                      .read<OtpBloc>()
                                      .add(const ResendOtpEvent());
                                }
                              : null,
                          child: Text(
                            AppStrings.resendCode,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: canResend
                                  ? AppColors.primaryBlue
                                  : (isDark
                                      ? AppColors.indicatorInactiveDark
                                      : AppColors.indicatorInactiveLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Verify Action Button
                  AppButton(
                    title: AppStrings.verifyButton,
                    isEnabled: state.isOtpValid,
                    isLoading: state.isSubmitting,
                    onTap: () {
                      context.read<OtpBloc>().add(const SubmitOtpEvent());
                    },
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
}

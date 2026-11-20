import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_phone_input.dart';
import '../../../../core/widgets/app_otp_input.dart';
import '../../../otp/presentation/bloc/otp_bloc.dart';
import '../../../otp/presentation/bloc/otp_event.dart';
import '../../../otp/presentation/bloc/otp_state.dart';
import '../../../permissions/presentation/bloc/permissions_bloc.dart';
import '../../../permissions/presentation/pages/permissions_page.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final TextEditingController _phoneController;
  bool _showOtp = false;
  String _fullPhone = '';

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
    final backgroundColor =
        isDark ? AppColors.onboardingBgDark : AppColors.onboardingBgLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showOtp
              ? BlocProvider<OtpBloc>(
                  key: const ValueKey('otp_view'),
                  create: (_) => sl<OtpBloc>(param1: _fullPhone),
                  child: _OtpVerificationView(
                    onEditPhone: () {
                      setState(() {
                        _showOtp = false;
                      });
                    },
                  ),
                )
              : _LoginView(
                  key: const ValueKey('login_view'),
                  phoneController: _phoneController,
                  onLoginSuccess: (fullPhone) {
                    setState(() {
                      _fullPhone = fullPhone;
                      _showOtp = true;
                    });
                  },
                ),
        ),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  final TextEditingController phoneController;
  final ValueChanged<String> onLoginSuccess;

  const _LoginView({
    super.key,
    required this.phoneController,
    required this.onLoginSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          (!previous.isSuccess && current.isSuccess) ||
          (current.errorMessage != null &&
              current.errorMessage != previous.errorMessage),
      listener: (context, state) {
        if (state.isSuccess) {
          onLoginSuccess(state.phoneNumber);
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
        return Column(
          children: [
            // Image Section
            Expanded(
              flex: 6,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
            ),
            // Content Section
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.welcomeBack,
                      style: GoogleFonts.poppins(
                        fontSize: 31,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: isDark
                            ? AppColors.white
                            : AppColors.onboardingTextPrimaryLight,
                      ),
                    ),
                    Text(
                      AppStrings.bookRidesInSeconds,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.onboardingTextSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppPhoneInput(
                      controller: phoneController,
                      selectedCountryCode: state.countryCode,
                      onChanged: (value) {
                        context.read<LoginBloc>().add(PhoneNumberChangedEvent(value));
                      },
                    ),
                    const SizedBox(height: 15),
                    AppButton(
                      title: AppStrings.continueButton,
                      isEnabled: state.isPhoneNumberValid,
                      isLoading: state.isSubmitting,
                      onTap: () {
                        context.read<LoginBloc>().add(const SubmitLoginEvent());
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: _buildTermsAndPrivacyText(context, isDark),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTermsAndPrivacyText(BuildContext context, bool isDark) {
    final defaultStyle = GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: isDark ? AppColors.textSecondaryDark : AppColors.onboardingTextSecondaryLight,
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
          const TextSpan(text: '${AppStrings.byContinuing}\n'),
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

class _OtpVerificationView extends StatelessWidget {
  final VoidCallback onEditPhone;

  const _OtpVerificationView({
    super.key,
    required this.onEditPhone,
  });

  String _formatPhoneNumber(String fullPhone) {
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

    return BlocConsumer<OtpBloc, OtpState>(
      listenWhen: (previous, current) =>
          (!previous.isSuccess && current.isSuccess) ||
          (current.errorMessage != null &&
              current.errorMessage != previous.errorMessage),
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BlocProvider<PermissionsBloc>(
                create: (_) => sl<PermissionsBloc>(),
                child: const PermissionsPage(),
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
        final timerString = '00:${state.countdownSeconds.toString().padLeft(2, '0')}';
        final canResend = state.countdownSeconds == 0;

        return Column(
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                            recognizer: TapGestureRecognizer()..onTap = onEditPhone,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppOtpInput(
                      length: 6,
                      onChanged: (code) {
                        context.read<OtpBloc>().add(OtpCodeChangedEvent(code));
                      },
                      onCompleted: (code) {
                        context.read<OtpBloc>().add(const SubmitOtpEvent());
                      },
                    ),
                    const SizedBox(height: 20),
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
                                    context.read<OtpBloc>().add(const ResendOtpEvent());
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
                    const SizedBox(height: 24),
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
              ),
            ),
          ],
        );
      },
    );
  }
}

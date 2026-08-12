import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  void _validatePhone() {
    final isValid = _phoneController.text.trim().length == 10;
    if (_isPhoneValid != isValid) {
      setState(() {
        _isPhoneValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinuePressed() {
    FocusScope.of(context).unfocus();
    context.read<LoginBloc>().add(LoginSubmitted(_phoneController.text));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.onboardingBgDark
        : AppColors.onboardingBgLight;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpPage(phoneNumber: _phoneController.text),
            ),
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Center the illustration using Expanded
                          Expanded(
                            child: Center(
                              child: Image.asset(
                                AppAssets.loginIcon,
                                height: 250,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),

                          // Welcome Titles
                          Text(
                            AppStrings.welcomeBack,
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.onboardingTextPrimaryLight,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.bookRidesSubtext,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.onboardingTextSecondaryLight,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 32),

                          // Phone Number Input field
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.dividerDark
                                    : AppColors.dividerLight,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Country Code Selector
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '+91',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? AppColors.white
                                              : AppColors
                                                    .onboardingTextPrimaryLight,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: isDark
                                            ? AppColors.white
                                            : AppColors
                                                  .onboardingTextPrimaryLight,
                                      ),
                                    ],
                                  ),
                                ),
                                // Divider
                                Container(
                                  width: 1,
                                  height: 32,
                                  color: isDark
                                      ? AppColors.dividerDark
                                      : AppColors.dividerLight,
                                ),
                                const SizedBox(width: 16),
                                // Phone input
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.white
                                          : AppColors
                                                .onboardingTextPrimaryLight,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: AppStrings.enterMobileNumber,
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : AppColors
                                                  .onboardingTextSecondaryLight,
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Continue Button
                          BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              final isLoading = state is LoginLoading;
                              return SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: (isLoading || !_isPhoneValid)
                                      ? null
                                      : _onContinuePressed,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.indicatorActive,
                                    foregroundColor: AppColors.white,
                                    disabledBackgroundColor: AppColors
                                        .indicatorActive
                                        .withOpacity(0.5),
                                    disabledForegroundColor: AppColors.white
                                        .withOpacity(0.7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          AppStrings.continueBtn,
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),

                          // Terms & Privacy Note
                          _buildTermsAndPrivacy(isDark),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndPrivacy(bool isDark) {
    final textColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.onboardingTextSecondaryLight;
    final linkColor = AppColors.indicatorActive;

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 1.5,
        ),
        children: [
          const TextSpan(text: AppStrings.byContinuing),
          const TextSpan(text: '\n'),
          TextSpan(
            text: AppStrings.termsConditions,
            style: TextStyle(color: linkColor, fontWeight: FontWeight.w600),
          ),
          const TextSpan(text: ' ${AppStrings.and} '),
          TextSpan(
            text: AppStrings.privacyPolicy,
            style: TextStyle(color: linkColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

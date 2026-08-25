import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/otp_bloc.dart';
import '../bloc/otp_event.dart';
import '../bloc/otp_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../home/presentation/pages/home_page.dart';
import 'registration_landing_page.dart';
import 'registration_page.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _pinController = TextEditingController();
  Timer? _timer;
  int _start = 11;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 11; // Setting to 11 to match image design
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.onboardingBgDark
        : AppColors.onboardingBgLight;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.inter(
        fontSize: 24,
        color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primaryBlue),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.primaryBlue),
      ),
    );

    return BlocProvider(
      create: (_) => sl<OtpBloc>(),
      child: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state is OtpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP Verified Successfully!')),
            );
            
            final authStatus = state.authResult.authStatus;
            final currentStep = state.authResult.currentStep ?? 1;

            if (authStatus == AuthStatus.approved) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            } else if (authStatus == AuthStatus.registrationDraft) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => RegistrationPage(
                    phoneNumber: widget.phoneNumber,
                    initialStep: currentStep,
                  ),
                ),
                (route) => false,
              );
            } else if (authStatus == AuthStatus.registrationSubmitted) {
              // TODO: Navigate to Pending Approval Screen. 
              // For now, redirect to Landing Page to show status.
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => RegistrationLandingPage(phoneNumber: widget.phoneNumber)),
              );
            } else {
              // Covers registrationPending, registrationRejected, and default
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => RegistrationLandingPage(phoneNumber: widget.phoneNumber)),
              );
            }
          } else if (state is OtpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is OtpResendSuccess) {
            startTimer();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('OTP Resent!')));
          }
        },
        builder: (context, state) {
          final isLoading = state is OtpLoading;

          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark
                      ? AppColors.white
                      : AppColors.onboardingTextPrimaryLight,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Top Illustration
                              Expanded(
                                child: Center(
                                  // Placeholder for the illustration you provided
                                  child: Image.asset(
                                    AppAssets.otpIllustration, // Uses the new illustration
                                    height: 250,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback to the shield if image is not found
                                      return Container(
                                        width: 140,
                                        height: 140,
                                        decoration: BoxDecoration(
                                          color: AppColors.accentOrange
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.security_rounded,
                                              size: 80,
                                              color: AppColors.primaryBlue,
                                            ),
                                            Positioned(
                                              top: 55,
                                              child: Icon(
                                                Icons.check_rounded,
                                                size: 40,
                                                color: AppColors.accentOrange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 48),

                              // Title
                              Text(
                                'Verify Your Number',
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

                              // Subtitle
                              Text(
                                "We've sent a verification code to",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.onboardingTextSecondaryLight,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    widget.phoneNumber,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.white
                                          : AppColors
                                                .onboardingTextPrimaryLight,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Text(
                                      'Edit',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // OTP Input
                              Pinput(
                                length: 6,
                                controller: _pinController,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: focusedPinTheme,
                                submittedPinTheme: submittedPinTheme,
                                pinputAutovalidateMode:
                                    PinputAutovalidateMode.onSubmit,
                                showCursor: true,
                                onChanged: (value) {
                                  context.read<OtpBloc>().add(
                                    OtpCodeChanged(value),
                                  );
                                },
                              ),
                              const SizedBox(height: 32),

                              // Timer and Resend
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '00:${_start.toString().padLeft(2, '0')}',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors
                                                .onboardingTextSecondaryLight,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: _start == 0 && !isLoading
                                        ? () {
                                            context.read<OtpBloc>().add(
                                              OtpResendRequested(
                                                widget.phoneNumber,
                                              ),
                                            );
                                          }
                                        : null,
                                    child: Text(
                                      'Resend Code',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: _start == 0
                                            ? AppColors.primaryBlue
                                            : (isDark
                                                  ? AppColors.textSecondaryDark
                                                  : AppColors
                                                        .indicatorInactiveLight),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Verify Button
                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed:
                                      (_pinController.text.length == 6 &&
                                          !isLoading)
                                      ? () {
                                          context.read<OtpBloc>().add(
                                            OtpSubmitted(
                                              phoneNumber: widget.phoneNumber,
                                              otpCode: _pinController.text,
                                            ),
                                          );
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.indicatorActive,
                                    foregroundColor: AppColors.white,
                                    disabledBackgroundColor: AppColors
                                        .indicatorInactiveLight, // Exact gray from image
                                    disabledForegroundColor: AppColors.white,
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
                                          'Verify',
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

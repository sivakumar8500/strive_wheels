import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../bloc/registration_bloc.dart';
import '../../bloc/registration_event.dart';

class Step8FinalVerification extends StatefulWidget {
  const Step8FinalVerification({super.key});

  @override
  State<Step8FinalVerification> createState() => _Step8FinalVerificationState();
}

class _Step8FinalVerificationState extends State<Step8FinalVerification> {
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    final data = context.read<RegistrationBloc>().state.data;
    _agreedToTerms = data.agreedToTerms;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final data = context.read<RegistrationBloc>().state.data;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Final Verification',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please review all submitted details before finalizing your driver registration.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            _buildReviewCard(
              isDark: isDark,
              icon: Icons.person,
              title: 'Personal Info',
              subtitle: 'Verified',
              subtitleColor: AppColors.primaryBlue,
              subtitleIcon: Icons.check_circle,
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              isDark: isDark,
              icon: Icons.home,
              title: 'Residential Address',
              subtitle: '${data.houseNo ?? ''} ${data.streetName ?? ''}, ${data.city ?? ''}'.trim().isNotEmpty ? '${data.houseNo ?? ''} ${data.streetName ?? ''}, ${data.city ?? ''}' : 'Not provided',
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              isDark: isDark,
              icon: Icons.badge,
              title: 'KYC Documents',
              subtitle: 'APPROVED',
              isBadge: true,
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              isDark: isDark,
              icon: Icons.directions_car,
              title: 'Vehicle Details',
              subtitle:
                  '${data.vehicleManufacturer ?? ''} ${data.vehicleModel ?? ''} (${data.vehicleYear ?? ''}) • ${data.vehicleRegNumber ?? ''}',
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              isDark: isDark,
              icon: Icons.description,
              title: 'Vehicle Documents',
              subtitle: 'Insurance, Registration attached',
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              isDark: isDark,
              icon: Icons.account_balance,
              title: 'Payout Account',
              subtitle:
                  '${data.bankName ?? ''} **** ${data.bankAccountNumber?.length != null && data.bankAccountNumber!.length >= 4 ? data.bankAccountNumber!.substring(data.bankAccountNumber!.length - 4) : ''}',
            ),
            const SizedBox(height: 16),
            _buildReviewCard(
              isDark: isDark,
              icon: Icons.security,
              title: 'Emergency Contact',
              subtitle:
                  '${data.emergencyContactName ?? ''} (${data.emergencyContactRelation ?? ''})',
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark
                    : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.dividerLight),
                    ),
                    child: Icon(
                      Icons.shield,
                      color: AppColors.darkBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enterprise-Grade Security',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your data is encrypted with AES-256 and stored securely. By submitting, you confirm all details provided are legally accurate.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: _agreedToTerms,
                    onChanged: (val) {
                      setState(() {
                        _agreedToTerms = val ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: 'I agree to the ',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.primaryBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(text: ' and understand the '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.primaryBlue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        const TextSpan(
                          text: ' regarding driver data collection.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _agreedToTerms
                    ? () {
                        context.read<RegistrationBloc>().add(
                          AgreeToTermsEvent(_agreedToTerms),
                        );
                        // Trigger final submission here and navigate to success screen
                        context.read<RegistrationBloc>().add(NextStepEvent());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: isDark
                      ? AppColors.surfaceDark
                      : Colors.grey.shade300,
                  disabledForegroundColor: isDark
                      ? AppColors.textSecondaryDark
                      : Colors.grey.shade500,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save & Continue',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    Color? subtitleColor,
    IconData? subtitleIcon,
    bool isBadge = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.darkBlue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                if (isBadge)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      if (subtitleIcon != null) ...[
                        Icon(
                          subtitleIcon,
                          color: subtitleColor ?? AppColors.primaryBlue,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color:
                                subtitleColor ??
                                (isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight),
                            fontWeight: subtitleColor != null
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Text(
            'Edit',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class CorporateDetailsCard extends StatelessWidget {
  final String companyName;
  final String? corporateEmail;
  final String? corporateId;
  final String? department;
  final String? designation;

  const CorporateDetailsCard({
    super.key,
    required this.companyName,
    this.corporateEmail,
    this.corporateId,
    this.department,
    this.designation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardBgDark : Colors.white;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.business_center_rounded,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Collaborated Company',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Verified',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _CorporateRow(
            icon: Icons.apartment_rounded,
            label: 'Company',
            value: companyName,
            isDark: isDark,
          ),
          if (corporateEmail != null && corporateEmail!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _CorporateRow(
              icon: Icons.mark_email_read_rounded,
              label: 'Work Email',
              value: corporateEmail!,
              isDark: isDark,
            ),
          ],
          if (corporateId != null && corporateId!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _CorporateRow(
              icon: Icons.badge_outlined,
              label: 'Employee ID',
              value: corporateId!,
              isDark: isDark,
            ),
          ],
          if (department != null && department!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _CorporateRow(
              icon: Icons.account_tree_outlined,
              label: 'Department',
              value: department!,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }
}

class _CorporateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _CorporateRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? AppColors.textSecondaryDark : AppColors.onboardingTextSecondaryLight,
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textSecondaryDark : AppColors.onboardingTextSecondaryLight,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
            ),
          ),
        ),
      ],
    );
  }
}

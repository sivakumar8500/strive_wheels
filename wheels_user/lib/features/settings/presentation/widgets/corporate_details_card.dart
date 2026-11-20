import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';

class CorporateDetailsCard extends StatelessWidget {
  final String companyName;
  final String? corporateEmail;
  final String? corporateId;
  final String? department;
  final String? designation;
  final String? spendingLimit;
  final String? location;

  const CorporateDetailsCard({
    super.key,
    required this.companyName,
    this.corporateEmail,
    this.corporateId,
    this.department,
    this.designation,
    this.spendingLimit,
    this.location,
  });

  static String _formatSpendingLimit(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
    final parsed = double.tryParse(cleaned);
    if (parsed == null) return raw.startsWith('₹') ? raw : '₹$raw';

    if (parsed == parsed.roundToDouble()) {
      return '₹${_formatWithCommas(parsed.toInt())}';
    }
    return '₹${_formatWithCommas(parsed.toInt())}.${(parsed % 1 * 100).round().toString().padLeft(2, '0')}';
  }

  static String _formatWithCommas(int value) {
    final str = value.toString();
    final reg = RegExp(r'(\d+?)(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

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
          color: AppColors.primaryBlue.withValues(alpha: 0.18),
          width: 1.2,
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
          // 1. Header with single Row and Expanded title to prevent overflow
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
              Expanded(
                child: Text(
                  'Collaborated Company',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
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
                      size: 13,
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

          // 2. Featured Company Showcase Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.apartment_rounded,
                      size: 18,
                      color: Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        companyName,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (location != null && location!.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.onboardingTextSecondaryLight,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location!.trim(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.onboardingTextSecondaryLight,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 3. Employee Info Metadata Rows
          if (corporateEmail != null && corporateEmail!.trim().isNotEmpty) ...[
            _CorporateRow(
              icon: Icons.mark_email_read_rounded,
              label: 'Work Email',
              value: corporateEmail!.trim(),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
          ],
          if (corporateId != null && corporateId!.trim().isNotEmpty) ...[
            _CorporateRow(
              icon: Icons.badge_outlined,
              label: 'Employee ID',
              value: corporateId!.trim(),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
          ],
          if (department != null && department!.trim().isNotEmpty) ...[
            _CorporateRow(
              icon: Icons.account_tree_outlined,
              label: 'Department',
              value: department!.trim(),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
          ],
          if (designation != null && designation!.trim().isNotEmpty) ...[
            _CorporateRow(
              icon: Icons.work_outline_rounded,
              label: 'Designation',
              value: designation!.trim(),
              isDark: isDark,
            ),
            const SizedBox(height: 10),
          ],
          if (spendingLimit != null && spendingLimit!.trim().isNotEmpty) ...[
            _CorporateRow(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Spending Limit',
              value: _formatSpendingLimit(spendingLimit!.trim()),
              isDark: isDark,
              valueColor: const Color(0xFF10B981),
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
  final Color? valueColor;

  const _CorporateRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    this.valueColor,
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
        const SizedBox(width: 10),
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
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? (isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class CorporateDetailsCard extends StatelessWidget {
  final String companyName;
  final String? corporateApprovalStatus;
  final String? corporateRoute;
  final String? companyLocation;
  final String? companyEmail;
  final String? companyPhone;

  const CorporateDetailsCard({
    super.key,
    required this.companyName,
    this.corporateApprovalStatus,
    this.corporateRoute,
    this.companyLocation,
    this.companyEmail,
    this.companyPhone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final approvalStatus = corporateApprovalStatus ?? 'ACTIVE';
    final isApproved = approvalStatus.toUpperCase() == 'APPROVED' || approvalStatus.toUpperCase() == 'ACTIVE';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.35 : 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.business_rounded, color: Color(0xFF6366F1), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      companyLocation ?? 'Corporate Fleet Partner',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isApproved ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (isApproved ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isApproved ? Icons.verified_rounded : Icons.pending_actions_rounded,
                      size: 13,
                      color: isApproved ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      approvalStatus.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isApproved ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          const SizedBox(height: 10),
          if (corporateRoute != null && corporateRoute!.isNotEmpty) ...[
            _buildCorporateMetaItem(
              icon: Icons.alt_route_rounded,
              label: 'Assigned Route',
              value: corporateRoute!,
              isDark: isDark,
            ),
            const SizedBox(height: 8),
          ],
          if (companyEmail != null && companyEmail!.isNotEmpty) ...[
            _buildCorporateMetaItem(
              icon: Icons.email_outlined,
              label: 'Company Email',
              value: companyEmail!,
              isDark: isDark,
            ),
            const SizedBox(height: 8),
          ],
          if (companyPhone != null && companyPhone!.isNotEmpty) ...[
            _buildCorporateMetaItem(
              icon: Icons.phone_outlined,
              label: 'Company Phone',
              value: companyPhone!,
              isDark: isDark,
            ),
            const SizedBox(height: 8),
          ],
          if (companyLocation != null && companyLocation!.isNotEmpty) ...[
            _buildCorporateMetaItem(
              icon: Icons.location_on_outlined,
              label: 'Company Location',
              value: companyLocation!,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCorporateMetaItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

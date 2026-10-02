import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_constants.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String membershipTier;
  final String? profileImageUrl;
  final VoidCallback? onEditProfileTap;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.membershipTier,
    this.profileImageUrl,
    this.onEditProfileTap,
  });

  Widget _buildAvatarImage() {
    final image = profileImageUrl;
    if (image != null && image.trim().isNotEmpty) {
      final resolved = ApiConstants.getImageUrl(image.trim());
      if (kIsWeb ||
          resolved.startsWith('http://') ||
          resolved.startsWith('https://') ||
          resolved.startsWith('blob:')) {
        return Image.network(
          resolved,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
        );
      } else {
        try {
          final file = File(image);
          if (file.existsSync()) {
            return Image.file(
              file,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
            );
          }
        } catch (_) {}
      }
    }
    return _buildFallbackIcon();
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: const Color(0xFF0F2027),
      child: const Icon(
        Icons.person_rounded,
        size: 54,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Circular Profile Image + Edit Pencil Badge
        Center(
          child: Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _buildAvatarImage(),
                ),
              ),

              // Edit Pencil Badge Button
              Positioned(
                right: 0,
                bottom: 0,
                child: InkWell(
                  key: const Key('edit_profile_button'),
                  onTap: onEditProfileTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.onboardingBgDark : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // User Name
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.onboardingTextPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 2),

        // Membership Tier
        Text(
          membershipTier,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.onboardingTextSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

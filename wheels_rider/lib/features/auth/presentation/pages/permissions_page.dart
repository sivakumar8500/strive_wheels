import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/permissions_bloc.dart';
import '../bloc/permissions_event.dart';
import '../bloc/permissions_state.dart';
import 'registration_landing_page.dart';

class PermissionsPage extends StatelessWidget {
  final String phoneNumber;

  const PermissionsPage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.onboardingBgDark : AppColors.onboardingBgLight;

    return BlocProvider(
      create: (_) => sl<PermissionsBloc>()..add(CheckPermissionsStatus()),
      child: BlocConsumer<PermissionsBloc, PermissionsState>(
        listener: (context, state) {
          if (state is PermissionsStatusUpdated && state.allGranted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => RegistrationLandingPage(phoneNumber: phoneNumber)),
            );
          } else if (state is PermissionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PermissionsLoading;

          return Scaffold(
            backgroundColor: backgroundColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.security_rounded,
                          size: 64,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'App Permissions',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.white
                            : AppColors.onboardingTextPrimaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'To provide you with the best experience, we need access to the following permissions.',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.onboardingTextSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          _buildPermissionItem(
                            context: context,
                            icon: Icons.location_on_outlined,
                            title: 'Location',
                            subtitle: 'To find nearby rides and track your journey.',
                            status: _getPermissionStatus(state, Permission.location),
                            isDark: isDark,
                          ),
                          _buildPermissionItem(
                            context: context,
                            icon: Icons.contacts_outlined,
                            title: 'Contacts',
                            subtitle: 'To easily choose emergency contacts.',
                            status: _getPermissionStatus(state, Permission.contacts),
                            isDark: isDark,
                          ),
                          _buildPermissionItem(
                            context: context,
                            icon: Icons.phone_outlined,
                            title: 'Phone Call',
                            subtitle: 'To easily call drivers or support.',
                            status: _getPermissionStatus(state, Permission.phone),
                            isDark: isDark,
                          ),
                          _buildPermissionItem(
                            context: context,
                            icon: Icons.folder_outlined,
                            title: 'File Access',
                            subtitle: 'To upload documents for verification.',
                            status: _getPermissionStatus(state, Permission.storage),
                            isDark: isDark,
                          ),
                          _buildPermissionItem(
                            context: context,
                            icon: Icons.camera_alt_outlined,
                            title: 'Camera',
                            subtitle: 'To take profile pictures or scan documents.',
                            status: _getPermissionStatus(state, Permission.camera),
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context
                                    .read<PermissionsBloc>()
                                    .add(RequestAllPermissions());
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: AppColors.white,
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
                                'Allow All Permissions',
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
          );
        },
      ),
    );
  }

  PermissionStatus? _getPermissionStatus(PermissionsState state, Permission permission) {
    if (state is PermissionsStatusUpdated) {
      return state.statuses[permission];
    }
    return null;
  }

  Widget _buildPermissionItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required PermissionStatus? status,
    required bool isDark,
  }) {
    final isGranted = status?.isGranted ?? false;
    final isDenied = status?.isPermanentlyDenied ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGranted
              ? Colors.green.withValues(alpha: 0.5)
              : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isGranted
                  ? Colors.green.withValues(alpha: 0.1)
                  : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isGranted
                  ? Colors.green
                  : (isDark ? AppColors.white : AppColors.primaryBlue),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.white
                        : AppColors.onboardingTextPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.onboardingTextSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          if (isGranted)
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
            )
          else if (isDenied)
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
            ),
        ],
      ),
    );
  }
}

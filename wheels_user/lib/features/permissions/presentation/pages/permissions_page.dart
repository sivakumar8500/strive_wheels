import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../bloc/permissions_bloc.dart';
import '../bloc/permissions_event.dart';
import '../bloc/permissions_state.dart';

class PermissionsPage extends StatefulWidget {
  const PermissionsPage({super.key});

  @override
  State<PermissionsPage> createState() => _PermissionsPageState();
}

class _PermissionsPageState extends State<PermissionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PermissionsBloc>().add(const LoadPermissionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.onboardingBgDark : AppColors.onboardingBgLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocConsumer<PermissionsBloc, PermissionsState>(
          listenWhen: (previous, current) =>
              (!previous.isSuccess && current.isSuccess) ||
              (current.errorMessage != null &&
                  current.errorMessage != previous.errorMessage),
          listener: (context, state) {
            if (state.isSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => BlocProvider<HomeBloc>(
                    create: (_) => sl<HomeBloc>(),
                    child: const HomePage(),
                  ),
                ),
                (route) => false,
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
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'App Permissions',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: isDark
                          ? AppColors.white
                          : AppColors.onboardingTextPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Please enable the following permissions to get the most out of Strive Wheels.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.onboardingTextSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Notifications Card
                  _buildPermissionCard(
                    context: context,
                    isDark: isDark,
                    title: 'Notifications',
                    subtitle: 'Stay updated on your ride status.',
                    icon: Icons.notifications_active_outlined,
                    value: state.notificationsAllowed,
                    onChanged: (val) {
                      context
                          .read<PermissionsBloc>()
                          .add(ToggleNotificationEvent(val));
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Contacts Card
                  _buildPermissionCard(
                    context: context,
                    isDark: isDark,
                    title: 'Contacts',
                    subtitle: 'Easily find friends to share rides with.',
                    icon: Icons.contacts_outlined,
                    value: state.contactsAllowed,
                    onChanged: (val) {
                      context
                          .read<PermissionsBloc>()
                          .add(ToggleContactsEvent(val));
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Location Card
                  _buildPermissionCard(
                    context: context,
                    isDark: isDark,
                    title: 'Location',
                    subtitle: 'Allow us to pinpoint your exact location for pick-up.',
                    icon: Icons.location_on_outlined,
                    value: state.locationAllowed,
                    onChanged: (val) {
                      context
                          .read<PermissionsBloc>()
                          .add(ToggleLocationEvent(val));
                    },
                  ),
                  
                  const Spacer(),
                  AppButton(
                    title: 'Continue',
                    isEnabled: true,
                    isLoading: state.isSubmitting,
                    onTap: () {
                      context
                          .read<PermissionsBloc>()
                          .add(const SubmitPermissionsEvent());
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
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
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.onboardingTextSecondaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value ? 'Status: Granted' : 'Status: Denied',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: value ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
          ),
        ],
      ),
    );
  }
}

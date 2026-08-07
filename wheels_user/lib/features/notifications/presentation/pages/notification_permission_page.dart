import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../contacts/presentation/bloc/contacts_bloc.dart';
import '../../../contacts/presentation/pages/contacts_permission_page.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

/// Stay Updated (Notification Permission Prompt) Page matching exact reference UI design.
class NotificationPermissionPage extends StatelessWidget {
  const NotificationPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.onboardingBgDark
        : AppColors.onboardingBgLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocConsumer<NotificationBloc, NotificationState>(
          listenWhen: (previous, current) =>
              (!previous.isPermissionGranted && current.isPermissionGranted) ||
              (!previous.isSkipped && current.isSkipped) ||
              (current.errorMessage != null &&
                  current.errorMessage != previous.errorMessage),
          listener: (context, state) {
            if (state.isPermissionGranted || state.isSkipped) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => BlocProvider<ContactsBloc>(
                    create: (_) => sl<ContactsBloc>(),
                    child: const ContactsPermissionPage(),
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
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Header Artwork & Notification Card
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: Image.asset(
                        AppAssets.notificationIllustration,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.notifications_active,
                            size: 140,
                            color: AppColors.primaryBlue,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Title
                  Text(
                    AppStrings.stayUpdated,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: isDark
                          ? AppColors.white
                          : AppColors.onboardingTextPrimaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      AppStrings.receiveRideStatusSubtitle,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.onboardingTextSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Enable Notifications Primary Button
                  AppButton(
                    title: AppStrings.enableNotifications,
                    isEnabled: true,
                    isLoading: state.isSubmitting,
                    onTap: () {
                      context
                          .read<NotificationBloc>()
                          .add(const EnableNotificationsEvent());
                    },
                  ),

                  const SizedBox(height: 20),

                  // Maybe Later Secondary Action Link
                  TextButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            context
                                .read<NotificationBloc>()
                                .add(const SkipNotificationsEvent());
                          },
                    child: Text(
                      AppStrings.maybeLater,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

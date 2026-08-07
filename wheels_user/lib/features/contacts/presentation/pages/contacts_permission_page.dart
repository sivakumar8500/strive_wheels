import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_button.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_bloc.dart';
import 'package:wheels_user/features/home/presentation/pages/home_page.dart';
import '../bloc/contacts_bloc.dart';
import '../bloc/contacts_event.dart';
import '../bloc/contacts_state.dart';

/// Find Your Contacts (Contacts Permission Prompt) Page matching exact reference UI design.
class ContactsPermissionPage extends StatelessWidget {
  const ContactsPermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.onboardingBgDark
        : AppColors.onboardingBgLight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocConsumer<ContactsBloc, ContactsState>(
          listener: (context, state) {
            if (state.isPermissionGranted || state.isSkipped) {
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
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Header Artwork: 3D Contacts Book Illustration
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: Image.asset(
                        AppAssets.contactsIllustration,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.contacts_rounded,
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
                    AppStrings.findYourContacts,
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
                      AppStrings.allowAccessToContactsSubtitle,
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

                  // Allow Contacts Primary Button
                  AppButton(
                    title: AppStrings.allowContacts,
                    isEnabled: true,
                    isLoading: state.isSubmitting,
                    onTap: () {
                      context
                          .read<ContactsBloc>()
                          .add(const AllowContactsEvent());
                    },
                  ),

                  const SizedBox(height: 20),

                  // Skip Action Link
                  TextButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () {
                            context
                                .read<ContactsBloc>()
                                .add(const SkipContactsEvent());
                          },
                    child: Text(
                      AppStrings.skip,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/step_progress_indicator.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_event.dart';
import '../bloc/registration_state.dart';
import 'registration/step1_personal_info.dart';
import 'registration/step2_address_details.dart';
import 'registration/step3_identity_verification.dart';
import 'registration/step4_vehicle_documents.dart';
import 'registration/step5_vehicle_details.dart';
import 'registration/step6_bank_details.dart';
import 'registration/step7_emergency_contact.dart';
import 'registration/step8_final_verification.dart';
import 'registration/step9_success.dart';

class RegistrationPage extends StatelessWidget {
  final String phoneNumber;

  const RegistrationPage({super.key, required this.phoneNumber});

  String _getAppBarTitle(int step) {
    switch (step) {
      case 1:
        return 'Driver Registration';
      case 2:
        return 'Address Details';
      case 3:
        return 'Identity Verification';
      case 4:
        return 'Identify Verification'; // Match design screenshot for step 4
      case 5:
        return 'Identify Verification'; // Match design screenshot for step 5
      case 6:
        return 'Identify Verification'; // Match design screenshot for step 6
      case 7:
        return 'Identify Verification'; // Match design screenshot for step 7
      case 8:
        return 'Review & Submit';
      default:
        return 'Driver Registration';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.onboardingBgDark
        : AppColors.onboardingBgLight;

    return BlocProvider(
      create: (_) =>
          sl<RegistrationBloc>()
            ..add(UpdatePersonalInfoEvent(mobileNumber: phoneNumber)),
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: state.currentStep == 9
                ? null
                : AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primaryBlue,
                      ),
                      onPressed: () {
                        if (state.currentStep > 1) {
                          context.read<RegistrationBloc>().add(
                            PreviousStepEvent(),
                          );
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    title: Text(
                      _getAppBarTitle(state.currentStep),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
            body: SafeArea(
              child: Column(
                children: [
                  // Step Indicator Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Step ${state.currentStep} of 9',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                            Text(
                              '${(state.currentStep / 9 * 100).toInt()}%',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        StepProgressIndicator(
                          totalSteps: 9,
                          currentStep: state.currentStep,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  // Step Content
                  Expanded(child: _buildStepContent(state.currentStep)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepContent(int currentStep) {
    switch (currentStep) {
      case 1:
        return const Step1PersonalInfo();
      case 2:
        return const Step2AddressDetails();
      case 3:
        return const Step3IdentityVerification();
      case 4:
        return const Step4VehicleDocuments();
      case 5:
        return const Step5VehicleDetails();
      case 6:
        return const Step6BankDetails();
      case 7:
        return const Step7EmergencyContact();
      case 8:
        return const Step8FinalVerification();
      case 9:
        return const Step9Success();
      default:
        return const Center(child: Text('Coming Soon'));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/step_progress_indicator.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_event.dart';
import '../bloc/registration_state.dart';
import 'steps/step1_personal_info.dart';
import 'steps/step2_address_details.dart';
import 'steps/step3_identity_verification.dart';
import 'steps/step4_vehicle_documents.dart';
import 'steps/step5_vehicle_details.dart';
import 'steps/step6_bank_details.dart';
import 'steps/step7_emergency_contact.dart';
import 'steps/step8_final_verification.dart';
import 'steps/step9_success.dart';

class RegistrationPage extends StatelessWidget {
  final String phoneNumber;
  final int initialStep;

  const RegistrationPage({
    super.key,
    required this.phoneNumber,
    this.initialStep = 2,
  });

  String _getAppBarTitle(int step) {
    switch (step) {
      case 1:
      case 2:
        return 'Personal Info';
      case 3:
        return 'Address Details';
      case 4:
        return 'Identity Verification';
      case 5:
        return 'Vehicle Documents';
      case 6:
        return 'Vehicle Details';
      case 7:
        return 'Bank Details';
      case 8:
        return 'Emergency Contact';
      case 9:
        return 'Review & Submit';
      default:
        return 'Personal Info';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.onboardingBgDark
        : AppColors.onboardingBgLight;

    return BlocProvider(
      create: (_) {
        final bloc = sl<RegistrationBloc>()
          ..add(UpdatePersonalInfoEvent(mobileNumber: phoneNumber));
        if (initialStep != 2) {
          bloc.add(SetInitialStepEvent(step: initialStep));
        }
        return bloc;
      },
      child: BlocConsumer<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state.status == RegistrationStatus.failure &&
              state.errorMessage != null &&
              state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: state.currentStep == 10
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
                        if (state.currentStep > 2) {
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
                  if (state.currentStep < 10)
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
                                'Step ${state.currentStep} of 10',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              Text(
                                '${((state.currentStep - 1) * 10)}%',
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
                            totalSteps: 10,
                            currentStep: state.currentStep,
                          ),
                        ],
                      ),
                    ),
                  if (state.currentStep < 10)
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
      case 2:
        return const Step1PersonalInfo();
      case 3:
        return const Step2AddressDetails();
      case 4:
        return const Step3IdentityVerification();
      case 5:
        return const Step4VehicleDocuments();
      case 6:
        return const Step5VehicleDetails();
      case 7:
        return const Step6BankDetails();
      case 8:
        return const Step7EmergencyContact();
      case 9:
        return const Step8FinalVerification();
      case 10:
        return const Step9Success();
      default:
        return const Step1PersonalInfo();
    }
  }
}

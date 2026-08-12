import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../bloc/registration_bloc.dart';
import '../../bloc/registration_event.dart';
import '../../bloc/registration_state.dart';

class Step2AddressDetails extends StatefulWidget {
  const Step2AddressDetails({super.key});

  @override
  State<Step2AddressDetails> createState() => _Step2AddressDetailsState();
}

class _Step2AddressDetailsState extends State<Step2AddressDetails> {
  final _houseNoController = TextEditingController();
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<RegistrationBloc>();
    final data = bloc.state.data;
    _houseNoController.text = data.houseNo ?? '';
    _streetController.text = data.streetName ?? '';
    _landmarkController.text = data.landmark ?? '';
    _pincodeController.text = data.pincode ?? '';
    _cityController.text = data.city ?? '';
    _stateController.text = data.state ?? '';
  }

  @override
  void dispose() {
    _houseNoController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Map Placeholder
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
              ),
              child: Stack(
                children: [
                  // Map Background Simulation
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        Icons.map_outlined,
                        size: 100,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          'San Francisco',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  // Confirm location button
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.cardDark
                            : AppColors.white,
                        foregroundColor: isDark
                            ? AppColors.white
                            : AppColors.black,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Confirm location on map',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.black,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: isDark ? AppColors.white : AppColors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Use Current Location Button
            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.near_me_outlined, color: AppColors.primaryBlue),
              label: Text(
                'Use Current Location',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: isDark
                    ? AppColors.surfaceDark
                    : AppColors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Address Fields
            AppTextField(
              label: 'House / Flat / Block No.',
              hintText: 'e.g. Flat 402, Block B',
              controller: _houseNoController,
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Street / Area Name',
              hintText: 'e.g. Pine Street, Financial District',
              controller: _streetController,
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Landmark (Optional)',
              hintText: 'e.g. Near Blue Bottle Coffee',
              controller: _landmarkController,
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Pincode',
              hintText: 'e.g. 94111',
              keyboardType: TextInputType.number,
              controller: _pincodeController,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'City',
                    hintText: 'Hyd',
                    controller: _cityController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    label: 'State',
                    hintText: 'Telangana',
                    controller: _stateController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Please ensure the address matches your utility bills or government ID for faster verification.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.primaryBlue,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Save & Continue Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.read<RegistrationBloc>().add(
                    UpdateAddressDetailsEvent(
                      houseNo: _houseNoController.text,
                      streetName: _streetController.text,
                      landmark: _landmarkController.text,
                      pincode: _pincodeController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                    ),
                  );
                  context.read<RegistrationBloc>().add(NextStepEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save & Continue',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

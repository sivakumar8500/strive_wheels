import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../bloc/registration_bloc.dart';
import '../../bloc/registration_event.dart';
import '../../bloc/registration_state.dart';

class Step1PersonalInfo extends StatefulWidget {
  const Step1PersonalInfo({super.key});

  @override
  State<Step1PersonalInfo> createState() => _Step1PersonalInfoState();
}

class _Step1PersonalInfoState extends State<Step1PersonalInfo> {
  String selectedGender = '';
  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _referralController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize fields from BLoC state if available
    final bloc = context.read<RegistrationBloc>();
    final data = bloc.state.data;
    _firstNameController.text = data.firstName ?? '';
    _lastNameController.text = data.lastName ?? '';
    _mobileNumberController.text = data.mobileNumber ?? '';
    _emailController.text = data.email ?? '';
    _dobController.text = data.dateOfBirth ?? '';
    selectedGender = data.gender ?? '';
    if (data.profilePhotoPath != null && data.profilePhotoPath!.isNotEmpty) {
      _profileImagePath = data.profilePhotoPath;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  ImageProvider? _getImageProvider(String? blocPath) {
    final path = _profileImagePath ?? blocPath;
    if (path != null && path.isNotEmpty) {
      final fullUrl = ApiEndpoints.getImageUrl(path);
      if (kIsWeb || fullUrl.startsWith('http') || fullUrl.startsWith('blob:')) {
        return NetworkImage(fullUrl);
      } else {
        return FileImage(File(path));
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bloc = context.read<RegistrationBloc>();
    if (_mobileNumberController.text.isEmpty && 
        bloc.state.data.mobileNumber != null && 
        bloc.state.data.mobileNumber!.isNotEmpty) {
      _mobileNumberController.text = bloc.state.data.mobileNumber!;
    }

    return BlocListener<RegistrationBloc, RegistrationState>(
      listenWhen: (previous, current) =>
          previous.data.mobileNumber != current.data.mobileNumber ||
          previous.status != current.status,
      listener: (context, state) {
        if (_mobileNumberController.text.isEmpty &&
            state.data.mobileNumber != null) {
          _mobileNumberController.text = state.data.mobileNumber!;
        }

        if (state.status == RegistrationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Submission failed')),
          );
        }
      },
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          final isLoading = state.status == RegistrationStatus.loading;
          
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Personal Info',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please provide your legal information as it appears on your driver\'s license.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Photo
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    Builder(
                      builder: (context) {
                        final imageProvider = _getImageProvider(state.data.profilePhotoPath);
                        return Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            image: imageProvider != null
                                ? DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage('assets/images/strive_logo.jpg'), // Placeholder
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Upload Profile Photo',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Name Fields
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'First Name',
                    hintText: 'Sirii',
                    controller: _firstNameController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    label: 'Last Name',
                    hintText: 'Gurram',
                    controller: _lastNameController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mobile Number
            AppTextField(
              label: '',
              hintText: 'Mobile Number',
              keyboardType: TextInputType.phone,
              controller: _mobileNumberController,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8, top: 14),
                child: Text(
                  '+91',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            Text(
              'Used for monthly performance reports',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 4),
            AppTextField(
              label: 'Email',
              hintText: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            const SizedBox(height: 16),

            // DOB
            AppTextField(
              label: 'Date of Birth',
              hintText: 'mm/dd/yyyy',
              readOnly: true,
              controller: _dobController,
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textPrimaryLight,
              ),
              onTap: () async {
                final now = DateTime.now();
                final twentyOneYearsAgo = DateTime(now.year - 21, now.month, now.day);
                final date = await showDatePicker(
                  context: context,
                  initialDate: twentyOneYearsAgo,
                  firstDate: DateTime(1900),
                  lastDate: twentyOneYearsAgo,
                );
                if (date != null) {
                  setState(() {
                    _dobController.text = "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Gender
            Text(
              'Gender',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildGenderChip('Male', isDark),
                _buildGenderChip('Female', isDark),
                _buildGenderChip('Non-binary', isDark),
                _buildGenderChip('Prefer not to say', isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Referral Code
            AppTextField(
              label: '',
              hintText: 'Referral Code (Optional)',
              controller: _referralController,
            ),
            const SizedBox(height: 32),

            // Save & Continue Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        final firstName = _firstNameController.text.trim();
                        final lastName = _lastNameController.text.trim();
                        final mobileNumber = _mobileNumberController.text.trim();
                        final email = _emailController.text.trim();
                        final dob = _dobController.text.trim();

                        if ((_profileImagePath == null || _profileImagePath!.isEmpty) && 
                            (state.data.profilePhotoPath == null || state.data.profilePhotoPath!.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please upload a profile photo')),
                          );
                          return;
                        }
                        if (firstName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('First name is required')),
                          );
                          return;
                        }
                        if (lastName.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Last name is required')),
                          );
                          return;
                        }
                        if (mobileNumber.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mobile number is required')),
                          );
                          return;
                        }
                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Email address is required')),
                          );
                          return;
                        }
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(email)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid email address')),
                          );
                          return;
                        }
                        if (dob.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Date of birth is required')),
                          );
                          return;
                        }

                        // Age validation: Must be at least 21 years old
                        try {
                          final parts = dob.split('/');
                          if (parts.length == 3) {
                            final month = int.parse(parts[0]);
                            final day = int.parse(parts[1]);
                            final year = int.parse(parts[2]);
                            final birthDate = DateTime(year, month, day);
                            final now = DateTime.now();
                            final twentyOneYearsAgo = DateTime(now.year - 21, now.month, now.day);
                            if (birthDate.isAfter(twentyOneYearsAgo)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('You must be at least 21 years old to register')),
                              );
                              return;
                            }
                          }
                        } catch (_) {}
                        if (selectedGender.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select your gender')),
                          );
                          return;
                        }

                        // Dispatch Submit Event
                        context.read<RegistrationBloc>().add(
                          SubmitPersonalInfoEvent(
                            profilePhotoPath: _profileImagePath ?? state.data.profilePhotoPath,
                            firstName: firstName,
                            lastName: lastName,
                            mobileNumber: mobileNumber,
                            email: email,
                            dateOfBirth: dob,
                            gender: selectedGender,
                            referralCode: _referralController.text.trim(),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save & Continue',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
        },
      ),
    );
  }

  Widget _buildGenderChip(String label, bool isDark) {
    final isSelected = selectedGender == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBlue
              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryBlue
                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? AppColors.white
                : (isDark ? AppColors.white : AppColors.textPrimaryLight),
          ),
        ),
      ),
    );
  }
}


import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../bloc/registration_bloc.dart';
import '../../bloc/registration_event.dart';

class Step3IdentityVerification extends StatefulWidget {
  const Step3IdentityVerification({super.key});

  @override
  State<Step3IdentityVerification> createState() =>
      _Step3IdentityVerificationState();
}

class _Step3IdentityVerificationState extends State<Step3IdentityVerification> {
  final _aadhaarController = TextEditingController();
  final _panController = TextEditingController();
  final _dlController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String? _selfiePath;
  String? _aadhaarFrontPath;
  String? _aadhaarBackPath;
  String? _panFrontPath;
  String? _dlFrontPath;
  String? _dlBackPath;

  Future<void> _pickImage(
    Function(String) onPicked, {
    bool isCamera = false,
  }) async {
    final XFile? image = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        onPicked(image.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final data = context.read<RegistrationBloc>().state.data;
    _aadhaarController.text = data.aadhaarNumber ?? '';
    _panController.text = data.panNumber ?? '';
    _dlController.text = data.dlNumber ?? '';
    _selfiePath = data.selfiePath;
    _aadhaarFrontPath = data.aadhaarFrontPath;
    _aadhaarBackPath = data.aadhaarBackPath;
    _panFrontPath = data.panFrontPath;
    _dlFrontPath = data.dlFrontPath;
    _dlBackPath = data.dlBackPath;
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    _panController.dispose();
    _dlController.dispose();
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
            // Header Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.verified_user_outlined,
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
                        'Driver Verification',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.white : AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Background checks are processed instantly',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Please provide your government-issued identity documents to proceed with registration. Your data is fully encrypted and secure.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Live Selfie Block
            _buildSectionCard(
              isDark: isDark,
              title: 'Live Selfie',
              statusTag: 'REQUIRED',
              statusColor: AppColors.primaryBlue,
              statusBg: AppColors.primaryBlue.withValues(alpha: 0.1),
              content: Column(
                children: [
                  Row(
                    children: [
                      Builder(
                        builder: (context) {
                          ImageProvider? selfieProvider;
                          if (_selfiePath != null && _selfiePath!.isNotEmpty) {
                            final fullUrl = ApiEndpoints.getImageUrl(_selfiePath);
                            if (kIsWeb || fullUrl.startsWith('http') || fullUrl.startsWith('blob:')) {
                              selfieProvider = NetworkImage(fullUrl);
                            } else {
                              selfieProvider = FileImage(File(_selfiePath!));
                            }
                          }
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryBlue.withValues(alpha: 0.1),
                              image: selfieProvider != null
                                  ? DecorationImage(
                                      image: selfieProvider,
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: selfieProvider == null
                                ? Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColors.primaryBlue,
                                  )
                                : null,
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _pickImage(
                                  (path) => _selfiePath = path,
                                  isCamera: true,
                                );
                              },
                              icon: const Icon(Icons.camera_alt, size: 18),
                              label: const Text('Take Selfie'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _selfiePath != null
                                        ? Colors.green
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _selfiePath != null
                                      ? 'Camera feed active'
                                      : 'Selfie required',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: _selfiePath != null
                                        ? Colors.green
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Ensure your face is clearly visible in a well-lit environment. Remove any glasses or headwear.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Aadhaar Card Block
            _buildSectionCard(
              isDark: isDark,
              title: 'Aadhaar Card',
              statusTag: 'OCR ACTIVE',
              statusColor: Colors.deepOrange,
              statusBg: Colors.deepOrange.withValues(alpha: 0.1),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: 'Aadhaar Number',
                    hintText: '5124990244101234',
                    controller: _aadhaarController,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildUploadBlock(
                          isDark: isDark,
                          label: 'Upload Front',
                          imagePath: _aadhaarFrontPath,
                          onTap: () =>
                              _pickImage((path) => _aadhaarFrontPath = path),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildUploadBlock(
                          isDark: isDark,
                          label: 'Upload Back',
                          imagePath: _aadhaarBackPath,
                          onTap: () =>
                              _pickImage((path) => _aadhaarBackPath = path),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Accepted formats: JPEG, PNG up to 5MB. Must be original, colored card.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // PAN Card Block
            _buildSectionCard(
              isDark: isDark,
              title: 'PAN Card',
              statusTag: 'PENDING',
              statusColor: Colors.orange,
              statusBg: Colors.orange.withValues(alpha: 0.1),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: 'PAN Number',
                    hintText: 'BOYPP9088G',
                    controller: _panController,
                    maxLength: 10,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildUploadBlock(
                    isDark: isDark,
                    label: 'Upload PAN Front',
                    imagePath: _panFrontPath,
                    onTap: () => _pickImage((path) => _panFrontPath = path),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Provide a clear scan of the front face of your permanent account card.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Driving License Block
            _buildSectionCard(
              isDark: isDark,
              title: 'Driving License',
              statusTag: 'AWAITING',
              statusColor: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              statusBg: isDark
                  ? AppColors.textSecondaryDark.withValues(alpha: 0.1)
                  : AppColors.textSecondaryLight.withValues(alpha: 0.1),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: 'DL Number',
                    hintText: 'RJ1420110012345',
                    controller: _dlController,
                    maxLength: 16,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-\s]')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildUploadBlock(
                          isDark: isDark,
                          label: 'DL Front',
                          imagePath: _dlFrontPath,
                          onTap: () =>
                              _pickImage((path) => _dlFrontPath = path),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildUploadBlock(
                          isDark: isDark,
                          label: 'DL Back',
                          imagePath: _dlBackPath,
                          onTap: () => _pickImage((path) => _dlBackPath = path),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ensure driving license is valid and not expired. All details must match your profile.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
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
                  final aadhaarNumber = _aadhaarController.text.replaceAll(' ', '').trim();
                  final panNumber = _panController.text.trim().toUpperCase();
                  final dlNumber = _dlController.text.trim().toUpperCase();

                  // 1. Live Selfie validation
                  if (_selfiePath == null || _selfiePath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please take a live selfie')),
                    );
                    return;
                  }

                  // 2. Aadhaar validation (Must be 16 digits)
                  if (aadhaarNumber.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Aadhaar number is required')),
                    );
                    return;
                  }
                  if (!RegExp(r'^\d{16}$').hasMatch(aadhaarNumber)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid 16-digit Aadhaar number')),
                    );
                    return;
                  }
                  if (_aadhaarFrontPath == null || _aadhaarFrontPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Aadhaar card front photo')),
                    );
                    return;
                  }
                  if (_aadhaarBackPath == null || _aadhaarBackPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Aadhaar card back photo')),
                    );
                    return;
                  }

                  // 3. PAN validation (5 letters, 4 digits, 1 letter)
                  if (panNumber.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PAN number is required')),
                    );
                    return;
                  }
                  if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(panNumber)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid PAN number (e.g. BOYPP9088G)')),
                    );
                    return;
                  }
                  if (_panFrontPath == null || _panFrontPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload PAN card front photo')),
                    );
                    return;
                  }

                  // 4. Driving License validation (Indian standard: 15 alphanumeric characters e.g. RJ1420110012345)
                  if (dlNumber.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Driving License number is required')),
                    );
                    return;
                  }
                  final cleanDl = dlNumber.replaceAll(' ', '').replaceAll('-', '');
                  if (cleanDl.length != 15 || !RegExp(r'^[A-Z]{2}[0-9]{13}$').hasMatch(cleanDl)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid 15-character Indian Driving License (e.g. RJ1420110012345)')),
                    );
                    return;
                  }
                  if (_dlFrontPath == null || _dlFrontPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Driving License front photo')),
                    );
                    return;
                  }
                  if (_dlBackPath == null || _dlBackPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Driving License back photo')),
                    );
                    return;
                  }

                  context.read<RegistrationBloc>().add(
                    UpdateIdentityVerificationEvent(
                      selfiePath: _selfiePath,
                      aadhaarNumber: aadhaarNumber,
                      aadhaarFrontPath: _aadhaarFrontPath,
                      aadhaarBackPath: _aadhaarBackPath,
                      panNumber: panNumber,
                      panFrontPath: _panFrontPath,
                      dlNumber: dlNumber,
                      dlFrontPath: _dlFrontPath,
                      dlBackPath: _dlBackPath,
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

  Widget _buildSectionCard({
    required bool isDark,
    required String title,
    required String statusTag,
    required Color statusColor,
    required Color statusBg,
    required Widget content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusTag,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildUploadBlock({
    required bool isDark,
    required String label,
    String? imagePath,
    VoidCallback? onTap,
  }) {
    final hasImage = imagePath != null && imagePath.isNotEmpty;
    ImageProvider? provider;
    if (hasImage) {
      final fullUrl = ApiEndpoints.getImageUrl(imagePath);
      if (kIsWeb || fullUrl.startsWith('http') || fullUrl.startsWith('blob:')) {
        provider = NetworkImage(fullUrl);
      } else {
        provider = FileImage(File(imagePath));
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceDark.withValues(alpha: 0.5)
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasImage
                ? Colors.green
                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
          ),
          image: provider != null
              ? DecorationImage(
                  image: provider,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (!hasImage)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            else
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

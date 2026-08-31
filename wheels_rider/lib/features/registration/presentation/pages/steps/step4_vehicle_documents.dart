import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/network/api_endpoints.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../domain/usecases/upload_file_usecase.dart';
import '../../bloc/registration_bloc.dart';
import '../../bloc/registration_event.dart';

class Step4VehicleDocuments extends StatefulWidget {
  const Step4VehicleDocuments({super.key});

  @override
  State<Step4VehicleDocuments> createState() => _Step4VehicleDocumentsState();
}

class _Step4VehicleDocumentsState extends State<Step4VehicleDocuments> {
  final _regDateController = TextEditingController();
  final _expiryDateController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final Set<String> _uploadingFields = {};

  String? _rcFrontPath;
  String? _rcBackPath;
  String? _insurancePath;
  String? _pucPath;
  String? _fitnessCertPath;
  String? _permitPath;

  // 6 Vehicle Photo Views
  String? _vehicleFrontViewPath;
  String? _vehicleBackViewPath;
  String? _vehicleLeftSideViewPath;
  String? _vehicleRightSideViewPath;
  String? _vehicleInsideView1Path;
  String? _vehicleInsideView2Path;

  @override
  void initState() {
    super.initState();
    final data = context.read<RegistrationBloc>().state.data;
    _regDateController.text = data.regDate ?? '';
    _expiryDateController.text = data.regExpiryDate ?? '';
    _rcFrontPath = data.rcFrontPath;
    _rcBackPath = data.rcBackPath;
    _insurancePath = data.insurancePath;
    _pucPath = data.pucPath;
    _fitnessCertPath = data.fitnessCertPath;
    _permitPath = data.permitPath;
    _vehicleFrontViewPath = data.vehicleFrontViewPath;
    _vehicleBackViewPath = data.vehicleBackViewPath;
    _vehicleLeftSideViewPath = data.vehicleLeftSideViewPath;
    _vehicleRightSideViewPath = data.vehicleRightSideViewPath;
    _vehicleInsideView1Path = data.vehicleInsideView1Path;
    _vehicleInsideView2Path = data.vehicleInsideView2Path;
  }

  @override
  void dispose() {
    _regDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage(
    Function(String) onPicked, {
    required String fieldKey,
    bool isCamera = false,
  }) async {
    final XFile? image = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _uploadingFields.add(fieldKey);
      });
      try {
        final uploadUseCase = sl<UploadFileUseCase>();
        final serverUrl = await uploadUseCase(image.path);
        if (mounted) {
          setState(() {
            onPicked(serverUrl);
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _uploadingFields.remove(fieldKey);
          });
        }
      }
    }
  }

  bool _isPucMandatory() {
    final regText = _regDateController.text.trim();
    if (regText.isEmpty) return false;
    try {
      DateTime? regDate;
      final parts = regText.split('/');
      if (parts.length == 3) {
        regDate = DateTime(int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
      } else {
        regDate = DateTime.tryParse(regText);
      }
      if (regDate != null) {
        final now = DateTime.now();
        int ageInYears = now.year - regDate.year;
        if (now.month < regDate.month || (now.month == regDate.month && now.day < regDate.day)) {
          ageInYears--;
        }
        return ageInYears > 5;
      }
    } catch (_) {}
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPucRequired = _isPucMandatory();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Vehicle Documents',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload RC (Front & Back), validity dates, required certificates, and 6 photos of your vehicle.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // RC DATES ROW
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REG. DATE',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        label: '',
                        hintText: 'mm/dd/yyyy',
                        readOnly: true,
                        controller: _regDateController,
                        suffixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1990),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _regDateController.text =
                                  "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REG. EXPIRY DATE',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        label: '',
                        hintText: 'mm/dd/yyyy',
                        readOnly: true,
                        controller: _expiryDateController,
                        suffixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(const Duration(days: 365)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          );
                          if (date != null) {
                            setState(() {
                              _expiryDateController.text =
                                  "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // RC FRONT & RC BACK UPLOADS
            Text(
              'REGISTRATION CERTIFICATE (RC)',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildGridUploadBlock(
                    isDark: isDark,
                    label: 'RC Front Side',
                    icon: Icons.description_outlined,
                    imagePath: _rcFrontPath,
                    isLoading: _uploadingFields.contains('rc_front'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _rcFrontPath = url,
                      fieldKey: 'rc_front',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGridUploadBlock(
                    isDark: isDark,
                    label: 'RC Back Side',
                    icon: Icons.description_outlined,
                    imagePath: _rcBackPath,
                    isLoading: _uploadingFields.contains('rc_back'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _rcBackPath = url,
                      fieldKey: 'rc_back',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // OTHER DOCUMENTS (INSURANCE, PUC, FITNESS, PERMIT)
            Text(
              'REQUIRED CERTIFICATES',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildGridUploadBlock(
                    isDark: isDark,
                    label: 'Insurance *',
                    icon: Icons.security_outlined,
                    imagePath: _insurancePath,
                    isLoading: _uploadingFields.contains('insurance'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _insurancePath = url,
                      fieldKey: 'insurance',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGridUploadBlock(
                    isDark: isDark,
                    label: isPucRequired
                        ? 'PUC (Required >5 Yr)'
                        : 'PUC (Optional <=5 Yr)',
                    icon: Icons.eco_outlined,
                    imagePath: _pucPath,
                    isLoading: _uploadingFields.contains('puc'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _pucPath = url,
                      fieldKey: 'puc',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildGridUploadBlock(
                    isDark: isDark,
                    label: 'Fitness Cert. *',
                    icon: Icons.verified_outlined,
                    imagePath: _fitnessCertPath,
                    isLoading: _uploadingFields.contains('fitness'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _fitnessCertPath = url,
                      fieldKey: 'fitness',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGridUploadBlock(
                    isDark: isDark,
                    label: 'Permit (Optional)',
                    icon: Icons.description_outlined,
                    imagePath: _permitPath,
                    isLoading: _uploadingFields.contains('permit'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _permitPath = url,
                      fieldKey: 'permit',
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // VEHICLE APPEARANCE SECTION (6 VIEWS)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vehicle Appearance (6 Photos)',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 1: Front View & Back View
            Row(
              children: [
                Expanded(
                  child: _buildVehicleAppearanceBlock(
                    isDark: isDark,
                    label: 'Front View *',
                    imagePath: _vehicleFrontViewPath,
                    isLoading: _uploadingFields.contains('front_view'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _vehicleFrontViewPath = url,
                      fieldKey: 'front_view',
                      isCamera: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildVehicleAppearanceBlock(
                    isDark: isDark,
                    label: 'Back View *',
                    imagePath: _vehicleBackViewPath,
                    isLoading: _uploadingFields.contains('back_view'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _vehicleBackViewPath = url,
                      fieldKey: 'back_view',
                      isCamera: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 2: Left Side View & Right Side View
            Row(
              children: [
                Expanded(
                  child: _buildVehicleAppearanceBlock(
                    isDark: isDark,
                    label: 'Left Side View *',
                    imagePath: _vehicleLeftSideViewPath,
                    isLoading: _uploadingFields.contains('left_view'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _vehicleLeftSideViewPath = url,
                      fieldKey: 'left_view',
                      isCamera: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildVehicleAppearanceBlock(
                    isDark: isDark,
                    label: 'Right Side View *',
                    imagePath: _vehicleRightSideViewPath,
                    isLoading: _uploadingFields.contains('right_view'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _vehicleRightSideViewPath = url,
                      fieldKey: 'right_view',
                      isCamera: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 3: Inside View 1 & Inside View 2
            Row(
              children: [
                Expanded(
                  child: _buildVehicleAppearanceBlock(
                    isDark: isDark,
                    label: 'Inside View 1 *',
                    imagePath: _vehicleInsideView1Path,
                    isLoading: _uploadingFields.contains('inside_1_view'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _vehicleInsideView1Path = url,
                      fieldKey: 'inside_1_view',
                      isCamera: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildVehicleAppearanceBlock(
                    isDark: isDark,
                    label: 'Inside View 2 *',
                    imagePath: _vehicleInsideView2Path,
                    isLoading: _uploadingFields.contains('inside_2_view'),
                    onTap: () => _pickAndUploadImage(
                      (url) => _vehicleInsideView2Path = url,
                      fieldKey: 'inside_2_view',
                      isCamera: true,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ensure all documents are original and clear. Vehicles registered over 5 years ago require a valid Pollution Certificate (PUC).',
                      style: GoogleFonts.inter(
                        fontSize: 12,
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
                  if (_uploadingFields.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please wait until all images finish uploading')),
                    );
                    return;
                  }

                  final regDate = _regDateController.text.trim();
                  final regExpiryDate = _expiryDateController.text.trim();

                  if (regDate.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vehicle registration date is required')),
                    );
                    return;
                  }
                  if (regExpiryDate.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registration expiry date is required')),
                    );
                    return;
                  }

                  if (_rcFrontPath == null || _rcFrontPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload RC Front photo')),
                    );
                    return;
                  }
                  if (_rcBackPath == null || _rcBackPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload RC Back photo')),
                    );
                    return;
                  }
                  if (_insurancePath == null || _insurancePath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Insurance document photo')),
                    );
                    return;
                  }
                  if (_fitnessCertPath == null || _fitnessCertPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Fitness Certificate photo')),
                    );
                    return;
                  }

                  // Pollution Certificate check
                  if (isPucRequired && (_pucPath == null || _pucPath!.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pollution Certificate (PUC) is required for vehicles over 5 years old')),
                    );
                    return;
                  }

                  // 6 Vehicle Photos check
                  if (_vehicleFrontViewPath == null || _vehicleFrontViewPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Vehicle Front View photo')),
                    );
                    return;
                  }
                  if (_vehicleBackViewPath == null || _vehicleBackViewPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Vehicle Back View photo')),
                    );
                    return;
                  }
                  if (_vehicleLeftSideViewPath == null || _vehicleLeftSideViewPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Vehicle Left Side View photo')),
                    );
                    return;
                  }
                  if (_vehicleRightSideViewPath == null || _vehicleRightSideViewPath!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Vehicle Right Side View photo')),
                    );
                    return;
                  }
                  if (_vehicleInsideView1Path == null || _vehicleInsideView1Path!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Vehicle Inside View 1 photo')),
                    );
                    return;
                  }
                  if (_vehicleInsideView2Path == null || _vehicleInsideView2Path!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload Vehicle Inside View 2 photo')),
                    );
                    return;
                  }

                  context.read<RegistrationBloc>().add(
                    UpdateVehicleDocumentsEvent(
                      regDate: regDate,
                      regExpiryDate: regExpiryDate,
                      rcFrontPath: _rcFrontPath,
                      rcBackPath: _rcBackPath,
                      insurancePath: _insurancePath,
                      pucPath: _pucPath,
                      fitnessCertPath: _fitnessCertPath,
                      permitPath: _permitPath,
                      vehicleFrontViewPath: _vehicleFrontViewPath,
                      vehicleBackViewPath: _vehicleBackViewPath,
                      vehicleLeftSideViewPath: _vehicleLeftSideViewPath,
                      vehicleRightSideViewPath: _vehicleRightSideViewPath,
                      vehicleInsideView1Path: _vehicleInsideView1Path,
                      vehicleInsideView2Path: _vehicleInsideView2Path,
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

  Widget _buildGridUploadBlock({
    required bool isDark,
    required String label,
    required IconData icon,
    String? imagePath,
    bool isLoading = false,
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
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark.withValues(alpha: 0.5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primaryBlue,
                  ),
                ),
              )
            : hasImage
                ? Align(
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
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: AppColors.primaryBlue),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.white : AppColors.darkBlue,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Upload File',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildVehicleAppearanceBlock({
    required bool isDark,
    required String label,
    String? imagePath,
    bool isLoading = false,
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
      onTap: isLoading ? null : onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withValues(alpha: 0.5)
                  : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
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
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  )
                : !hasImage
                    ? Center(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      )
                    : Align(
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
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSecondaryDark : AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../bloc/registration_bloc.dart';
import '../../bloc/registration_event.dart';

class Step4VehicleDocuments extends StatefulWidget {
  const Step4VehicleDocuments({super.key});

  @override
  State<Step4VehicleDocuments> createState() => _Step4VehicleDocumentsState();
}

class _Step4VehicleDocumentsState extends State<Step4VehicleDocuments> {
  final _expiryDateController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  String? _rcFrontPath;
  String? _insurancePath;
  String? _pucPath;
  String? _fitnessCertPath;
  String? _permitPath;
  String? _vehicleFrontViewPath;
  String? _vehicleBackViewPath;

  @override
  void initState() {
    super.initState();
    final data = context.read<RegistrationBloc>().state.data;
    _expiryDateController.text = data.regExpiryDate ?? '';
    _rcFrontPath = data.rcFrontPath;
    _insurancePath = data.insurancePath;
    _pucPath = data.pucPath;
    _fitnessCertPath = data.fitnessCertPath;
    _permitPath = data.permitPath;
    _vehicleFrontViewPath = data.vehicleFrontViewPath;
    _vehicleBackViewPath = data.vehicleBackViewPath;
  }

  @override
  void dispose() {
    _expiryDateController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              'Please upload clear photos of your vehicle documents and all exterior/interior views.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // REG. EXPIRY DATE
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
              hintText: '12/31/2028',
              controller: _expiryDateController,
              keyboardType: TextInputType.datetime,
              suffixIcon: Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(height: 16),

            // Registration (RC)
            if (_rcFrontPath != null)
              _buildUploadedFileTile(
                isDark: isDark,
                title: 'Registration (RC)',
                filename: _rcFrontPath!.split('/').last,
                onRemove: () => setState(() => _rcFrontPath = null),
              )
            else
              _buildGridUploadBlock(
                isDark: isDark,
                label: 'Registration (RC)',
                icon: Icons.description_outlined,
                onTap: () => _pickImage((path) => _rcFrontPath = path),
                isFullWidth: true,
              ),

            const SizedBox(height: 16),

            // 2x2 Grid for other documents
            Row(
              children: [
                Expanded(
                  child: _buildGridUploadBlock(
                    isDark: isDark,
                    label: 'Insurance',
                    icon: Icons.security_outlined,
                    isUploaded: _insurancePath != null,
                    onTap: () => _pickImage((path) => _insurancePath = path),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGridUploadBlock(
                    isDark: isDark,
                    label: 'PUC (Pollution)',
                    icon: Icons.camera_alt_outlined,
                    isUploaded: _pucPath != null,
                    onTap: () => _pickImage((path) => _pucPath = path),
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
                    label: 'Fitness Cert.',
                    icon: Icons.description_outlined,
                    isUploaded: _fitnessCertPath != null,
                    onTap: () => _pickImage((path) => _fitnessCertPath = path),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildGridUploadBlock(
                    isDark: isDark,
                    label: 'Permit',
                    icon: Icons.description_outlined,
                    isUploaded: _permitPath != null,
                    onTap: () => _pickImage((path) => _permitPath = path),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Vehicle Appearance Section
            Text(
              'Vehicle Appearance',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.white
                    : AppColors.primaryBlue, // Matches design color
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildVehicleAppearanceBlock(
                    isDark: isDark,
                    label: 'Front View',
                    imagePath: _vehicleFrontViewPath,
                    onTap: () => _pickImage(
                      (path) => _vehicleFrontViewPath = path,
                      isCamera: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildVehicleAppearanceBlock(
                    isDark: isDark,
                    label: 'Back View',
                    imagePath: _vehicleBackViewPath,
                    onTap: () => _pickImage(
                      (path) => _vehicleBackViewPath = path,
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
                color: AppColors.primaryBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.1),
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
                      'Ensure all documents are original. Scanned copies or screenshots may lead to rejection. Avoid glare from flash.',
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
                  context.read<RegistrationBloc>().add(
                    UpdateVehicleDocumentsEvent(
                      regExpiryDate: _expiryDateController.text,
                      rcFrontPath: _rcFrontPath,
                      insurancePath: _insurancePath,
                      pucPath: _pucPath,
                      fitnessCertPath: _fitnessCertPath,
                      permitPath: _permitPath,
                      vehicleFrontViewPath: _vehicleFrontViewPath,
                      vehicleBackViewPath: _vehicleBackViewPath,
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

  Widget _buildGridUploadBlock({
    required bool isDark,
    required String label,
    required IconData icon,
    bool isUploaded = false,
    bool isFullWidth = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isFullWidth ? 70 : 110,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark.withOpacity(0.5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUploaded
                ? Colors.green
                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isUploaded
            ? Center(
                child: Icon(Icons.check_circle, color: Colors.green, size: 32),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.primaryBlue),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.white : AppColors.darkBlue,
                    ),
                  ),
                  if (!isFullWidth) ...[
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
                ],
              ),
      ),
    );
  }

  Widget _buildUploadedFileTile({
    required bool isDark,
    required String title,
    required String filename,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.description, color: AppColors.darkBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                Text(
                  filename,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.primaryBlue),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleAppearanceBlock({
    required bool isDark,
    required String label,
    String? imagePath,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withOpacity(0.5)
                  : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                style: imagePath == null
                    ? BorderStyle.solid
                    : BorderStyle.solid,
              ),
              image: imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(imagePath)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imagePath == null
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
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
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

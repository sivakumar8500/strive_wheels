import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/widgets/zoomable_image_dialog.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileEntity profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String selectedGender = 'Male';
  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _vehicleMakeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleNumberController;
  late TextEditingController _vehicleColorController;

  @override
  void initState() {
    super.initState();
    final parts = widget.profile.name.trim().split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
    
    // Clean mobile number to remove duplicated +91 prefix for editing
    String phoneText = widget.profile.phone;
    if (phoneText.startsWith('+91')) {
      phoneText = phoneText.replaceFirst('+91', '').trim();
    }
    _mobileNumberController = TextEditingController(text: phoneText);
    _emailController = TextEditingController(text: widget.profile.email);
    _dobController = TextEditingController(text: widget.profile.dob.isNotEmpty ? widget.profile.dob : '');

    _vehicleMakeController = TextEditingController(text: widget.profile.vehicleMake.isNotEmpty ? widget.profile.vehicleMake : 'Toyota');
    _vehicleModelController = TextEditingController(text: widget.profile.vehicleModel.isNotEmpty ? widget.profile.vehicleModel : 'Innova Crysta');
    _vehicleNumberController = TextEditingController(text: widget.profile.vehicleNumber.isNotEmpty ? widget.profile.vehicleNumber : 'TS 09 EQ 1234');
    _vehicleColorController = TextEditingController(text: widget.profile.vehicleColor.isNotEmpty ? widget.profile.vehicleColor : 'Pearl White');

    if (widget.profile.gender.isNotEmpty) {
      selectedGender = widget.profile.gender;
    }
    _profileImagePath = widget.profile.profileImageUrl.isNotEmpty ? widget.profile.profileImageUrl : null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleNumberController.dispose();
    _vehicleColorController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  void _saveProfile() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final mobileNumber = _mobileNumberController.text.trim();
    final email = _emailController.text.trim();
    final dob = _dobController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || mobileNumber.isEmpty || email.isEmpty || dob.isEmpty) {
      return;
    }

    String formattedPhone = mobileNumber;
    if (formattedPhone.isNotEmpty && !formattedPhone.startsWith('+91')) {
      formattedPhone = "+91$formattedPhone";
    }

    final updatedData = {
      'first_name': firstName,
      'last_name': lastName,
      'mobile_number': formattedPhone,
      'email': email,
      'dob': dob,
      'gender': selectedGender.toUpperCase(),
      'referral_code': '',
      'profile_photo_url': _profileImagePath ?? '',
    };
    context.read<ProfileBloc>().add(UpdateProfileEvent(updatedData));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FD);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            Navigator.pop(context);
          } else if (state is ProfileUpdateError) {
            // Error handled silently
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileUpdateLoading;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Avatar Card
                _buildAvatarHeaderCard(isDark, cardBg),
                const SizedBox(height: 20),

                // Stats Summary Strip
                _buildStatsSummaryStrip(isDark, cardBg),
                const SizedBox(height: 24),

                // Personal Info Section Card
                _buildSectionTitle('PERSONAL DETAILS', isDark),
                const SizedBox(height: 10),
                _buildPersonalInfoCard(isDark, cardBg),
                const SizedBox(height: 24),

                // Gender Section Card
                _buildSectionTitle('GENDER', isDark),
                const SizedBox(height: 10),
                _buildGenderCard(isDark, cardBg),
                const SizedBox(height: 24),

                // Vehicle Details Card
                _buildSectionTitle('REGISTERED VEHICLE DETAILS', isDark),
                const SizedBox(height: 10),
                _buildVehicleEditCard(isDark, cardBg),
                const SizedBox(height: 32),

                // Save Action Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D6EFD),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatarHeaderCard(bool isDark, Color cardBg) {
    final imagePath = _profileImagePath != null ? ApiEndpoints.getImageUrl(_profileImagePath!) : '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    final zoomPath = _profileImagePath != null
                        ? (_profileImagePath!.startsWith('http') || _profileImagePath!.startsWith('assets') || _profileImagePath!.startsWith('/')
                            ? ApiEndpoints.getImageUrl(_profileImagePath!)
                            : _profileImagePath!)
                        : widget.profile.profileImageUrl;
                    ZoomableImageDialog.show(
                      context,
                      imagePath: zoomPath,
                      title: widget.profile.name.isNotEmpty ? widget.profile.name : 'Profile Photo',
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF0D6EFD), Color(0xFF00C6FF)],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      child: ClipOval(
                        child: imagePath.isNotEmpty
                            ? ((kIsWeb || imagePath.startsWith('http') || imagePath.startsWith('blob:'))
                                ? Image.network(
                                    imagePath,
                                    width: 92,
                                    height: 92,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/strive_logo.jpg',
                                      width: 92,
                                      height: 92,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.file(
                                    File(_profileImagePath!),
                                    width: 92,
                                    height: 92,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/strive_logo.jpg',
                                      width: 92,
                                      height: 92,
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                            : Image.asset(
                                'assets/images/strive_logo.jpg',
                                width: 92,
                                height: 92,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D6EFD),
                        shape: BoxShape.circle,
                        border: Border.all(color: cardBg, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.profile.name.isNotEmpty ? widget.profile.name : 'Puja Sri',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Verified Driver Profile',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummaryStrip(bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Rating', '${widget.profile.rating > 0 ? widget.profile.rating.toStringAsFixed(1) : "5.0"} ★', isDark),
          Container(width: 1, height: 28, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          _buildStatItem('Status', widget.profile.status.toUpperCase(), isDark),
          Container(width: 1, height: 28, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          _buildStatItem('Wallet', '₹${widget.profile.walletBalance.toStringAsFixed(0)}', isDark),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
      ),
    );
  }

  Widget _buildPersonalInfoCard(bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // First & Last Name
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'First Name',
                  controller: _firstNameController,
                  icon: Icons.person_outline,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'Last Name',
                  controller: _lastNameController,
                  icon: Icons.person_outline,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Mobile Number
          _buildInputField(
            label: 'Mobile Number',
            controller: _mobileNumberController,
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
            prefixText: '+91 ',
            isDark: isDark,
          ),
          const SizedBox(height: 14),

          // Email
          _buildInputField(
            label: 'Email Address',
            controller: _emailController,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            isDark: isDark,
          ),
          const SizedBox(height: 14),

          // Date of Birth
          _buildInputField(
            label: 'Date of Birth',
            controller: _dobController,
            icon: Icons.calendar_month_outlined,
            readOnly: true,
            isDark: isDark,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
                firstDate: DateTime(1940),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() {
                  final m = date.month.toString().padLeft(2, '0');
                  final d = date.day.toString().padLeft(2, '0');
                  _dobController.text = "${date.year}-$m-$d";
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    bool readOnly = false,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    final inputBg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF3F4F8);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: inputBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              enabled: !readOnly || onTap != null,
              keyboardType: keyboardType,
              onTap: onTap,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                prefixIcon: Icon(icon, size: 18, color: isDark ? Colors.grey.shade400 : Colors.grey.shade500),
                prefixText: prefixText,
                prefixStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderCard(bool isDark, Color cardBg) {
    final genders = ['Male', 'Female', 'Non-binary', 'Other'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: genders.map((g) => _buildGenderChip(g, isDark)).toList(),
      ),
    );
  }

  Widget _buildGenderChip(String label, bool isDark) {
    final isSelected = selectedGender.toLowerCase() == label.toLowerCase();
    final selectedColor = const Color(0xFF0D6EFD);
    final unselectedBg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF3F4F8);

    return InkWell(
      onTap: () {
        setState(() {
          selectedGender = label;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? selectedColor : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 15,
              color: isSelected ? Colors.white : (isDark ? Colors.grey.shade400 : Colors.grey.shade500),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleEditCard(bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  label: 'Vehicle Make',
                  controller: _vehicleMakeController,
                  icon: Icons.directions_car_outlined,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInputField(
                  label: 'Model Name',
                  controller: _vehicleModelController,
                  icon: Icons.alt_route_outlined,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildInputField(
            label: 'Registration / License Plate Number',
            controller: _vehicleNumberController,
            icon: Icons.badge_outlined,
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          _buildInputField(
            label: 'Vehicle Color',
            controller: _vehicleColorController,
            icon: Icons.palette_outlined,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

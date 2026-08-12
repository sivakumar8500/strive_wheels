import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../bloc/registration_bloc.dart';
import '../../bloc/registration_event.dart';

class Step5VehicleDetails extends StatefulWidget {
  const Step5VehicleDetails({super.key});

  @override
  State<Step5VehicleDetails> createState() => _Step5VehicleDetailsState();
}

class _Step5VehicleDetailsState extends State<Step5VehicleDetails> {
  String? _selectedVehicleType;
  String? _selectedManufacturer;
  String? _selectedModel;
  final _regNumberController = TextEditingController();
  String? _selectedYear;
  String? _selectedColor;
  final _chassisNumberController = TextEditingController();
  final _engineNumberController = TextEditingController();
  String? _selectedTotalSeats;
  String? _selectedFuelType;

  final List<Map<String, dynamic>> _vehicleTypes = [
    {'id': 'Car', 'icon': Icons.directions_car},
    {'id': 'SUV', 'icon': Icons.airport_shuttle}, // Assuming SUV look
    {'id': 'Hatchback', 'icon': Icons.layers},
    {'id': 'EV', 'icon': Icons.electric_car},
  ];

  @override
  void initState() {
    super.initState();
    final data = context.read<RegistrationBloc>().state.data;
    _selectedVehicleType = data.vehicleType ?? 'Car';
    _selectedManufacturer = data.vehicleManufacturer;
    _selectedModel = data.vehicleModel;
    _regNumberController.text = data.vehicleRegNumber ?? '';
    _selectedYear = data.vehicleYear;
    _selectedColor = data.vehicleColor;
    _chassisNumberController.text = data.vehicleChassisNumber ?? '';
    _engineNumberController.text = data.vehicleEngineNumber ?? '';
    _selectedTotalSeats = data.vehicleTotalSeats;
    _selectedFuelType = data.vehicleFuelType;
  }

  @override
  void dispose() {
    _regNumberController.dispose();
    _chassisNumberController.dispose();
    _engineNumberController.dispose();
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
            Text(
              'Vehicle Details',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(height: 24),

            // Vehicle Type Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _vehicleTypes.map((type) {
                final isSelected = _selectedVehicleType == type['id'];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: type == _vehicleTypes.last ? 0 : 8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedVehicleType = type['id'];
                        });
                      },
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.darkBlue
                              : (isDark ? AppColors.surfaceDark : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.darkBlue
                                : AppColors.dividerLight,
                          ),
                          boxShadow: isSelected
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              type['icon'],
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.primaryBlue,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              type['id'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.white
                                    : (isDark
                                          ? AppColors.white
                                          : AppColors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // First Card (Basic Details)
            _buildSectionCard(
              isDark: isDark,
              child: Column(
                children: [
                  _buildDropdown(
                    label: 'Manufacturer',
                    hint: 'Toyota',
                    value: _selectedManufacturer,
                    items: [
                      'Toyota',
                      'Honda',
                      'Hyundai',
                      'Tata',
                      'Mahindra',
                      'Maruti Suzuki',
                    ],
                    onChanged: (val) =>
                        setState(() => _selectedManufacturer = val),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Model',
                    hint: 'Camry',
                    value: _selectedModel,
                    items: [
                      'Camry',
                      'Corolla',
                      'Innova',
                      'Fortuner',
                      'Swift',
                      'City',
                    ],
                    onChanged: (val) => setState(() => _selectedModel = val),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Registration Number',
                    hintText: 'E.G. MH 01 AB 1234',
                    controller: _regNumberController,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Year',
                          hint: '2023',
                          value: _selectedYear,
                          items: [
                            '2024',
                            '2023',
                            '2022',
                            '2021',
                            '2020',
                            '2019',
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedYear = val),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Color',
                          hint: 'White',
                          value: _selectedColor,
                          items: [
                            'White',
                            'Black',
                            'Silver',
                            'Grey',
                            'Red',
                            'Blue',
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedColor = val),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Second Card (Technical Details)
            _buildSectionCard(
              isDark: isDark,
              child: Column(
                children: [
                  AppTextField(
                    label: 'Chassis Number (VIN)',
                    hintText: '17-DIGIT VIN',
                    controller: _chassisNumberController,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Engine Number',
                    hintText: 'FOUND ON RC OR ENGINE BLOCK',
                    controller: _engineNumberController,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Total Seats',
                          hint: '4 Seats',
                          value: _selectedTotalSeats,
                          items: ['2 Seats', '4 Seats', '5 Seats', '7 Seats'],
                          onChanged: (val) =>
                              setState(() => _selectedTotalSeats = val),
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Fuel Type',
                          hint: 'Petrol',
                          value: _selectedFuelType,
                          items: [
                            'Petrol',
                            'Diesel',
                            'CNG',
                            'Electric',
                            'Hybrid',
                          ],
                          onChanged: (val) =>
                              setState(() => _selectedFuelType = val),
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 20, color: AppColors.darkBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ensure all details match your Vehicle Registration Certificate (RC) to avoid rejection.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.darkBlue,
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
                    UpdateVehicleDetailsEvent(
                      vehicleType: _selectedVehicleType,
                      vehicleManufacturer: _selectedManufacturer,
                      vehicleModel: _selectedModel,
                      vehicleRegNumber: _regNumberController.text,
                      vehicleYear: _selectedYear,
                      vehicleColor: _selectedColor,
                      vehicleChassisNumber: _chassisNumberController.text,
                      vehicleEngineNumber: _engineNumberController.text,
                      vehicleTotalSeats: _selectedTotalSeats,
                      vehicleFuelType: _selectedFuelType,
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

  Widget _buildSectionCard({required bool isDark, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight,
              ),
              dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

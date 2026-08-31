import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../domain/usecases/get_vehicle_types_usecase.dart';
import '../../bloc/registration_bloc.dart';
import '../../bloc/registration_event.dart';

class Step5VehicleDetails extends StatefulWidget {
  const Step5VehicleDetails({super.key});

  @override
  State<Step5VehicleDetails> createState() => _Step5VehicleDetailsState();
}

class _Step5VehicleDetailsState extends State<Step5VehicleDetails> {
  int? _selectedVehicleTypeId;
  String? _selectedVehicleTypeName;
  String? _selectedManufacturer;
  String? _selectedModel;
  final _regNumberController = TextEditingController();
  String? _selectedYear;
  String? _selectedColor;
  final _chassisNumberController = TextEditingController();
  final _engineNumberController = TextEditingController();
  String? _selectedTotalSeats;
  String? _selectedFuelType;

  List<Map<String, dynamic>> _vehicleTypes = [];
  bool _isLoadingVehicleTypes = false;

  @override
  void initState() {
    super.initState();
    final data = context.read<RegistrationBloc>().state.data;
    _selectedVehicleTypeId = data.vehicleTypeId;
    _selectedVehicleTypeName = data.vehicleType;
    _selectedManufacturer = data.vehicleManufacturer;
    _selectedModel = data.vehicleModel;
    _regNumberController.text = data.vehicleRegNumber ?? '';
    _selectedYear = data.vehicleYear;
    _selectedColor = data.vehicleColor;
    _chassisNumberController.text = data.vehicleChassisNumber ?? '';
    _engineNumberController.text = data.vehicleEngineNumber ?? '';
    _selectedTotalSeats = data.vehicleTotalSeats;
    _selectedFuelType = data.vehicleFuelType;

    _fetchVehicleTypes();
  }

  Future<void> _fetchVehicleTypes() async {
    setState(() {
      _isLoadingVehicleTypes = true;
    });
    try {
      final getTypes = sl<GetVehicleTypesUseCase>();
      final types = await getTypes();
      if (mounted && types.isNotEmpty) {
        setState(() {
          _vehicleTypes = types.map((item) {
            final id = item['id'] is int
                ? item['id'] as int
                : int.tryParse(item['id'].toString()) ?? 1;
            final name = item['name']?.toString() ??
                item['type']?.toString() ??
                'Car';
            return {
              'id': id,
              'name': name,
              'icon': _getVehicleIcon(name),
            };
          }).toList();

          if (_selectedVehicleTypeId == null && _vehicleTypes.isNotEmpty) {
            _selectedVehicleTypeId = _vehicleTypes.first['id'] as int;
            _selectedVehicleTypeName = _vehicleTypes.first['name'] as String;
          }
        });
      }
    } catch (_) {
    } finally {
      if (mounted) {
        if (_vehicleTypes.isEmpty) {
          setState(() {
            _vehicleTypes = [
              {'id': 1, 'name': 'Car', 'icon': Icons.directions_car},
              {'id': 2, 'name': 'SUV', 'icon': Icons.airport_shuttle},
              {'id': 3, 'name': 'Hatchback', 'icon': Icons.layers},
              {'id': 4, 'name': 'EV', 'icon': Icons.electric_car},
            ];
            if (_selectedVehicleTypeId == null) {
              _selectedVehicleTypeId = 1;
              _selectedVehicleTypeName = 'Car';
            }
          });
        }
        setState(() {
          _isLoadingVehicleTypes = false;
        });
      }
    }
  }

  IconData _getVehicleIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('ev') || lower.contains('electric')) return Icons.electric_car;
    if (lower.contains('suv')) return Icons.airport_shuttle;
    if (lower.contains('bike') || lower.contains('scooter')) return Icons.two_wheeler;
    if (lower.contains('auto') || lower.contains('rickshaw')) return Icons.electric_rickshaw;
    return Icons.directions_car;
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

            // Vehicle Type Selector Header
            Text(
              'SELECT VEHICLE TYPE',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),

            // Vehicle Type Selector Grid/Row
            if (_isLoadingVehicleTypes)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _vehicleTypes.map((type) {
                  final typeId = type['id'] as int;
                  final typeName = type['name'] as String;
                  final isSelected = _selectedVehicleTypeId == typeId;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: type == _vehicleTypes.last ? 0 : 8,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedVehicleTypeId = typeId;
                            _selectedVehicleTypeName = typeName;
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
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                type['icon'] as IconData,
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.primaryBlue,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                typeName,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.white
                                      : (isDark
                                            ? AppColors.white
                                            : AppColors.black),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                    label: 'Manufacturer / Company Name',
                    hint: 'Maruti Suzuki',
                    value: _selectedManufacturer,
                    items: [
                      'Maruti Suzuki',
                      'Hyundai',
                      'Tata',
                      'Mahindra',
                      'Toyota',
                      'Honda',
                      'Kia',
                    ],
                    onChanged: (val) =>
                        setState(() => _selectedManufacturer = val),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Model',
                    hint: 'Dzire',
                    value: _selectedModel,
                    items: [
                      'Dzire',
                      'Swift',
                      'Baleno',
                      'Ertiga',
                      'WagonR',
                      'i20',
                      'Creta',
                      'Nexon',
                    ],
                    onChanged: (val) => setState(() => _selectedModel = val),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Registration Number',
                    hintText: 'TS09AB1234',
                    controller: _regNumberController,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Registration Year',
                          hint: '2022',
                          value: _selectedYear,
                          items: [
                            for (int y = DateTime.now().year; y >= 2005; y--)
                              y.toString()
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

            // Second Card (Advanced Details)
            _buildSectionCard(
              isDark: isDark,
              child: Column(
                children: [
                  AppTextField(
                    label: 'Chassis Number',
                    hintText: 'MA3EWE81S00123456',
                    controller: _chassisNumberController,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Engine Number',
                    hintText: 'K12M1234567',
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
                          hint: 'PETROL',
                          value: _selectedFuelType,
                          items: [
                            'PETROL',
                            'DIESEL',
                            'CNG',
                            'ELECTRIC',
                            'HYBRID',
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
                color: AppColors.primaryBlue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 20, color: AppColors.darkBlue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Ensure all vehicle details match your Vehicle Registration Certificate (RC) to avoid rejection.',
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
                  final regNumber = _regNumberController.text.trim();
                  final chassisNumber = _chassisNumberController.text.trim();
                  final engineNumber = _engineNumberController.text.trim();

                  if (_selectedManufacturer == null || _selectedManufacturer!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select vehicle manufacturer')),
                    );
                    return;
                  }
                  if (_selectedModel == null || _selectedModel!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select vehicle model')),
                    );
                    return;
                  }
                  if (regNumber.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vehicle registration number is required')),
                    );
                    return;
                  }

                  context.read<RegistrationBloc>().add(
                    UpdateVehicleDetailsEvent(
                      vehicleTypeId: _selectedVehicleTypeId ?? 1,
                      vehicleType: _selectedVehicleTypeName ?? 'Car',
                      vehicleManufacturer: _selectedManufacturer,
                      vehicleModel: _selectedModel,
                      vehicleRegNumber: regNumber,
                      vehicleYear: _selectedYear ?? '2022',
                      vehicleColor: _selectedColor ?? 'White',
                      vehicleChassisNumber: chassisNumber,
                      vehicleEngineNumber: engineNumber,
                      vehicleTotalSeats: _selectedTotalSeats ?? '4 Seats',
                      vehicleFuelType: _selectedFuelType ?? 'PETROL',
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
            color: Colors.black.withValues(alpha: 0.02),
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

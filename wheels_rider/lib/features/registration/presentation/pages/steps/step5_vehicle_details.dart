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
  final _manufacturerController = TextEditingController();
  final _modelController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _chassisNumberController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _totalSeatsController = TextEditingController();
  final _fuelTypeController = TextEditingController();

  List<Map<String, dynamic>> _vehicleTypes = [];
  bool _isLoadingVehicleTypes = false;

  @override
  void initState() {
    super.initState();
    final data = context.read<RegistrationBloc>().state.data;
    _selectedVehicleTypeId = data.vehicleTypeId;
    _selectedVehicleTypeName = data.vehicleType;
    _manufacturerController.text = data.vehicleManufacturer ?? '';
    _modelController.text = data.vehicleModel ?? '';
    _regNumberController.text = data.vehicleRegNumber ?? '';
    _yearController.text = data.vehicleYear ?? '';
    _colorController.text = data.vehicleColor ?? '';
    _chassisNumberController.text = data.vehicleChassisNumber ?? '';
    _engineNumberController.text = data.vehicleEngineNumber ?? '';
    _totalSeatsController.text = data.vehicleTotalSeats ?? '';
    _fuelTypeController.text = data.vehicleFuelType ?? '';

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
    _manufacturerController.dispose();
    _modelController.dispose();
    _regNumberController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _chassisNumberController.dispose();
    _engineNumberController.dispose();
    _totalSeatsController.dispose();
    _fuelTypeController.dispose();
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
              SizedBox(
                height: 84,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _vehicleTypes.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final type = _vehicleTypes[index];
                    final typeId = type['id'] as int;
                    final typeName = type['name'] as String;
                    final isSelected = _selectedVehicleTypeId == typeId;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedVehicleTypeId = typeId;
                          _selectedVehicleTypeName = typeName;
                        });
                      },
                      child: Container(
                        width: 96,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.darkBlue
                              : (isDark ? AppColors.surfaceDark : Colors.white),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.darkBlue
                                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.darkBlue.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              type['icon'] as IconData,
                              size: 26,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.primaryBlue,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              typeName,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
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
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),

            // First Card (Basic Details)
            _buildSectionCard(
              isDark: isDark,
              child: Column(
                children: [
                  AppTextField(
                    label: 'Manufacturer / Company Name',
                    hintText: 'e.g. Maruti Suzuki',
                    controller: _manufacturerController,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: 'Model',
                    hintText: 'e.g. Dzire',
                    controller: _modelController,
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
                        child: AppTextField(
                          label: 'Registration Year',
                          hintText: 'e.g. 2022',
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppTextField(
                          label: 'Color',
                          hintText: 'e.g. White',
                          controller: _colorController,
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
                        child: AppTextField(
                          label: 'Total Seats',
                          hintText: 'e.g. 4',
                          controller: _totalSeatsController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppTextField(
                          label: 'Fuel Type',
                          hintText: 'e.g. PETROL',
                          controller: _fuelTypeController,
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
                  final manufacturer = _manufacturerController.text.trim();
                  final model = _modelController.text.trim();
                  final regNumber = _regNumberController.text.trim();
                  final year = _yearController.text.trim();
                  final color = _colorController.text.trim();
                  final chassisNumber = _chassisNumberController.text.trim();
                  final engineNumber = _engineNumberController.text.trim();
                  final totalSeats = _totalSeatsController.text.trim();
                  final fuelType = _fuelTypeController.text.trim();

                  if (manufacturer.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter vehicle manufacturer')),
                    );
                    return;
                  }
                  if (model.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter vehicle model')),
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
                      vehicleManufacturer: manufacturer,
                      vehicleModel: model,
                      vehicleRegNumber: regNumber,
                      vehicleYear: year,
                      vehicleColor: color,
                      vehicleChassisNumber: chassisNumber,
                      vehicleEngineNumber: engineNumber,
                      vehicleTotalSeats: totalSeats,
                      vehicleFuelType: fuelType,
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

}

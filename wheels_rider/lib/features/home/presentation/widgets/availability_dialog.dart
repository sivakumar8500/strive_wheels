import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/usecases/get_availability_schedule_usecase.dart';

class AvailabilityBottomSheet extends StatefulWidget {
  final List<DateTime> initiallySelectedDates;

  const AvailabilityBottomSheet({
    super.key,
    this.initiallySelectedDates = const [],
  });

  @override
  State<AvailabilityBottomSheet> createState() => _AvailabilityBottomSheetState();
}

class _AvailabilityBottomSheetState extends State<AvailabilityBottomSheet> {
  late List<DateTime> _workingDays;
  final Set<DateTime> _selectedDays = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _workingDays = _calculateNextWorkingDays(5);
    _fetchExistingSchedule();
  }

  Future<void> _fetchExistingSchedule() async {
    try {
      final existingDates = await sl<GetAvailabilityScheduleUseCase>().call();
      if (!mounted) return;
      setState(() {
        if (existingDates.isNotEmpty) {
          // Add dates that match our working days (by year, month, day)
          for (var ed in existingDates) {
            for (var wd in _workingDays) {
              if (ed.year == wd.year && ed.month == wd.month && ed.day == wd.day) {
                _selectedDays.add(wd);
              }
            }
          }
        } else if (widget.initiallySelectedDates.isNotEmpty) {
          _selectedDays.addAll(widget.initiallySelectedDates);
        } else {
          // By default select all
          _selectedDays.addAll(_workingDays);
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        if (widget.initiallySelectedDates.isNotEmpty) {
          _selectedDays.addAll(widget.initiallySelectedDates);
        } else {
          _selectedDays.addAll(_workingDays);
        }
        _isLoading = false;
      });
    }
  }

  List<DateTime> _calculateNextWorkingDays(int count) {
    List<DateTime> days = [];
    DateTime current = DateTime.now();
    
    // Normalize to midnight to avoid time comparison issues
    current = DateTime(current.year, current.month, current.day);
    
    // Start from tomorrow
    current = current.add(const Duration(days: 1));

    while (days.length < count) {
      if (current.weekday != DateTime.saturday && current.weekday != DateTime.sunday) {
        days.add(current);
      }
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Corporate Schedule',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select your availability for the next 5 working days.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              ..._workingDays.map((day) {
              final isSelected = _selectedDays.contains(day);
              final dayName = DateFormat('EEEE').format(day);
              final dateStr = DateFormat('MMM d').format(day);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedDays.remove(day);
                      } else {
                        _selectedDays.add(day);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primaryBlue.withValues(alpha: 0.1) 
                          : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dayName,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dateStr,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? AppColors.primaryBlue : Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: isSelected 
                              ? const Icon(Icons.check, color: Colors.white, size: 16)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            if (!_isLoading)
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedDays.isEmpty 
                        ? null 
                        : () => Navigator.of(context).pop(_selectedDays.toList()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _selectedDays.isEmpty ? Colors.grey.shade500 : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

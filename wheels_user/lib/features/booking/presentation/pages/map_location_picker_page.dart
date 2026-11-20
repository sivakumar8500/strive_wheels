import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/widgets/app_map_widget.dart';

/// Interactive Map Location Picker Page allowing user to drag the map,
/// place the pin at an exact point, view live reverse geocoded address,
/// and confirm the chosen pickup or drop location.
class MapLocationPickerPage extends StatefulWidget {
  final LatLng initialLatLng;
  final String? initialAddress;
  final bool isPickup;
  final Dio? dio;

  const MapLocationPickerPage({
    super.key,
    this.initialLatLng = const LatLng(17.4483, 78.3915),
    this.initialAddress,
    this.isPickup = false,
    this.dio,
  });

  @override
  State<MapLocationPickerPage> createState() => _MapLocationPickerPageState();
}

class _MapLocationPickerPageState extends State<MapLocationPickerPage> {
  late LatLng _currentCenter;
  String _currentAddress = 'Loading address...';
  String _shortTitle = 'Selected Location';
  bool _isLoadingAddress = false;
  bool _isDragging = false;
  GoogleMapController? _mapController;
  Timer? _debounceTimer;
  late final Dio _dio;

  @override
  void initState() {
    super.initState();
    _currentCenter = widget.initialLatLng;
    _dio = widget.dio ?? Dio();
    if (widget.initialAddress != null && widget.initialAddress!.trim().isNotEmpty) {
      _currentAddress = widget.initialAddress!;
      _shortTitle = widget.initialAddress!.split(',').first.trim();
    } else {
      _reverseGeocode(_currentCenter);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _onCameraMove(CameraPosition position) {
    _currentCenter = position.target;
    if (!_isDragging) {
      setState(() {
        _isDragging = true;
      });
    }
  }

  void _onCameraIdle() {
    setState(() {
      _isDragging = false;
    });
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      _reverseGeocode(_currentCenter);
    });
  }

  Future<void> _reverseGeocode(LatLng latLng) async {
    if (!mounted) return;
    setState(() {
      _isLoadingAddress = true;
    });

    try {
      final response = await _dio.get(
        ApiConstants.nominatimReverse,
        queryParameters: {
          'lat': latLng.latitude.toString(),
          'lon': latLng.longitude.toString(),
          'format': 'json',
          'addressdetails': '1',
        },
        options: Options(
          headers: {'User-Agent': 'WheelsUserApp/1.0'},
          sendTimeout: const Duration(seconds: 4),
          receiveTimeout: const Duration(seconds: 4),
        ),
      );

      if (response.statusCode == 200 && response.data != null && mounted) {
        final data = response.data is Map ? response.data : {};
        final displayName = data['display_name']?.toString() ?? '';
        final address = data['address'] as Map<dynamic, dynamic>?;

        String primaryTitle = 'Selected Point';
        if (address != null) {
          final building = address['building'] ??
              address['commercial'] ??
              address['amenity'] ??
              address['office'] ??
              address['shop'] ??
              address['road'] ??
              address['suburb'] ??
              address['neighbourhood'];
          if (building != null && building.toString().trim().isNotEmpty) {
            primaryTitle = building.toString().trim();
          }
        }

        setState(() {
          _currentAddress = displayName.isNotEmpty
              ? displayName
              : '${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)}';
          _shortTitle = primaryTitle;
          _isLoadingAddress = false;
        });
        return;
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _currentAddress =
            'Location (${latLng.latitude.toStringAsFixed(4)}, ${latLng.longitude.toStringAsFixed(4)})';
        _shortTitle = 'Pinned Location';
        _isLoadingAddress = false;
      });
    }
  }

  Future<void> _moveToCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      final newLatLng = LatLng(pos.latitude, pos.longitude);
      _currentCenter = newLatLng;
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newLatLng, zoom: 17.0),
        ),
      );
      _reverseGeocode(newLatLng);
    } catch (_) {}
  }

  void _confirmSelection() {
    Navigator.of(context).pop({
      'address': _currentAddress,
      'title': _shortTitle,
      'latLng': _currentCenter,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : Colors.white;
    final cardBg = isDark ? AppColors.cardDark : Colors.white;
    final textPrimary = isDark ? AppColors.white : const Color(0xFF0F172A);
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);
    final pinColor = widget.isPickup
        ? const Color(0xFF16A34A) // Pickup Green
        : const Color(0xFFDC2626); // Drop Red

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // 1. Interactive Google Map with Pan & Drag
          Positioned.fill(
            child: AppMapWidget(
              initialCameraPosition: CameraPosition(
                target: _currentCenter,
                zoom: 16.5,
              ),
              onMapCreated: (ctrl) {
                _mapController = ctrl;
              },
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
            ),
          ),

          // 2. Animated Center Pin Marker anchored at map center
          Center(
            child: Padding(
              // Lift slightly so the tip of the pin aligns with the exact center point
              padding: const EdgeInsets.only(bottom: 38.0),
              child: AnimatedScale(
                scale: _isDragging ? 1.18 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Floating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: pinColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: pinColor.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.isPickup ? 'PICKUP HERE' : 'DROP HERE',
                        style: GoogleFonts.inter(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Pin Icon
                    Icon(
                      Icons.location_on_rounded,
                      size: 44,
                      color: pinColor,
                    ),

                    // Ground Shadow Dot
                    Container(
                      width: 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: _isDragging ? 0.15 : 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Top Floating Navigation & Header Card
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  // Back Button
                  InkWell(
                    key: const Key('map_picker_back_button'),
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: cardBg,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: textPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Header Title Pill
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            widget.isPickup
                                ? Icons.my_location_rounded
                                : Icons.place_rounded,
                            size: 18,
                            color: pinColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.isPickup
                                  ? 'Set Pickup Location'
                                  : 'Set Drop Location',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Floating GPS "Locate Me" Button
          Positioned(
            right: 16,
            bottom: 220,
            child: FloatingActionButton(
              key: const Key('map_picker_locate_me_button'),
              mini: true,
              backgroundColor: cardBg,
              foregroundColor: AppColors.primaryBlue,
              elevation: 4,
              onPressed: _moveToCurrentLocation,
              child: const Icon(Icons.gps_fixed_rounded, size: 20),
            ),
          ),

          // 5. Bottom Location Confirmation Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Location Title & Status
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: pinColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.isPickup
                                ? 'CHOOSE PICKUP POINT'
                                : 'CHOOSE DROP POINT',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: pinColor,
                            ),
                          ),
                        ),
                        if (_isLoadingAddress)
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Primary Location Title
                    Text(
                      _shortTitle,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Full Detailed Address Text
                    Text(
                      _currentAddress,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 16),

                    // Confirm Location Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        key: const Key('confirm_map_location_button'),
                        onPressed: _confirmSelection,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          widget.isPickup
                              ? 'Confirm Pickup Location'
                              : 'Confirm Drop Location',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_constants.dart';

import '../../data/models/vehicle_type_model.dart';
import '../../domain/entities/vehicle_type_entity.dart';
import '../../domain/usecases/get_vehicle_types_usecase.dart';
import 'ride_summary_page.dart';

/// Detailed Ride Route Map Page with native Google Maps street view, turn-by-turn routing,
/// brand-themed draggable bottom sheet with swipe-down dismissal, and ride selection.
class RideRouteMapPage extends StatefulWidget {
  final String pickupTitle;
  final String pickupAddress;
  final String dropTitle;
  final String dropAddress;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final String bookingMode;
  final Dio? dio;
  final List<VehicleTypeEntity>? initialVehicleTypes;
  final GetVehicleTypesUseCase? getVehicleTypesUseCase;

  const RideRouteMapPage({
    super.key,
    required this.pickupTitle,
    required this.pickupAddress,
    required this.dropTitle,
    required this.dropAddress,
    this.pickupLatLng = const LatLng(17.4483, 78.3915),
    this.dropLatLng = const LatLng(17.4938, 78.3995),
    this.bookingMode = 'INSTANT',
    this.dio,
    this.initialVehicleTypes,
    this.getVehicleTypesUseCase,
  });

  @override
  State<RideRouteMapPage> createState() => _RideRouteMapPageState();
}

class _RideRouteMapPageState extends State<RideRouteMapPage> {
  GoogleMapController? _mapController;
  int _selectedVehicleIndex = 0;
  double _sheetPosition = 0.65;
  MapType _currentMapType = MapType.normal;

  late final Dio _dio;
  CancelToken? _cancelToken;
  List<LatLng> _routePoints = [];
  String _routeDurationText = '~18 min';
  String _routeDistanceText = '7.8 km';

  List<VehicleTypeEntity> _vehicleTypes = [];
  bool _isLoadingVehicles = true;

  static const List<VehicleTypeEntity> _fallbackVehicleTypes = [
    VehicleTypeEntity(
      id: 1,
      code: 'CAB',
      name: 'Cab (Sedan / Hatchback)',
      description: 'Comfortable AC rides for up to 4 passengers',
      maxPassengers: 4,
      maxWeightKg: 0,
    ),
    VehicleTypeEntity(
      id: 2,
      code: 'AUTO',
      name: 'Auto Rickshaw',
      description: 'Affordable doorstep rides for everyday commute',
      maxPassengers: 3,
      maxWeightKg: 0,
    ),
    VehicleTypeEntity(
      id: 3,
      code: 'BIKE',
      name: 'Bike Taxi',
      description: 'Fastest way to beat traffic solo',
      maxPassengers: 1,
      maxWeightKg: 0,
    ),
    VehicleTypeEntity(
      id: 4,
      code: 'MINI_VAN',
      name: 'Mini Van / Tempo Traveller',
      description: 'Group travel with ample luggage space',
      maxPassengers: 8,
      maxWeightKg: 500,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _dio = widget.dio ?? Dio();
    _cancelToken = CancelToken();
    _fetchRoutePolyline();
    _fetchVehicleTypes();
  }

  /// Fetches active vehicle types from the API or injected usecase
  Future<void> _fetchVehicleTypes() async {
    if (widget.initialVehicleTypes != null &&
        widget.initialVehicleTypes!.isNotEmpty) {
      if (mounted) {
        setState(() {
          _vehicleTypes = widget.initialVehicleTypes!;
          _isLoadingVehicles = false;
        });
      }
      return;
    }

    try {
      if (widget.getVehicleTypesUseCase != null) {
        final types = await widget.getVehicleTypesUseCase!();
        if (types.isNotEmpty && mounted) {
          setState(() {
            _vehicleTypes = types;
            _isLoadingVehicles = false;
          });
          return;
        }
      } else if (sl.isRegistered<GetVehicleTypesUseCase>()) {
        final types = await sl<GetVehicleTypesUseCase>()();
        if (types.isNotEmpty && mounted) {
          setState(() {
            _vehicleTypes = types;
            _isLoadingVehicles = false;
          });
          return;
        }
      }

      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.vehicleTypes}',
        cancelToken: _cancelToken,
        options: Options(
          headers: {'accept': 'application/json'},
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map ? response.data : {};
        final list = data['data'] as List<dynamic>? ?? [];
        final parsed = list.map((item) {
          final m = Map<String, dynamic>.from(item as Map);
          return VehicleTypeModel.fromJson(m).toEntity();
        }).toList();

        if (parsed.isNotEmpty && mounted) {
          setState(() {
            _vehicleTypes = parsed;
            _isLoadingVehicles = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading vehicle types: $e');
    }

    if (mounted) {
      setState(() {
        _vehicleTypes = _fallbackVehicleTypes;
        _isLoadingVehicles = false;
      });
    }
  }

  IconData _getIconForVehicle(String code) {
    final upper = code.toUpperCase();
    if (upper.contains('BIKE') || upper.contains('TWO') || upper.contains('SCOOT')) {
      return Icons.two_wheeler_rounded;
    } else if (upper.contains('AUTO') || upper.contains('RICKSHAW')) {
      return Icons.electric_rickshaw_rounded;
    } else if (upper.contains('VAN') || upper.contains('TRAVELLER') || upper.contains('TEMPO')) {
      return Icons.airport_shuttle_rounded;
    } else if (upper.contains('BUS')) {
      return upper.contains('LUXURY')
          ? Icons.directions_bus_filled_rounded
          : Icons.directions_bus_rounded;
    } else if (upper.contains('TRUCK') || upper.contains('CARGO')) {
      return Icons.local_shipping_rounded;
    }
    return Icons.local_taxi_rounded;
  }

  String _getDefaultSubtitle(VehicleTypeEntity vehicle) {
    if (vehicle.description != null && vehicle.description!.trim().isNotEmpty) {
      return vehicle.description!;
    }
    final upper = vehicle.code.toUpperCase();
    if (upper.contains('BIKE')) return 'Quick & affordable solo ride';
    if (upper.contains('AUTO')) return 'Doorstep pickup for daily commutes';
    if (upper.contains('CAB')) return 'Comfortable AC sedan ride';
    if (upper.contains('VAN')) return 'Ideal for groups & luggage';
    if (upper.contains('TEMPO')) return 'Parcel & goods transport';
    if (upper.contains('BUS')) return 'Spacious group transport';
    if (upper.contains('TRUCK')) return 'Heavy cargo & logistics';
    return 'Fast & reliable ride';
  }

  void _bookVehicle(VehicleTypeEntity vehicle) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RideSummaryPage(
          pickupTitle: widget.pickupTitle,
          pickupAddress: widget.pickupAddress,
          dropTitle: widget.dropTitle,
          dropAddress: widget.dropAddress,
          pickupLatLng: widget.pickupLatLng,
          dropLatLng: widget.dropLatLng,
          selectedVehicle: vehicle,
          routeDistance: _routeDistanceText,
          routeDuration: _routeDurationText,
          routePoints: _routePoints,
          bookingMode: widget.bookingMode,
        ),
      ),
    );
  }

  void _showVehicleDetailsModal(
      BuildContext context, VehicleTypeEntity vehicle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final dividerColor =
        isDark ? AppColors.dividerDark : AppColors.dividerLight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: vehicle.iconUrl != null &&
                              vehicle.iconUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                vehicle.iconUrl!,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => Icon(
                                  _getIconForVehicle(vehicle.code),
                                  color: AppColors.primaryBlue,
                                  size: 28,
                                ),
                              ),
                            )
                          : Icon(
                              _getIconForVehicle(vehicle.code),
                              color: AppColors.primaryBlue,
                              size: 28,
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.name,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFEEF2F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              vehicle.code,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: dividerColor),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: dividerColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.people_alt_rounded,
                                    size: 15, color: AppColors.primaryBlue),
                                const SizedBox(width: 6),
                                Text(
                                  'Passengers',
                                  style: GoogleFonts.inter(
                                      fontSize: 12, color: textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${vehicle.maxPassengers} Max',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: dividerColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.scale_rounded,
                                    size: 15, color: AppColors.primaryBlue),
                                const SizedBox(width: 6),
                                Text(
                                  'Max Cargo',
                                  style: GoogleFonts.inter(
                                      fontSize: 12, color: textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vehicle.maxWeightKg > 0
                                  ? '${vehicle.maxWeightKg.toInt()} kg'
                                  : 'Standard',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'About this ride',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _getDefaultSubtitle(vehicle),
                  style: GoogleFonts.inter(
                      fontSize: 13, color: textSecondary, height: 1.4),
                ),
                const SizedBox(height: 16),
                _buildPerkRow(
                    Icons.check_circle_rounded,
                    'Doorstep pickup with verified driver',
                    textSecondary),
                const SizedBox(height: 8),
                _buildPerkRow(
                    Icons.gps_fixed_rounded,
                    'Real-time GPS ride tracking & SOS',
                    textSecondary),
                const SizedBox(height: 8),
                _buildPerkRow(
                    Icons.payments_outlined,
                    'Digital UPI, Card & Cash payment options',
                    textSecondary),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    key: const Key('modal_book_now_button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(modalContext).pop();
                      _bookVehicle(vehicle);
                    },
                    child: Text(
                      'Book ${vehicle.name}',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerkRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryBlue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 12, color: color),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cancelToken?.cancel();
    super.dispose();
  }

  /// Fetches real road-accurate turn-by-turn geometry points from OSRM
  Future<void> _fetchRoutePolyline() async {
    _generateFallbackCurve();

    try {
      final url =
          '${ApiConstants.osrmRoute}/${widget.pickupLatLng.longitude},${widget.pickupLatLng.latitude};${widget.dropLatLng.longitude},${widget.dropLatLng.latitude}?overview=full&geometries=geojson';
      final response = await _dio.get(
        url,
        cancelToken: _cancelToken,
        options: Options(
          responseType: ResponseType.json,
          sendTimeout: const Duration(seconds: 4),
          receiveTimeout: const Duration(seconds: 4),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map ? response.data : {};
        final routes = data['routes'] as List<dynamic>?;
        if (routes != null && routes.isNotEmpty) {
          final firstRoute = routes.first as Map<String, dynamic>;
          final geometry = firstRoute['geometry'] as Map<String, dynamic>?;
          final coords = geometry?['coordinates'] as List<dynamic>?;
          final durationSeconds =
              (firstRoute['duration'] as num?)?.toDouble() ?? 0;
          final distanceMeters =
              (firstRoute['distance'] as num?)?.toDouble() ?? 0;

          if (coords != null && coords.isNotEmpty) {
            final List<LatLng> points = coords.map((c) {
              final lng = (c[0] as num).toDouble();
              final lat = (c[1] as num).toDouble();
              return LatLng(lat, lng);
            }).toList();

            final mins = (durationSeconds / 60).round();
            final km = (distanceMeters / 1000).toStringAsFixed(1);

            if (mounted) {
              setState(() {
                _routePoints = points;
                _routeDurationText = '~$mins min';
                _routeDistanceText = '$km km';
              });
              _fitRouteBounds();
            }
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('OSRM routing fetch error: $e');
    }
  }

  /// Realistic curved path when network route geometry is unavailable
  void _generateFallbackCurve() {
    final pLat = widget.pickupLatLng.latitude;
    final pLng = widget.pickupLatLng.longitude;
    final dLat = widget.dropLatLng.latitude;
    final dLng = widget.dropLatLng.longitude;

    final points = <LatLng>[
      LatLng(pLat, pLng),
      LatLng(pLat + (dLat - pLat) * 0.25 + 0.002,
          pLng + (dLng - pLng) * 0.15 - 0.001),
      LatLng(pLat + (dLat - pLat) * 0.50 + 0.005,
          pLng + (dLng - pLng) * 0.45 - 0.003),
      LatLng(pLat + (dLat - pLat) * 0.75 + 0.003,
          pLng + (dLng - pLng) * 0.80 + 0.001),
      LatLng(dLat, dLng),
    ];

    if (mounted) {
      setState(() {
        _routePoints = points;
      });
    }
  }

  /// Recenter on the pickup location at high street-level zoom showing all landmarks and street names
  void _recenterNearPickup() {
    if (_mapController == null) return;
    _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: widget.pickupLatLng,
          zoom: 16.5,
        ),
      ),
    );
  }

  /// Fit both points and route on the map
  void _fitRouteBounds() {
    if (_mapController == null) return;
    final southWestLat =
        min(widget.pickupLatLng.latitude, widget.dropLatLng.latitude);
    final southWestLng =
        min(widget.pickupLatLng.longitude, widget.dropLatLng.longitude);
    final northEastLat =
        max(widget.pickupLatLng.latitude, widget.dropLatLng.latitude);
    final northEastLng =
        max(widget.pickupLatLng.longitude, widget.dropLatLng.longitude);

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(southWestLat - 0.005, southWestLng - 0.005),
          northeast: LatLng(northEastLat + 0.005, northEastLng + 0.005),
        ),
        80.0,
      ),
    );
  }

  /// Toggle between Google Street Map, Satellite / Hybrid, and Terrain
  void _toggleMapLayer() {
    setState(() {
      if (_currentMapType == MapType.normal) {
        _currentMapType = MapType.hybrid;
      } else if (_currentMapType == MapType.hybrid) {
        _currentMapType = MapType.terrain;
      } else {
        _currentMapType = MapType.normal;
      }
    });

    final typeName = _currentMapType == MapType.normal
        ? 'Street View'
        : (_currentMapType == MapType.hybrid ? 'Satellite View' : 'Terrain View');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$typeName Enabled'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final dividerColor = isDark ? AppColors.dividerDark : AppColors.dividerLight;

    final markers = {
      Marker(
        markerId: const MarkerId('pickup_marker'),
        position: widget.pickupLatLng,
        infoWindow: InfoWindow(
          title: widget.pickupTitle,
          snippet: widget.pickupAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('drop_marker'),
        position: widget.dropLatLng,
        infoWindow: InfoWindow(
          title: widget.dropTitle,
          snippet: widget.dropAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    final polylines = {
      Polyline(
        polylineId: const PolylineId('route_polyline'),
        points: _routePoints.isNotEmpty
            ? _routePoints
            : [widget.pickupLatLng, widget.dropLatLng],
        color: AppColors.primaryBlue,
        width: 6,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };

    final selectedVehicle = _vehicleTypes.isNotEmpty
        ? _vehicleTypes[
            _selectedVehicleIndex.clamp(0, _vehicleTypes.length - 1)]
        : null;
    final screenHeight = MediaQuery.of(context).size.height;
    final floatingButtonsBottom = screenHeight * _sheetPosition + 12;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // 1. Native Google Map View with Official Street View showing all roads, buildings, and names
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.pickupLatLng,
                zoom: 15.0,
              ),
              mapType: _currentMapType,
              markers: markers,
              polylines: polylines,
              buildingsEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
                _fitRouteBounds();
              },
            ),
          ),

          // 2. Top Route Header with Circular Back Button & Route Capsule
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Circular Themed Back Button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cardBg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    key: const Key('map_back_button'),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: textPrimary,
                      size: 24,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 10),

                // Route Info Capsule (Tap to fit entire route in view)
                Expanded(
                  child: GestureDetector(
                    onTap: _fitRouteBounds,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF16A34A),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.pickupTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.accentOrange,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.dropTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _routeDurationText,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _routeDistanceText,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating Map Controls (Glide smoothly above draggable bottom sheet)
          Positioned(
            right: 16,
            bottom: floatingButtonsBottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // "+ Add stop" Button
                InkWell(
                  key: const Key('map_add_stop_button'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add stop along route'),
                        duration: Duration(seconds: 1),
                        backgroundColor: AppColors.primaryBlue,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: dividerColor,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          color: textPrimary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Add stop',
                          style: GoogleFonts.inter(
                            color: textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Street View / Layer Toggle Button (Street View / Satellite / Terrain)
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dividerColor,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    key: const Key('street_view_mode_button'),
                    padding: EdgeInsets.zero,
                    tooltip: 'Switch Map View',
                    icon: Icon(
                      _currentMapType == MapType.normal
                          ? Icons.map_rounded
                          : Icons.layers_rounded,
                      color: AppColors.primaryBlue,
                      size: 22,
                    ),
                    onPressed: _toggleMapLayer,
                  ),
                ),
                const SizedBox(height: 10),

                // Recenter / Near-Detail Zoom Button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dividerColor,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    key: const Key('map_recenter_button'),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.my_location_rounded,
                      color: AppColors.primaryBlue,
                      size: 22,
                    ),
                    onPressed: _recenterNearPickup,
                  ),
                ),
              ],
            ),
          ),

          // 4. Draggable Bottom Sheet with Brand Theme (Slides down smoothly on swipe)
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _sheetPosition = notification.extent;
              });
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.18,
              maxChildSize: 0.90,
              snap: true,
              snapSizes: const [0.18, 0.65, 0.90],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    children: [
                      // Drag Handle Bar (Swipe down visual indicator)
                      Center(
                        child: Container(
                          width: 42,
                          height: 5,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Discount Ribbon Banner
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primaryBlue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Saving ₹15 with special discount',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Vehicle Options Vertical List
                      if (_isLoadingVehicles)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        )
                      else
                        Column(
                          children:
                              List.generate(_vehicleTypes.length, (index) {
                            final vehicle = _vehicleTypes[index];
                            final isSelected = _selectedVehicleIndex == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedVehicleIndex = index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryBlue.withValues(
                                          alpha: isDark ? 0.15 : 0.08)
                                      : (isDark
                                          ? const Color(0xFF1E293B)
                                          : const Color(0xFFF8FAFC)),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : dividerColor,
                                    width: isSelected ? 2.0 : 1.0,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Vehicle Icon / Avatar
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.primaryBlue
                                                .withValues(alpha: 0.12)
                                            : (isDark
                                                ? const Color(0xFF0F172A)
                                                : const Color(0xFFEDF2F7)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: vehicle.iconUrl != null &&
                                              vehicle.iconUrl!.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                vehicle.iconUrl!,
                                                fit: BoxFit.contain,
                                                errorBuilder: (_, _, _) =>
                                                    Icon(
                                                  _getIconForVehicle(
                                                      vehicle.code),
                                                  color: isSelected
                                                      ? AppColors.primaryBlue
                                                      : textSecondary,
                                                  size: 26,
                                                ),
                                              ),
                                            )
                                          : Icon(
                                              _getIconForVehicle(vehicle.code),
                                              color: isSelected
                                                  ? AppColors.primaryBlue
                                                  : textSecondary,
                                              size: 26,
                                            ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Name, Subtitle, Capacity
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vehicle.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            _getDefaultSubtitle(vehicle),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 13,
                                                color: textSecondary,
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                '${vehicle.maxPassengers}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  color: textSecondary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              if (vehicle.maxWeightKg > 0) ...[
                                                const SizedBox(width: 8),
                                                Icon(
                                                  Icons.scale_rounded,
                                                  size: 13,
                                                  color: textSecondary,
                                                ),
                                                const SizedBox(width: 3),
                                                Text(
                                                  '${vehicle.maxWeightKg.toInt()} kg',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color: textSecondary,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Right Side: No Price, Two Clickable Texts: "Book Now" & "View Details"
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // "Book Now" Clickable Action
                                        InkWell(
                                          key: Key('book_now_${vehicle.id}'),
                                          onTap: () {
                                            setState(() {
                                              _selectedVehicleIndex = index;
                                            });
                                            _bookVehicle(vehicle);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryBlue,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primaryBlue
                                                      .withValues(alpha: 0.25),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 1),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              'Book Now',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),

                                        // "View Details" Clickable Text
                                        InkWell(
                                          key: Key(
                                              'view_details_${vehicle.id}'),
                                          onTap: () => _showVehicleDetailsModal(
                                              context, vehicle),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 2),
                                            child: Text(
                                              'View Details',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: isDark
                                                    ? const Color(0xFF60A5FA)
                                                    : AppColors.primaryBlue,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      const SizedBox(height: 10),

                      // Payment & Offers Row
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF0F172A)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: dividerColor),
                        ),
                        child: Row(
                          children: [
                            // Rapido Wallet
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue
                                          .withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet_rounded,
                                      color: AppColors.primaryBlue,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Rapido Wallet',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: textPrimary,
                                              ),
                                            ),
                                            Icon(
                                              Icons.chevron_right,
                                              size: 16,
                                              color: textSecondary,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Low Balance: ₹0.0',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFFEF4444),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              height: 28,
                              width: 1,
                              color: dividerColor,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            ),

                            // Offers
                            InkWell(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981)
                                          .withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.local_offer_rounded,
                                      color: Color(0xFF10B981),
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Offers',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimary,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 16,
                                    color: textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Brand-Theme Action Button: "Book <Vehicle>"
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          key: const Key('confirm_ride_booking_button'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: selectedVehicle != null
                              ? () => _bookVehicle(selectedVehicle)
                              : null,
                          child: Text(
                            selectedVehicle != null
                                ? 'Book ${selectedVehicle.name}'
                                : 'Select a Vehicle',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

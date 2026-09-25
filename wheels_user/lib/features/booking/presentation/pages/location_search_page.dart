import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/api_constants.dart';
import '../../../favourites/presentation/bloc/favourites_bloc.dart';
import '../../../favourites/presentation/bloc/favourites_event.dart';
import '../../../favourites/presentation/bloc/favourites_state.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../widgets/location_list_item.dart';
import '../widgets/route_input_card.dart';
import 'ride_route_map_page.dart';

/// Location Search & Booking Page matching exact reference UI design.
/// - From: Fetches user's current GPS location and reverse-geocodes full building name, road, and city.
/// - To: Connects to Google Places API (New) for live destination autocomplete search.
/// - List: Displays exclusively saved locations from /api/v1/customer/saved-locations.
class LocationSearchPage extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;
  final bool initialIsCorporate;

  const LocationSearchPage({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
    this.initialIsCorporate = false,
  });

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  late final TextEditingController _pickupController;
  late final TextEditingController _dropController;
  final FocusNode _dropFocusNode = FocusNode();
  final FocusNode _pickupFocusNode = FocusNode();

  bool _isSelectingPickup = false;
  bool _isCorporateRide = false;
  String _selectedTripMode = 'INSTANT';

  LatLng? _pickupLatLng;
  LatLng? _dropLatLng;

  void _checkCorporateDistanceAutoSelect() {
    if (_isCorporateRide && _pickupLatLng != null && _dropLatLng != null) {
      final distanceMeters = Geolocator.distanceBetween(
        _pickupLatLng!.latitude,
        _pickupLatLng!.longitude,
        _dropLatLng!.latitude,
        _dropLatLng!.longitude,
      );
      final distanceKm = distanceMeters / 1000.0;
      if (distanceKm > 80.0) {
        setState(() {
          _selectedTripMode = 'ONE_WAY';
        });
      }
    }
  }

  // Google Places Search State
  Timer? _searchDebounceTimer;
  bool _isSearchingGoogle = false;
  List<Map<String, dynamic>> _googleSearchResults = [];

  final Dio _dio = Dio();

  void _onControllersChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    final prefs = sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : null;
    final isCorp = prefs?.getBool('is_corporate_user') ?? false;
    final corpLoc = prefs?.getString('corporate_location') ?? prefs?.getString('company_location') ?? '';
    if (widget.initialIsCorporate && isCorp) {
      _isCorporateRide = true;
    }
    final initialPickup = context.read<BookingBloc>().state.pickupLocation;
    String initialText = initialPickup.trim().isNotEmpty
        ? initialPickup
        : 'Fetching current location...';
    if (_isCorporateRide && corpLoc.trim().isNotEmpty) {
      initialText = corpLoc.trim();
    }
    _pickupController = TextEditingController(text: initialText);
    _dropController = TextEditingController();
    _pickupController.addListener(_onControllersChanged);
    _dropController.addListener(_onControllersChanged);

    // 1. Fetch real current GPS location with full address and building name for "From"
    _fetchCurrentLocation();

    // 2. Load Booking Data & Saved Locations from Backend API
    context.read<BookingBloc>().add(const LoadBookingDataEvent());
    try {
      context.read<FavouritesBloc>().add(const LoadFavouritesEvent());
    } catch (_) {}
  }

  @override
  void dispose() {
    _pickupController.removeListener(_onControllersChanged);
    _dropController.removeListener(_onControllersChanged);
    _searchDebounceTimer?.cancel();
    _pickupController.dispose();
    _dropController.dispose();
    _pickupFocusNode.dispose();
    _dropFocusNode.dispose();
    super.dispose();
  }

  /// Directly fetch current location using Geolocator and resolve full building name and road
  Future<void> _fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _pickupController.text = 'Location service disabled';
          });
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _pickupController.text = 'Location permission denied';
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _pickupController.text = 'Location permission permanently denied';
          });
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      _pickupLatLng = LatLng(position.latitude, position.longitude);

      // Query reverse geocoding for full building name, road, and city
      try {
        final response = await _dio.get(
          ApiConstants.nominatimReverse,
          queryParameters: {
            'lat': position.latitude.toString(),
            'lon': position.longitude.toString(),
            'format': 'json',
            'addressdetails': '1',
          },
          options: Options(
            headers: {'User-Agent': 'WheelsUserApp/1.0'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data is Map ? response.data : {};
          final address = data['address'] as Map<dynamic, dynamic>?;

          if (address != null) {
            final building = address['building'] ??
                address['commercial'] ??
                address['amenity'] ??
                address['office'] ??
                address['shop'] ??
                address['house_name'];
            final road = address['road'] ?? address['neighbourhood'];
            final suburb = address['suburb'] ?? address['residential'];
            final city = address['city'] ?? address['town'] ?? address['county'];

            final components = [
              if (building != null && building.toString().trim().isNotEmpty) building,
              if (road != null && road.toString().trim().isNotEmpty) road,
              if (suburb != null && suburb.toString().trim().isNotEmpty) suburb,
              if (city != null && city.toString().trim().isNotEmpty) city,
            ];

            final formattedAddress = components.isNotEmpty
                ? components.join(', ')
                : (data['display_name'] as String? ?? 'Current Location');

            if (mounted) {
              if (!_isCorporateRide || _pickupController.text == 'Fetching current location...') {
                setState(() {
                  _pickupController.text = formattedAddress;
                });
                context.read<BookingBloc>().add(ChangePickupLocationEvent(formattedAddress));
              }
            }
            return;
          } else if (data['display_name'] != null) {
            final formatted = data['display_name'].toString();
            if (mounted) {
              if (!_isCorporateRide || _pickupController.text == 'Fetching current location...') {
                setState(() {
                  _pickupController.text = formatted;
                });
                context.read<BookingBloc>().add(ChangePickupLocationEvent(formatted));
              }
            }
            return;
          }
        }
      } catch (e) {
        debugPrint('Reverse geocoding address error: $e');
      }

      if (mounted) {
        const fallback = 'Current Location';
        if (!_isCorporateRide || _pickupController.text == 'Fetching current location...') {
          setState(() {
            _pickupController.text = fallback;
          });
          context.read<BookingBloc>().add(const ChangePickupLocationEvent(fallback));
        }
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
      if (mounted) {
        if (!_isCorporateRide || _pickupController.text == 'Fetching current location...') {
          setState(() {
            _pickupController.text = 'Current Location';
          });
        }
      }
    }
  }

  /// Live search when typing in "To" (Drop location)
  void _onDropTextChanged(String query) {
    setState(() {});
    _searchDebounceTimer?.cancel();

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _isSearchingGoogle = false;
        _googleSearchResults.clear();
      });
      return;
    }

    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _executeGooglePlacesSearch(trimmed);
    });
  }

  /// Execute search using Google Places API (New) with fallback to OpenStreetMap search
  Future<void> _executeGooglePlacesSearch(String query) async {
    setState(() {
      _isSearchingGoogle = true;
    });

    // 1. Google Places API (New)
    try {
      final response = await _dio.post(
        ApiConstants.googlePlacesNewAutocomplete,
        data: {
          'input': query,
          'includedRegionCodes': ['IN'],
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': ApiConstants.googleMapsApiKey,
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map ? response.data : {};
        final suggestions = (data['suggestions'] as List<dynamic>?) ?? [];

        final results = suggestions.map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          final prediction = map['placePrediction'] as Map<dynamic, dynamic>?;
          final struct = prediction?['structuredFormat'] as Map<dynamic, dynamic>?;
          final mainText = struct?['mainText']?['text'] ?? prediction?['text']?['text'] ?? query;
          final secondaryText = struct?['secondaryText']?['text'] ?? '';
          final placeId = prediction?['placeId'] ?? '';

          return {
            'place_id': placeId,
            'title': mainText.toString(),
            'address': secondaryText.toString(),
            'description': '$mainText, $secondaryText',
          };
        }).toList();

        if (results.isNotEmpty && mounted) {
          setState(() {
            _googleSearchResults = results;
            _isSearchingGoogle = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Google Places API (New) search error: $e');
    }

    // 2. OpenStreetMap Search Fallback if Google search produces no results
    try {
      final response = await _dio.get(
        ApiConstants.nominatimSearch,
        queryParameters: {
          'q': query,
          'format': 'json',
          'addressdetails': '1',
          'limit': '10',
          'countrycodes': 'in',
        },
        options: Options(
          headers: {'User-Agent': 'WheelsUserApp/1.0'},
        ),
      );

      if (response.statusCode == 200 && response.data is List) {
        final items = response.data as List<dynamic>;
        final results = items.map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          final name = map['name'] ?? map['display_name'] ?? query;
          final displayName = map['display_name'] ?? '';
          return {
            'place_id': '',
            'title': name.toString(),
            'address': displayName.toString(),
            'description': displayName.toString(),
            'latitude': double.tryParse(map['lat']?.toString() ?? ''),
            'longitude': double.tryParse(map['lon']?.toString() ?? ''),
          };
        }).toList();

        if (mounted) {
          setState(() {
            _googleSearchResults = results;
            _isSearchingGoogle = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Search fallback error: $e');
    }

    if (mounted) {
      setState(() {
        _isSearchingGoogle = false;
      });
    }
  }

  /// Select a place from Google Search or from Saved Locations
  Future<void> _selectPlace(Map<String, dynamic> item) async {
    final title = item['title'] as String;
    final placeId = (item['place_id'] as String?) ?? '';

    if (_isSelectingPickup) {
      _pickupController.text = title;
      context.read<BookingBloc>().add(ChangePickupLocationEvent(title));
      setState(() {
        _isSelectingPickup = false;
      });
      _dropFocusNode.requestFocus();
    } else {
      _dropController.text = title;
      context.read<BookingBloc>().add(ChangeDestinationEvent(title));
      setState(() {
        _googleSearchResults.clear();
      });
    }

    // Resolve coordinates using Google Place Details (New) if placeId is present
    if (placeId.isNotEmpty) {
      try {
        final response = await _dio.get(
          '${ApiConstants.googlePlacesNewDetails}/$placeId',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'X-Goog-Api-Key': ApiConstants.googleMapsApiKey,
              'X-Goog-FieldMask': 'id,displayName,formattedAddress,location',
            },
          ),
        );
        if (response.statusCode == 200 && response.data != null) {
          final data = response.data as Map<dynamic, dynamic>;
          final loc = data['location'] as Map<dynamic, dynamic>?;
          if (loc != null) {
            final lat = (loc['latitude'] as num).toDouble();
            final lng = (loc['longitude'] as num).toDouble();
            setState(() {
              if (_isSelectingPickup) {
                _pickupLatLng = LatLng(lat, lng);
              } else {
                _dropLatLng = LatLng(lat, lng);
              }
              _checkCorporateDistanceAutoSelect();
            });
            return;
          }
        }
      } catch (e) {
        debugPrint('Place Details (New) error: $e');
      }
    }

    if (item['latitude'] != null && item['longitude'] != null) {
      final lat = (item['latitude'] as num).toDouble();
      final lng = (item['longitude'] as num).toDouble();
      setState(() {
        if (_isSelectingPickup) {
          _pickupLatLng = LatLng(lat, lng);
        } else {
          _dropLatLng = LatLng(lat, lng);
        }
        _checkCorporateDistanceAutoSelect();
      });
    }
  }

  bool get _isReadyToBook {
    final pickup = _pickupController.text.trim();
    final drop = _dropController.text.trim();
    final isPickupValid = pickup.isNotEmpty &&
        pickup != 'Fetching current location...' &&
        pickup != 'Location service disabled' &&
        !pickup.startsWith('Location permission');
    final isDropValid = drop.isNotEmpty;
    return isPickupValid && isDropValid;
  }

  void _navigateToMap() {
    if (!_isReadyToBook) return;
    final pickup = _pickupController.text.isNotEmpty
        ? _pickupController.text
        : 'Current Location';
    final drop = _dropController.text.isNotEmpty
        ? _dropController.text
        : 'Selected Location';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RideRouteMapPage(
          pickupTitle: pickup,
          pickupAddress: pickup,
          dropTitle: drop,
          dropAddress: drop,
          pickupLatLng: _pickupLatLng ?? const LatLng(17.4483, 78.3915),
          dropLatLng: _dropLatLng ?? const LatLng(17.4938, 78.3995),
          bookingMode: _selectedTripMode,
          isCorporate: _isCorporateRide,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : Colors.white;
    final textPrimary = isDark ? AppColors.white : const Color(0xFF0F172A);
    final borderColor = isDark ? AppColors.dividerDark : const Color(0xFFCBD5E1);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          key: const Key('drop_screen_back_button'),
          icon: Icon(
            Icons.arrow_back,
            color: textPrimary,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _isSelectingPickup ? AppStrings.pickupTitle : AppStrings.dropTitle,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        centerTitle: false,
        actions: [
          // Self-ride / Corporate-ride Toggle Pill
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
            child: Container(
              height: 36,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    key: const Key('self_ride_toggle_button'),
                    onTap: () {
                      setState(() {
                        _isCorporateRide = false;
                      });
                      _fetchCurrentLocation();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: !_isCorporateRide ? AppColors.primaryBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 13,
                            color: !_isCorporateRide
                                ? Colors.white
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Self',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: !_isCorporateRide
                                  ? Colors.white
                                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    key: const Key('corporate_ride_toggle_button'),
                    onTap: () {
                      final prefs = sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : null;
                      final isCorp = prefs?.getBool('is_corporate_user') ?? false;
                      if (!isCorp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Your account is not linked to an active corporate company.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      final corpLocation = prefs?.getString('corporate_location') ?? prefs?.getString('company_location') ?? '';
                      setState(() {
                        _isCorporateRide = true;
                        if (corpLocation.trim().isNotEmpty) {
                          _pickupController.text = corpLocation.trim();
                          context.read<BookingBloc>().add(ChangePickupLocationEvent(corpLocation.trim()));
                        }
                      });
                      _checkCorporateDistanceAutoSelect();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isCorporateRide ? AppColors.primaryBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.business_rounded,
                            size: 13,
                            color: _isCorporateRide
                                ? Colors.white
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Corporate',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _isCorporateRide
                                  ? Colors.white
                                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
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
        ],
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, bookingState) {
          if (bookingState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryBlue),
            );
          }

          final isActivelySearching = _dropController.text.trim().isNotEmpty &&
              (_googleSearchResults.isNotEmpty || _isSearchingGoogle);

          return Column(
            children: [
              // 1. Top Section: Route Box & Action Pills
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  children: [
                    // Route Selector Card
                    RouteInputCard(
                      pickupController: _pickupController,
                      dropController: _dropController,
                      pickupFocusNode: _pickupFocusNode,
                      dropFocusNode: _dropFocusNode,
                      isPickupActive: _isSelectingPickup,
                      onPickupTap: () {
                        setState(() {
                          _isSelectingPickup = true;
                        });
                      },
                      onDropTap: () {
                        setState(() {
                          _isSelectingPickup = false;
                        });
                      },
                      onPickupChanged: (val) => setState(() {}),
                      onDropChanged: _onDropTextChanged,
                      onClearPickup: () {
                        _pickupController.clear();
                        setState(() {});
                      },
                      onClearDrop: () {
                        _dropController.clear();
                        setState(() {
                          _googleSearchResults.clear();
                        });
                      },
                    ),
                    const SizedBox(height: 14),

                    // Single selection Trip Mode Chips (Instant, One-Way, Round Trip)
                    Row(
                      children: [
                        _buildTripModeChip('Instant', 'INSTANT', textPrimary, borderColor, isDark),
                        const SizedBox(width: 8),
                        _buildTripModeChip('One-Way', 'ONE_WAY', textPrimary, borderColor, isDark),
                        const SizedBox(width: 8),
                        _buildTripModeChip('Round Trip', 'ROUND_TRIP', textPrimary, borderColor, isDark),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Main Content: Google Search Results OR Saved Locations from API
              Expanded(
                child: isActivelySearching
                    ? _buildGoogleSearchResultsView(context)
                    : _buildSavedLocationsFromApi(context),
              ),

              // 3. Bottom Action Bar: Always show "Book Now" button at the bottom
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      key: const Key('book_location_button'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        disabledBackgroundColor: isDark
                            ? AppColors.cardDark.withValues(alpha: 0.6)
                            : const Color(0xFFE2E8F0),
                        disabledForegroundColor: isDark
                            ? AppColors.textSecondaryDark
                            : const Color(0xFF94A3B8),
                        foregroundColor: Colors.white,
                        elevation: _isReadyToBook ? 3 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _isReadyToBook ? _navigateToMap : null,
                      child: Text(
                        AppStrings.bookNow,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isReadyToBook
                              ? Colors.white
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Displays live Google Places search predictions
  Widget _buildGoogleSearchResultsView(BuildContext context) {
    if (_isSearchingGoogle) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryBlue),
      );
    }

    if (_googleSearchResults.isEmpty) {
      return Center(
        child: Text(
          'No matching locations found',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _googleSearchResults.length,
      itemBuilder: (context, index) {
        final item = _googleSearchResults[index];
        final isLast = index == _googleSearchResults.length - 1;

        return LocationListItem(
          title: item['title'] as String,
          address: (item['address'] as String?) ?? '',
          isFavorite: false,
          isHistory: false,
          showDivider: !isLast,
          onTap: () => _selectPlace(item),
        );
      },
    );
  }

  /// Displays strictly the Saved Locations fetched from /api/v1/customer/saved-locations
  Widget _buildSavedLocationsFromApi(BuildContext context) {
    bool hasBloc = false;
    try {
      BlocProvider.of<FavouritesBloc>(context);
      hasBloc = true;
    } catch (_) {
      hasBloc = false;
    }

    if (!hasBloc) {
      return _buildEmptySavedLocations(context);
    }

    return BlocBuilder<FavouritesBloc, FavouritesState>(
      builder: (context, favState) {
        if (favState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        final places = favState.favouritesEntity?.places ?? [];

        if (places.isEmpty) {
          return _buildEmptySavedLocations(context);
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: places.length,
          itemBuilder: (context, index) {
            final place = places[index];
            final isLast = index == places.length - 1;

            return LocationListItem(
              title: place.title,
              address: place.address,
              isFavorite: true,
              isHistory: false,
              showDivider: !isLast,
              onTap: () {
                _selectPlace({
                  'title': place.title,
                  'address': place.address,
                  'latitude': place.latitude,
                  'longitude': place.longitude,
                });
              },
              onHeartTap: () {
                context.read<FavouritesBloc>().add(DeleteFavoriteEvent(place.id));
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptySavedLocations(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_outline_rounded,
              size: 48,
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 12),
            Text(
              'No saved locations yet',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Places saved to your account will appear here',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripModeChip(
    String label,
    String value,
    Color textPrimary,
    Color borderColor,
    bool isDark,
  ) {
    final isSelected = _selectedTripMode == value;
    return Expanded(
      child: InkWell(
        key: Key('trip_mode_chip_$value'),
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            _selectedTripMode = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : borderColor,
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textSecondaryDark : const Color(0xFF475569)),
            ),
          ),
        ),
      ),
    );
  }
}

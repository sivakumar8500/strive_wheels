import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../history/presentation/widgets/ride_history_top_bar.dart';
import '../bloc/favourites_bloc.dart';
import '../bloc/favourites_event.dart';
import '../bloc/favourites_state.dart';
import '../widgets/favorite_place_card.dart';
import '../widgets/favourites_header.dart';
import '../widgets/shortcut_shelf_card.dart';

/// Saved Places / Favourites Screen matching exact reference UI design.
class FavouritesPage extends StatefulWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationTap;

  const FavouritesPage({
    super.key,
    this.onMenuTap,
    this.onNotificationTap,
  });

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    context.read<FavouritesBloc>().add(const LoadFavouritesEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isFetchingLocation = true;
    });

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied.')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are permanently denied.')),
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      
      _latController.text = position.latitude.toString();
      _lngController.text = position.longitude.toString();

      final placemarks = await Geocoding().placemarkFromCoordinates(
          position.latitude, position.longitude);
          
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}';
        // Clean up commas if some fields are null
        _addressController.text = address.replaceAll(RegExp(r',\s*,'), ',').replaceAll(RegExp(r'^,\s*|\s*,\s*$'), '');
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get current location.')),
      );
    } finally {
      setState(() {
        _isFetchingLocation = false;
      });
    }
  }

  void _showAddLocationBottomSheet(BuildContext context, bool isDark) {
    _titleController.clear();
    _addressController.clear();
    _latController.clear();
    _lngController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.onboardingBgDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Save New Place',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title (e.g., Home, Work)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  StatefulBuilder(
                    builder: (context, setModalState) {
                      return IconButton(
                        onPressed: _isFetchingLocation ? null : () async {
                          setModalState(() => _isFetchingLocation = true);
                          await _fetchCurrentLocation();
                          setModalState(() => _isFetchingLocation = false);
                        },
                        icon: _isFetchingLocation 
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.my_location, color: AppColors.primaryBlue),
                        tooltip: 'Use current location',
                      );
                    }
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _latController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Latitude',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _lngController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Longitude',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_titleController.text.trim().isNotEmpty &&
                        _addressController.text.trim().isNotEmpty) {
                      context.read<FavouritesBloc>().add(
                            AddFavoriteEvent(
                              title: _titleController.text.trim(),
                              address: _addressController.text.trim(),
                              iconType: 'home', // Will be resolved dynamically
                              latitude: double.tryParse(_latController.text.trim()) ?? 17.4312,
                              longitude: double.tryParse(_lngController.text.trim()) ?? 78.4069,
                            ),
                          );
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(
                    'Save Location',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? AppColors.onboardingBgDark : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: RideHistoryTopBar(
        onMenuTap: widget.onMenuTap,
        onNotificationTap: widget.onNotificationTap,
      ),
      body: BlocConsumer<FavouritesBloc, FavouritesState>(
        listener: (context, state) {
          if (state.rideMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.rideMessage!),
                backgroundColor: AppColors.primaryBlue,
              ),
            );
          } else if (state.actionMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.actionMessage!),
                backgroundColor: AppColors.primaryBlue,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlue,
              ),
            );
          }

          final entity = state.favouritesEntity;
          final places = entity?.places ?? [];

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 8,
              bottom: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Section
                FavouritesHeader(
                  onAddTap: () {
                    _showAddLocationBottomSheet(context, isDark);
                  },
                ),

                const SizedBox(height: 20),

                // 2. Shortcut Shelf Card
                ShortcutShelfCard(
                  title: entity?.shortcutTitle ?? AppStrings.placesYouRideToMost,
                  subtitle: entity?.shortcutSubtitle ?? AppStrings.tapPlaceToUseAsDestination,
                ),

                const SizedBox(height: 24),

                // 3. Saved Places List
                if (places.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.location_off_outlined,
                          size: 48,
                          color: isDark ? Colors.white54 : Colors.black38,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No saved locations yet',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...places.map((place) {
                    return Dismissible(
                      key: Key('place_${place.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        context
                            .read<FavouritesBloc>()
                            .add(DeleteFavoriteEvent(place.id));
                      },
                      child: FavoritePlaceCard(
                        place: place,
                        onRideHereTap: () {
                          context.read<FavouritesBloc>().add(
                                RideHereEvent(
                                  placeId: place.id,
                                  placeTitle: place.title,
                                ),
                              );
                        },
                      ),
                    );
                  }),

                const SizedBox(height: 12),

                // 4. Full-Width Outlined Button: "Save another place"
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    key: const Key('save_another_place_button'),
                    onPressed: () {
                      _showAddLocationBottomSheet(context, isDark);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF8FAFC),
                      side: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : AppColors.primaryBlue.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.saveAnotherPlace,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

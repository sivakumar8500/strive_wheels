import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
  @override
  void initState() {
    super.initState();
    context.read<FavouritesBloc>().add(const LoadFavouritesEvent());
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
                    context
                        .read<FavouritesBloc>()
                        .add(const SaveAnotherPlaceEvent());
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
                ...places.map((place) {
                  return FavoritePlaceCard(
                    place: place,
                    onRideHereTap: () {
                      context.read<FavouritesBloc>().add(
                            RideHereEvent(
                              placeId: place.id,
                              placeTitle: place.title,
                            ),
                          );
                    },
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
                      context
                          .read<FavouritesBloc>()
                          .add(const SaveAnotherPlaceEvent());
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

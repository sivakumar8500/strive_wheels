import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_constants.dart';
import '../models/favorite_place_model.dart';
import '../models/favourites_model.dart';

abstract class FavouritesRemoteDataSource {
  Future<FavouritesModel> getFavouritesData();
  Future<void> addFavorite(FavoritePlaceModel place);
  Future<void> updateFavorite(FavoritePlaceModel place);
  Future<void> deleteFavorite(String id);
}

class FavouritesRemoteDataSourceImpl implements FavouritesRemoteDataSource {
  final Dio dio;

  FavouritesRemoteDataSourceImpl({required this.dio});

  @override
  Future<FavouritesModel> getFavouritesData() async {
    try {
      final response = await dio.get(ApiConstants.savedLocations);
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('====== GET SAVED LOCATIONS SUCCESS ======');
        debugPrint(response.data.toString());
        final responseData = response.data is String 
            ? jsonDecode(response.data) 
            : response.data;
            
        final List<dynamic> data = responseData['data'] ?? [];
        final places = data
            .map((e) => FavoritePlaceModel.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();

        return FavouritesModel(
          shortcutTitle: 'Places you ride to most',
          shortcutSubtitle: 'Tap a place to use as your destination',
          places: places,
        );
      } else {
        debugPrint('====== GET SAVED LOCATIONS FAILED: ${response.statusCode} ======');
        throw Exception('Failed to load favourites');
      }
    } catch (e) {
      debugPrint('====== GET SAVED LOCATIONS ERROR ======');
      debugPrint(e.toString());
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> addFavorite(FavoritePlaceModel place) async {
    try {
      final response = await dio.post(
        ApiConstants.savedLocations,
        data: {
          'title': place.title,
          'address': place.address,
          'latitude': place.latitude ?? 17.4312,
          'longitude': place.longitude ?? 78.4069,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('====== ADD SAVED LOCATION SUCCESS ======');
        debugPrint(response.data.toString());
      } else {
        debugPrint('====== ADD SAVED LOCATION FAILED: ${response.statusCode} ======');
        throw Exception('Failed to add favorite');
      }
    } catch (e) {
      debugPrint('====== ADD SAVED LOCATION ERROR ======');
      debugPrint(e.toString());
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> updateFavorite(FavoritePlaceModel place) async {
    try {
      final response = await dio.put(
        '${ApiConstants.savedLocations}/${place.id}',
        data: place.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update favorite');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> deleteFavorite(String id) async {
    try {
      final response = await dio.delete(
        '${ApiConstants.savedLocations}/$id',
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete favorite');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final SharedPreferences? sharedPreferences;

  static const String _prefCorporateKeys = 'corporate_saved_location_keys';
  static const String _prefCorporateIds = 'corporate_saved_location_ids';

  FavouritesRemoteDataSourceImpl({
    required this.dio,
    this.sharedPreferences,
  });

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
        final corpKeys = _getStoredCorporateKeys();
        final corpIds = _getStoredCorporateIds();
        final companyLoc = sharedPreferences?.getString('corporate_location') ??
            sharedPreferences?.getString('company_location') ?? '';

        final places = data.map((e) {
          final map = Map<String, dynamic>.from(e as Map);
          final rawId = map['id']?.toString() ?? '';
          final rawTitle = (map['title']?.toString() ?? '').trim();
          final rawAddress = (map['address']?.toString() ?? '').trim();
          final key = '$rawTitle|$rawAddress'.toLowerCase();
          final titleLower = rawTitle.toLowerCase();

          // Check if marked corporate either in response, or in local storage, or keywords
          bool isCorp = (map['is_corporate'] == true) ||
              (map['location_type']?.toString().toUpperCase() == 'CORPORATE') ||
              corpIds.contains(rawId) ||
              corpKeys.contains(key) ||
              corpKeys.contains(titleLower);

          // Additional smart fallback: if title matches corporate keywords or company location
          if (!isCorp) {
            if (companyLoc.isNotEmpty && rawAddress.isNotEmpty &&
                (companyLoc.toLowerCase().contains(rawAddress.toLowerCase()) ||
                 rawAddress.toLowerCase().contains(companyLoc.toLowerCase()))) {
              isCorp = true;
            } else if (titleLower == 'office' ||
                       titleLower == 'head office' ||
                       titleLower == 'work' ||
                       titleLower == 'client site' ||
                       titleLower.contains('corporate')) {
              isCorp = true;
            }
          }

          map['location_type'] = isCorp ? 'CORPORATE' : (map['location_type'] ?? 'SELF');
          map['is_corporate'] = isCorp;

          return FavoritePlaceModel.fromJson(map);
        }).toList();

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
      final isCorporate = place.isCorporate || place.locationType.toUpperCase() == 'CORPORATE';
      
      // Persist to local preferences so it reflects even if server ignores fields
      if (isCorporate) {
        _addCorporateKey(place.title, place.address);
      } else {
        _removeCorporateKey(place.title, place.address);
      }

      final response = await dio.post(
        ApiConstants.savedLocations,
        data: {
          'title': place.title,
          'address': place.address,
          'latitude': place.latitude ?? 17.4312,
          'longitude': place.longitude ?? 78.4069,
          'location_type': isCorporate ? 'CORPORATE' : 'SELF',
          'is_corporate': isCorporate,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('====== ADD SAVED LOCATION SUCCESS ======');
        debugPrint(response.data.toString());
        final resData = response.data is String ? jsonDecode(response.data) : response.data;
        final savedItem = resData is Map ? (resData['data'] ?? resData) : null;
        if (savedItem is Map && savedItem['id'] != null && isCorporate) {
          _addCorporateId(savedItem['id'].toString());
        }
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
      final isCorporate = place.isCorporate || place.locationType.toUpperCase() == 'CORPORATE';
      if (isCorporate) {
        _addCorporateId(place.id.toString());
        _addCorporateKey(place.title, place.address);
      } else {
        _removeCorporateId(place.id.toString());
        _removeCorporateKey(place.title, place.address);
      }

      final response = await dio.put(
        '${ApiConstants.savedLocations}/${place.id}',
        data: {
          ...place.toJson(),
          'location_type': isCorporate ? 'CORPORATE' : 'SELF',
          'is_corporate': isCorporate,
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update favorite');
      }
    } catch (e) {
      debugPrint('====== UPDATE SAVED LOCATION ERROR: $e ======');
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> deleteFavorite(String id) async {
    try {
      _removeCorporateId(id);
      final response = await dio.delete(
        '${ApiConstants.savedLocations}/$id',
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete favorite');
      }
    } catch (e) {
      debugPrint('====== DELETE SAVED LOCATION ERROR: $e ======');
      throw Exception('Network error: $e');
    }
  }

  Set<String> _getStoredCorporateKeys() {
    final list = sharedPreferences?.getStringList(_prefCorporateKeys) ?? [];
    return list.map((e) => e.toLowerCase()).toSet();
  }

  Set<String> _getStoredCorporateIds() {
    final list = sharedPreferences?.getStringList(_prefCorporateIds) ?? [];
    return list.toSet();
  }

  void _addCorporateKey(String title, String address) {
    if (sharedPreferences == null) return;
    final keys = _getStoredCorporateKeys();
    keys.add('$title|$address'.toLowerCase());
    keys.add(title.trim().toLowerCase());
    sharedPreferences?.setStringList(_prefCorporateKeys, keys.toList());
  }

  void _removeCorporateKey(String title, String address) {
    if (sharedPreferences == null) return;
    final keys = _getStoredCorporateKeys();
    keys.remove('$title|$address'.toLowerCase());
    keys.remove(title.trim().toLowerCase());
    sharedPreferences?.setStringList(_prefCorporateKeys, keys.toList());
  }

  void _addCorporateId(String id) {
    if (sharedPreferences == null || id.isEmpty) return;
    final ids = _getStoredCorporateIds();
    ids.add(id);
    sharedPreferences?.setStringList(_prefCorporateIds, ids.toList());
  }

  void _removeCorporateId(String id) {
    if (sharedPreferences == null || id.isEmpty) return;
    final ids = _getStoredCorporateIds();
    ids.remove(id);
    sharedPreferences?.setStringList(_prefCorporateIds, ids.toList());
  }
}


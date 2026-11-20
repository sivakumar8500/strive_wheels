import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActiveBookingData {
  final String bookingId;
  final String driverName;
  final double driverRating;
  final String vehicleInfo;
  final String pickupAddress;
  final String dropAddress;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;
  final LatLng? initialRiderLatLng;
  final String totalAmount;
  final String? startOtp;
  final String status; // 'SEARCHING', 'RIDER_ACCEPTED', 'DRIVER_ARRIVED', 'TRIP_STARTED'

  const ActiveBookingData({
    required this.bookingId,
    required this.driverName,
    required this.driverRating,
    required this.vehicleInfo,
    required this.pickupAddress,
    required this.dropAddress,
    required this.pickupLatLng,
    required this.dropLatLng,
    this.initialRiderLatLng,
    required this.totalAmount,
    this.startOtp,
    this.status = 'RIDER_ACCEPTED',
  });

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'driverName': driverName,
      'driverRating': driverRating,
      'vehicleInfo': vehicleInfo,
      'pickupAddress': pickupAddress,
      'dropAddress': dropAddress,
      'pickupLat': pickupLatLng.latitude,
      'pickupLng': pickupLatLng.longitude,
      'dropLat': dropLatLng.latitude,
      'dropLng': dropLatLng.longitude,
      'initialRiderLat': initialRiderLatLng?.latitude,
      'initialRiderLng': initialRiderLatLng?.longitude,
      'totalAmount': totalAmount,
      'startOtp': startOtp,
      'status': status,
    };
  }

  factory ActiveBookingData.fromJson(Map<String, dynamic> json) {
    return ActiveBookingData(
      bookingId: json['bookingId']?.toString() ?? '',
      driverName: json['driverName']?.toString() ?? 'Marcus Thorne',
      driverRating: (json['driverRating'] is num) ? (json['driverRating'] as num).toDouble() : 4.9,
      vehicleInfo: json['vehicleInfo']?.toString() ?? 'BMW i7 xDrive60 • 7396',
      pickupAddress: json['pickupAddress']?.toString() ?? '',
      dropAddress: json['dropAddress']?.toString() ?? '',
      pickupLatLng: LatLng(
        (json['pickupLat'] is num) ? (json['pickupLat'] as num).toDouble() : 17.4126,
        (json['pickupLng'] is num) ? (json['pickupLng'] as num).toDouble() : 78.3498,
      ),
      dropLatLng: LatLng(
        (json['dropLat'] is num) ? (json['dropLat'] as num).toDouble() : 17.4435,
        (json['dropLng'] is num) ? (json['dropLng'] as num).toDouble() : 78.3772,
      ),
      initialRiderLatLng: (json['initialRiderLat'] != null && json['initialRiderLng'] != null)
          ? LatLng(
              (json['initialRiderLat'] as num).toDouble(),
              (json['initialRiderLng'] as num).toDouble(),
            )
          : null,
      totalAmount: json['totalAmount']?.toString() ?? '₹124.00',
      startOtp: json['startOtp']?.toString(),
      status: json['status']?.toString() ?? 'RIDER_ACCEPTED',
    );
  }

  ActiveBookingData copyWith({
    String? bookingId,
    String? driverName,
    double? driverRating,
    String? vehicleInfo,
    String? pickupAddress,
    String? dropAddress,
    LatLng? pickupLatLng,
    LatLng? dropLatLng,
    LatLng? initialRiderLatLng,
    String? totalAmount,
    String? startOtp,
    String? status,
  }) {
    return ActiveBookingData(
      bookingId: bookingId ?? this.bookingId,
      driverName: driverName ?? this.driverName,
      driverRating: driverRating ?? this.driverRating,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropAddress: dropAddress ?? this.dropAddress,
      pickupLatLng: pickupLatLng ?? this.pickupLatLng,
      dropLatLng: dropLatLng ?? this.dropLatLng,
      initialRiderLatLng: initialRiderLatLng ?? this.initialRiderLatLng,
      totalAmount: totalAmount ?? this.totalAmount,
      startOtp: startOtp ?? this.startOtp,
      status: status ?? this.status,
    );
  }
}

class ActiveBookingService {
  static const String _keyActiveBooking = 'active_booking_data';
  final SharedPreferences _prefs;

  final ValueNotifier<ActiveBookingData?> _activeBookingNotifier =
      ValueNotifier<ActiveBookingData?>(null);

  ActiveBookingService(this._prefs) {
    loadActiveBooking();
  }

  ValueListenable<ActiveBookingData?> get activeBookingNotifier => _activeBookingNotifier;

  ActiveBookingData? get activeBooking => _activeBookingNotifier.value;

  bool get hasActiveBooking => _activeBookingNotifier.value != null;

  void _safeNotify(ActiveBookingData? data) {
    if (WidgetsBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _activeBookingNotifier.value = data;
      });
    } else {
      _activeBookingNotifier.value = data;
    }
  }

  void loadActiveBooking() {
    try {
      final jsonStr = _prefs.getString(_keyActiveBooking);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final map = json.decode(jsonStr) as Map<String, dynamic>;
        _safeNotify(ActiveBookingData.fromJson(map));
      } else {
        _safeNotify(null);
      }
    } catch (e) {
      debugPrint('[ActiveBookingService] Error loading active booking: $e');
      _safeNotify(null);
    }
  }

  Future<void> setActiveBooking(ActiveBookingData booking) async {
    _safeNotify(booking);
    try {
      await _prefs.setString(_keyActiveBooking, json.encode(booking.toJson()));
    } catch (e) {
      debugPrint('[ActiveBookingService] Error saving active booking: $e');
    }
  }

  Future<void> updateBookingStatus(String status) async {
    if (_activeBookingNotifier.value != null) {
      final updated = _activeBookingNotifier.value!.copyWith(status: status);
      await setActiveBooking(updated);
    }
  }

  Future<void> updateStartOtp(String otp) async {
    if (_activeBookingNotifier.value != null) {
      final updated = _activeBookingNotifier.value!.copyWith(startOtp: otp);
      await setActiveBooking(updated);
    }
  }

  Future<void> clearActiveBooking() async {
    _safeNotify(null);
    try {
      await _prefs.remove(_keyActiveBooking);
    } catch (e) {
      debugPrint('[ActiveBookingService] Error clearing active booking: $e');
    }
  }
}

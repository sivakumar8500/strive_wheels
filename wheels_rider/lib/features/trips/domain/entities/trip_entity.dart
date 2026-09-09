import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_entity.freezed.dart';

@freezed
abstract class BookingEntity with _$BookingEntity {
  const factory BookingEntity({
    required String id,
    required String clientName,
    required double clientRating,
    required String tag,
    required double price,
    required String pickupLocation,
    required String dropoffLocation,
    required DateTime timestamp,
    required String status,
  }) = _BookingEntity;
}

@freezed
abstract class TripEntity with _$TripEntity {
  const factory TripEntity({
    required double totalMileage,
    required int totalRides,
    required double avgRating,
    required List<BookingEntity> bookings,
  }) = _TripEntity;
}

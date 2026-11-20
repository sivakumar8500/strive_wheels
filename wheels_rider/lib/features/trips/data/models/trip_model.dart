import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/trip_entity.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

@freezed
abstract class BookingModel with _$BookingModel {
  const BookingModel._();

  const factory BookingModel({
    required String id,
    @JsonKey(name: 'client_name') required String clientName,
    @JsonKey(name: 'client_rating') required double clientRating,
    required String tag,
    required double price,
    @JsonKey(name: 'pickup_location') required String pickupLocation,
    @JsonKey(name: 'dropoff_location') required String dropoffLocation,
    required DateTime timestamp,
    required String status,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);

  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      clientName: clientName,
      clientRating: clientRating,
      tag: tag,
      price: price,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      timestamp: timestamp,
      status: status,
    );
  }
}

@freezed
abstract class TripModel with _$TripModel {
  const TripModel._();

  const factory TripModel({
    @JsonKey(name: 'total_mileage') required double totalMileage,
    @JsonKey(name: 'total_rides') required int totalRides,
    @JsonKey(name: 'avg_rating') required double avgRating,
    required List<BookingModel> bookings,
  }) = _TripModel;

  factory TripModel.fromJson(Map<String, dynamic> json) => _$TripModelFromJson(json);

  TripEntity toEntity() {
    return TripEntity(
      totalMileage: totalMileage,
      totalRides: totalRides,
      avgRating: avgRating,
      bookings: bookings.map((b) => b.toEntity()).toList(),
    );
  }
}

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

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final String idStr = (json['id'] ?? json['booking_id'] ?? '').toString();

    String name = 'Customer';
    if (json['client_name'] != null && json['client_name'].toString().isNotEmpty) {
      name = json['client_name'].toString();
    } else if (json['customer_name'] != null && json['customer_name'].toString().isNotEmpty) {
      name = json['customer_name'].toString();
    } else if (json['customer'] is Map && json['customer']['full_name'] != null) {
      name = json['customer']['full_name'].toString();
    } else if (json['customer'] is Map && json['customer']['name'] != null) {
      name = json['customer']['name'].toString();
    } else if (json['booking_code'] != null && json['booking_code'].toString().isNotEmpty) {
      name = 'Booking #${json['booking_code']}';
    }

    double rating = 4.8;
    if (json['client_rating'] != null) {
      rating = (json['client_rating'] is num) ? (json['client_rating'] as num).toDouble() : (double.tryParse(json['client_rating'].toString()) ?? 4.8);
    } else if (json['customer_rating'] != null) {
      rating = (json['customer_rating'] is num) ? (json['customer_rating'] as num).toDouble() : (double.tryParse(json['customer_rating'].toString()) ?? 4.8);
    }

    String tagStr = 'Self';
    if (json['tag'] != null && json['tag'].toString().isNotEmpty) {
      tagStr = json['tag'].toString();
    } else if (json['service_mode'] != null) {
      tagStr = json['service_mode'].toString().toUpperCase() == 'CORPORATE' ? 'Corporate' : 'Self';
    }

    double priceVal = 0.0;
    if (json['price'] != null) {
      priceVal = (json['price'] is num) ? (json['price'] as num).toDouble() : (double.tryParse(json['price'].toString()) ?? 0.0);
    } else if (json['final_fare'] != null && (json['final_fare'] as num) > 0) {
      priceVal = (json['final_fare'] is num) ? (json['final_fare'] as num).toDouble() : (double.tryParse(json['final_fare'].toString()) ?? 0.0);
    } else if (json['estimated_fare'] != null) {
      priceVal = (json['estimated_fare'] is num) ? (json['estimated_fare'] as num).toDouble() : (double.tryParse(json['estimated_fare'].toString()) ?? 0.0);
    }

    String pickup = json['pickup_location']?.toString() ?? json['pickup_address']?.toString() ?? 'Pickup Location';
    String drop = json['dropoff_location']?.toString() ?? json['drop_address']?.toString() ?? 'Drop Location';

    DateTime time = DateTime.now();
    final timeRaw = json['timestamp'] ?? json['completed_at'] ?? json['started_at'] ?? json['scheduled_at'] ?? json['created_at'];
    if (timeRaw != null) {
      if (timeRaw is DateTime) {
        time = timeRaw;
      } else {
        time = DateTime.tryParse(timeRaw.toString()) ?? DateTime.now();
      }
    }

    String statusVal = (json['status'] ?? 'COMPLETED').toString();

    return BookingModel(
      id: idStr,
      clientName: name,
      clientRating: rating,
      tag: tagStr,
      price: priceVal,
      pickupLocation: pickup,
      dropoffLocation: drop,
      timestamp: time,
      status: statusVal,
    );
  }

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

  factory TripModel.fromJson(Map<String, dynamic> json) {
    double mileage = 0.0;
    if (json['total_mileage'] != null) {
      mileage = (json['total_mileage'] is num) ? (json['total_mileage'] as num).toDouble() : (double.tryParse(json['total_mileage'].toString()) ?? 0.0);
    }

    int totalRides = 0;
    if (json['total_rides'] != null) {
      totalRides = (json['total_rides'] is num) ? (json['total_rides'] as num).toInt() : (int.tryParse(json['total_rides'].toString()) ?? 0);
    }

    double rating = 5.0;
    if (json['avg_rating'] != null) {
      rating = (json['avg_rating'] is num) ? (json['avg_rating'] as num).toDouble() : (double.tryParse(json['avg_rating'].toString()) ?? 5.0);
    }

    List<BookingModel> bookingList = [];
    if (json['bookings'] is List) {
      bookingList = (json['bookings'] as List)
          .map((item) => BookingModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    }

    return TripModel(
      totalMileage: mileage,
      totalRides: totalRides,
      avgRating: rating,
      bookings: bookingList,
    );
  }

  TripEntity toEntity() {
    return TripEntity(
      totalMileage: totalMileage,
      totalRides: totalRides,
      avgRating: avgRating,
      bookings: bookings.map((b) => b.toEntity()).toList(),
    );
  }
}

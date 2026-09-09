// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookingModel _$BookingModelFromJson(Map<String, dynamic> json) =>
    _BookingModel(
      id: json['id'] as String,
      clientName: json['client_name'] as String,
      clientRating: (json['client_rating'] as num).toDouble(),
      tag: json['tag'] as String,
      price: (json['price'] as num).toDouble(),
      pickupLocation: json['pickup_location'] as String,
      dropoffLocation: json['dropoff_location'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$BookingModelToJson(_BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_name': instance.clientName,
      'client_rating': instance.clientRating,
      'tag': instance.tag,
      'price': instance.price,
      'pickup_location': instance.pickupLocation,
      'dropoff_location': instance.dropoffLocation,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': instance.status,
    };

_TripModel _$TripModelFromJson(Map<String, dynamic> json) => _TripModel(
  totalMileage: (json['total_mileage'] as num).toDouble(),
  totalRides: (json['total_rides'] as num).toInt(),
  avgRating: (json['avg_rating'] as num).toDouble(),
  bookings: (json['bookings'] as List<dynamic>)
      .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TripModelToJson(_TripModel instance) =>
    <String, dynamic>{
      'total_mileage': instance.totalMileage,
      'total_rides': instance.totalRides,
      'avg_rating': instance.avgRating,
      'bookings': instance.bookings,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VehicleDetailsModel _$VehicleDetailsModelFromJson(Map<String, dynamic> json) =>
    _VehicleDetailsModel(
      id: json['id'] as String,
      vehicleName: json['vehicleName'] as String,
      operatorName: json['operatorName'] as String,
      isEcoFriendly: json['isEcoFriendly'] as bool,
      isTopRated: json['isTopRated'] as bool,
      capacity: json['capacity'] as String,
      luggage: json['luggage'] as String,
      amenities: json['amenities'] as String,
      climate: json['climate'] as String,
      driverName: json['driverName'] as String,
      driverRating: json['driverRating'] as String,
      driverTrips: json['driverTrips'] as String,
      driverBio: json['driverBio'] as String,
      estimatedDuration: json['estimatedDuration'] as String,
      pickupLocation: json['pickupLocation'] as String,
      dropoffLocation: json['dropoffLocation'] as String,
      price: json['price'] as String,
      imagePath: json['imagePath'] as String,
    );

Map<String, dynamic> _$VehicleDetailsModelToJson(
  _VehicleDetailsModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'vehicleName': instance.vehicleName,
  'operatorName': instance.operatorName,
  'isEcoFriendly': instance.isEcoFriendly,
  'isTopRated': instance.isTopRated,
  'capacity': instance.capacity,
  'luggage': instance.luggage,
  'amenities': instance.amenities,
  'climate': instance.climate,
  'driverName': instance.driverName,
  'driverRating': instance.driverRating,
  'driverTrips': instance.driverTrips,
  'driverBio': instance.driverBio,
  'estimatedDuration': instance.estimatedDuration,
  'pickupLocation': instance.pickupLocation,
  'dropoffLocation': instance.dropoffLocation,
  'price': instance.price,
  'imagePath': instance.imagePath,
};

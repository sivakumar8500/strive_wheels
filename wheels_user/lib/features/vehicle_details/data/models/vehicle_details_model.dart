import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/vehicle_details_entity.dart';

part 'vehicle_details_model.freezed.dart';
part 'vehicle_details_model.g.dart';

@freezed
abstract class VehicleDetailsModel with _$VehicleDetailsModel {
  const factory VehicleDetailsModel({
    required String id,
    required String vehicleName,
    required String operatorName,
    required bool isEcoFriendly,
    required bool isTopRated,
    required String capacity,
    required String luggage,
    required String amenities,
    required String climate,
    required String driverName,
    required String driverRating,
    required String driverTrips,
    required String driverBio,
    required String estimatedDuration,
    required String pickupLocation,
    required String dropoffLocation,
    required String price,
    required String imagePath,
  }) = _VehicleDetailsModel;

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleDetailsModelFromJson(json);
}

extension VehicleDetailsModelX on VehicleDetailsModel {
  VehicleDetailsEntity toEntity() => VehicleDetailsEntity(
        id: id,
        vehicleName: vehicleName,
        operatorName: operatorName,
        isEcoFriendly: isEcoFriendly,
        isTopRated: isTopRated,
        capacity: capacity,
        luggage: luggage,
        amenities: amenities,
        climate: climate,
        driverName: driverName,
        driverRating: driverRating,
        driverTrips: driverTrips,
        driverBio: driverBio,
        estimatedDuration: estimatedDuration,
        pickupLocation: pickupLocation,
        dropoffLocation: dropoffLocation,
        price: price,
        imagePath: imagePath,
      );
}

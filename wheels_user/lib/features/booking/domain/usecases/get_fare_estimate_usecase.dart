import '../entities/fare_estimate_entity.dart';
import '../repositories/booking_repository.dart';

class GetFareEstimateUseCase {
  final BookingRepository repository;

  GetFareEstimateUseCase(this.repository);

  Future<FareEstimateEntity> call({
    required int vehicleTypeId,
    required double pickupLat,
    required double pickupLng,
    required double dropLat,
    required double dropLng,
    double distanceKm = 0.0,
    int durationMins = 0,
    String serviceMode = 'NORMAL',
    String bookingMode = 'INSTANT',
    String tripType = 'ONE_WAY',
    String couponCode = 'string',
    bool isAc = true,
    bool isOutstation = false,
    int vehicleAgeYears = 2,
    String weather = 'CLEAR',
    String trafficLevel = 'LOW',
    int? companyId,
  }) =>
      repository.getFareEstimate(
        vehicleTypeId: vehicleTypeId,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
        distanceKm: distanceKm,
        durationMins: durationMins,
        serviceMode: serviceMode,
        bookingMode: bookingMode,
        tripType: tripType,
        couponCode: couponCode,
        isAc: isAc,
        isOutstation: isOutstation,
        vehicleAgeYears: vehicleAgeYears,
        weather: weather,
        trafficLevel: trafficLevel,
        companyId: companyId,
      );
}

import '../../domain/entities/corporate_aligned_vehicle_entity.dart';
import '../../domain/entities/fare_estimate_entity.dart';
import '../../domain/entities/recent_journey_entity.dart';
import '../../domain/entities/vehicle_option_entity.dart';
import '../../domain/entities/vehicle_type_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_local_datasource.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/recent_journey_model.dart';
import '../models/vehicle_option_model.dart';
import '../models/vehicle_type_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource localDataSource;
  final BookingRemoteDataSource? remoteDataSource;

  BookingRepositoryImpl({
    required this.localDataSource,
    this.remoteDataSource,
  });

  @override
  Future<List<RecentJourneyEntity>> getRecentJourneys() async {
    final models = await localDataSource.getRecentJourneys();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<VehicleOptionEntity>> getAvailableVehicles() async {
    final models = await localDataSource.getAvailableVehicles();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<VehicleTypeEntity>> getVehicleTypes() async {
    if (remoteDataSource != null) {
      try {
        final remoteModels = await remoteDataSource!.getVehicleTypes();
        if (remoteModels.isNotEmpty) {
          return remoteModels.map((m) => m.toEntity()).toList();
        }
      } catch (_) {}
    }
    // Fallback active vehicle types
    return const [
      VehicleTypeEntity(
        id: 1,
        code: 'CAB',
        name: 'Cab (Sedan / Hatchback)',
        description: 'Comfortable AC rides for up to 4 passengers',
        maxPassengers: 4,
        maxWeightKg: 0,
      ),
      VehicleTypeEntity(
        id: 2,
        code: 'AUTO',
        name: 'Auto Rickshaw',
        description: 'Affordable doorstep rides for everyday commute',
        maxPassengers: 3,
        maxWeightKg: 0,
      ),
      VehicleTypeEntity(
        id: 3,
        code: 'BIKE',
        name: 'Bike Taxi',
        description: 'Fastest way to beat traffic solo',
        maxPassengers: 1,
        maxWeightKg: 0,
      ),
      VehicleTypeEntity(
        id: 4,
        code: 'MINI_VAN',
        name: 'Mini Van / Tempo Traveller',
        description: 'Group travel with ample luggage space',
        maxPassengers: 8,
        maxWeightKg: 500,
      ),
    ];
  }

  @override
  Future<List<CorporateAlignedVehicleEntity>> getCorporateAlignedVehicles({
    double? pickupLat,
    double? pickupLng,
    String? dropAddress,
  }) async {
    if (remoteDataSource != null) {
      try {
        final models = await remoteDataSource!.getCorporateAlignedVehicles(
          pickupLat: pickupLat,
          pickupLng: pickupLng,
          dropAddress: dropAddress,
        );
        return models.map((m) => m.toEntity()).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  @override
  Future<FareEstimateEntity> getFareEstimate({
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
  }) async {
    if (remoteDataSource == null) {
      throw Exception('Remote data source not available');
    }
    final model = await remoteDataSource!.getFareEstimate(
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
    return FareEstimateEntity(
      serviceMode: model.serviceMode,
      vehicleTypeId: model.vehicleTypeId,
      estimatedDistanceKm: model.estimatedDistanceKm,
      estimatedDurationMins: model.estimatedDurationMins,
      baseFare: model.baseFare,
      distanceCharge: model.distanceCharge,
      timeCharge: model.timeCharge,
      waitingCharge: model.waitingCharge,
      discountAmount: model.discountAmount,
      surgeMultiplier: model.surgeMultiplier,
      estimatedFare: model.estimatedFare,
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/booking/domain/entities/fare_estimate_entity.dart';
import 'package:wheels_user/features/booking/domain/repositories/booking_repository.dart';
import 'package:wheels_user/features/booking/domain/usecases/get_fare_estimate_usecase.dart';

class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late GetFareEstimateUseCase useCase;
  late MockBookingRepository mockRepository;

  setUp(() {
    mockRepository = MockBookingRepository();
    useCase = GetFareEstimateUseCase(mockRepository);
  });

  const tFareEstimate = FareEstimateEntity(
    serviceMode: 'NORMAL',
    vehicleTypeId: 1,
    estimatedDistanceKm: 12.5,
    estimatedDurationMins: 25,
    baseFare: 50.0,
    distanceCharge: 150.0,
    timeCharge: 50.0,
    waitingCharge: 0.0,
    discountAmount: 0.0,
    surgeMultiplier: 1.0,
    estimatedFare: 250.0,
  );

  test('should return FareEstimateEntity for NORMAL self booking', () async {
    when(() => mockRepository.getFareEstimate(
          vehicleTypeId: any(named: 'vehicleTypeId'),
          pickupLat: any(named: 'pickupLat'),
          pickupLng: any(named: 'pickupLng'),
          dropLat: any(named: 'dropLat'),
          dropLng: any(named: 'dropLng'),
          distanceKm: any(named: 'distanceKm'),
          durationMins: any(named: 'durationMins'),
          serviceMode: 'NORMAL',
          bookingMode: 'INSTANT',
          tripType: 'ONE_WAY',
          couponCode: any(named: 'couponCode'),
          isAc: any(named: 'isAc'),
          isOutstation: any(named: 'isOutstation'),
          vehicleAgeYears: any(named: 'vehicleAgeYears'),
          weather: any(named: 'weather'),
          trafficLevel: any(named: 'trafficLevel'),
          companyId: null,
        )).thenAnswer((_) async => tFareEstimate);

    final result = await useCase(
      vehicleTypeId: 1,
      pickupLat: 17.4,
      pickupLng: 78.4,
      dropLat: 17.5,
      dropLng: 78.5,
      distanceKm: 12.5,
      durationMins: 25,
      serviceMode: 'NORMAL',
      bookingMode: 'INSTANT',
      tripType: 'ONE_WAY',
    );

    expect(result, equals(tFareEstimate));
    verify(() => mockRepository.getFareEstimate(
          vehicleTypeId: 1,
          pickupLat: 17.4,
          pickupLng: 78.4,
          dropLat: 17.5,
          dropLng: 78.5,
          distanceKm: 12.5,
          durationMins: 25,
          serviceMode: 'NORMAL',
          bookingMode: 'INSTANT',
          tripType: 'ONE_WAY',
          couponCode: 'string',
          isAc: true,
          isOutstation: false,
          vehicleAgeYears: 2,
          weather: 'CLEAR',
          trafficLevel: 'LOW',
          companyId: null,
        )).called(1);
  });

  test('should return FareEstimateEntity for CORPORATE booking with companyId', () async {
    const tCorpEstimate = FareEstimateEntity(
      serviceMode: 'CORPORATE',
      vehicleTypeId: 1,
      estimatedDistanceKm: 12.5,
      estimatedDurationMins: 25,
      baseFare: 45.0,
      distanceCharge: 140.0,
      timeCharge: 40.0,
      waitingCharge: 0.0,
      discountAmount: 0.0,
      surgeMultiplier: 1.0,
      estimatedFare: 225.0,
    );

    when(() => mockRepository.getFareEstimate(
          vehicleTypeId: any(named: 'vehicleTypeId'),
          pickupLat: any(named: 'pickupLat'),
          pickupLng: any(named: 'pickupLng'),
          dropLat: any(named: 'dropLat'),
          dropLng: any(named: 'dropLng'),
          distanceKm: any(named: 'distanceKm'),
          durationMins: any(named: 'durationMins'),
          serviceMode: 'CORPORATE',
          bookingMode: 'INSTANT',
          tripType: 'ONE_WAY',
          couponCode: any(named: 'couponCode'),
          isAc: any(named: 'isAc'),
          isOutstation: any(named: 'isOutstation'),
          vehicleAgeYears: any(named: 'vehicleAgeYears'),
          weather: any(named: 'weather'),
          trafficLevel: any(named: 'trafficLevel'),
          companyId: 99,
        )).thenAnswer((_) async => tCorpEstimate);

    final result = await useCase(
      vehicleTypeId: 1,
      pickupLat: 17.4,
      pickupLng: 78.4,
      dropLat: 17.5,
      dropLng: 78.5,
      distanceKm: 12.5,
      durationMins: 25,
      serviceMode: 'CORPORATE',
      bookingMode: 'INSTANT',
      tripType: 'ONE_WAY',
      companyId: 99,
    );

    expect(result, equals(tCorpEstimate));
    expect(result.serviceMode, equals('CORPORATE'));
  });
}

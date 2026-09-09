import '../models/schedule_ride_model.dart';

abstract class ScheduleRideLocalDataSource {
  Future<ScheduleRideModel> getScheduleRideDetails();
}

class ScheduleRideLocalDataSourceImpl implements ScheduleRideLocalDataSource {
  const ScheduleRideLocalDataSourceImpl();

  @override
  Future<ScheduleRideModel> getScheduleRideDetails() async {
    return const ScheduleRideModel(
      pickupPoint: 'Harrods, 87–135 Brompton Rd',
      destination: 'The Ritz London, 150 Piccadilly',
      distanceKm: 18.2,
      durationMins: 42,
      fareAmount: 24.50,
      currencySymbol: '£',
      selectedDate: 'Fri 24',
      selectedTime: '10 : 45',
      isAm: true,
      instantNotification: true,
      checklistItems: [
        'Take number halting (per day 3 free)',
        'Driver beta',
        'Driver alwence',
        'Toll charges',
        'Terms and conditions',
      ],
    );
  }
}

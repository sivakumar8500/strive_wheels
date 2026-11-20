import '../models/driver_search_model.dart';

abstract class DriverSearchLocalDataSource {
  Future<DriverSearchModel> getDriverSearchDetails();
}

class DriverSearchLocalDataSourceImpl implements DriverSearchLocalDataSource {
  const DriverSearchLocalDataSourceImpl();

  @override
  Future<DriverSearchModel> getDriverSearchDetails() async {
    return const DriverSearchModel(
      statusTitle: 'Searching for nearby drivers...',
      statusSubtitle: 'Connecting you to the nearest premium vehicle.',
      estimatedConfirmationText: '5 - 30 mins',
      orderTime: '10:42 AM',
      scanRadiusText: 'Scanning 1.2km radius...',
      activeStepIndex: 1,
    );
  }
}

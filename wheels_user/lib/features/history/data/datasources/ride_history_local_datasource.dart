import '../../../../core/constants/app_strings.dart';
import '../models/past_ride_item_model.dart';
import '../models/ride_history_model.dart';

abstract class RideHistoryLocalDataSource {
  Future<RideHistoryModel> getRideHistoryData();
}

class RideHistoryLocalDataSourceImpl implements RideHistoryLocalDataSource {
  const RideHistoryLocalDataSourceImpl();

  @override
  Future<RideHistoryModel> getRideHistoryData() async {
    return const RideHistoryModel(
      monthlySummaryTitle: AppStrings.juneRideSummary,
      tripCountText: AppStrings.tripsSummaryCount,
      distanceText: AppStrings.kmThisMonth,
      spentText: AppStrings.totalSpentAmount,
      pastRides: [
        PastRideItemModel(
          id: '1',
          title: 'Mindspace IT Park ➔ Home',
          dateAndVehicle: 'Yesterday · 6:42 PM · Bike',
          status: AppStrings.completed,
          amount: '₹185',
          serviceType: 'Bike',
        ),
        PastRideItemModel(
          id: '2',
          title: 'Home ➔ Rajiv Gandhi Airport',
          dateAndVehicle: 'Jun 18 · 5:15 AM · Mini',
          status: AppStrings.completed,
          amount: '₹528',
          serviceType: 'Mini',
        ),
        PastRideItemModel(
          id: '3',
          title: 'Office ➔ Banjara Hills',
          dateAndVehicle: 'Jun 16 · 1:08 PM · Auto',
          status: AppStrings.completed,
          amount: '₹164',
          serviceType: 'Auto',
        ),
        PastRideItemModel(
          id: '4',
          title: 'Gachibowli ➔ Home',
          dateAndVehicle: 'Jun 14 · 8:32 PM · Bike',
          status: AppStrings.completed,
          amount: '₹118',
          serviceType: 'Bike',
        ),
      ],
    );
  }
}

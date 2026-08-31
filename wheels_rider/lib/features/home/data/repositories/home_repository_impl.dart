import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> updateLocation({required double lat, required double lng}) async {
    try {
      await remoteDataSource.updateLocation(lat: lat, lng: lng);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      throw Exception(msg);
    }
  }

  @override
  Future<void> updateAvailability({required String availabilityMode, required bool isOnline}) async {
    try {
      await remoteDataSource.updateAvailability(availabilityMode: availabilityMode, isOnline: isOnline);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      throw Exception(msg);
    }
  }
}

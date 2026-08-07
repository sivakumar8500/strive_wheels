import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/booking/data/datasources/booking_local_datasource.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/get_available_vehicles_usecase.dart';
import '../../features/booking/domain/usecases/get_recent_journeys_usecase.dart';
import '../../features/booking/presentation/bloc/booking_bloc.dart';
import '../../features/contacts/data/datasources/contacts_local_datasource.dart';
import '../../features/contacts/data/repositories/contacts_repository_impl.dart';
import '../../features/contacts/domain/repositories/contacts_repository.dart';
import '../../features/contacts/domain/usecases/request_contacts_permission_usecase.dart';
import '../../features/contacts/presentation/bloc/contacts_bloc.dart';
import '../../features/favourites/data/datasources/favourites_local_datasource.dart';
import '../../features/favourites/data/repositories/favourites_repository_impl.dart';
import '../../features/favourites/domain/repositories/favourites_repository.dart';
import '../../features/favourites/domain/usecases/get_favourites_usecase.dart';
import '../../features/favourites/presentation/bloc/favourites_bloc.dart';
import '../../features/history/data/datasources/ride_history_local_datasource.dart';
import '../../features/history/data/repositories/ride_history_repository_impl.dart';
import '../../features/history/domain/repositories/ride_history_repository.dart';
import '../../features/history/domain/usecases/get_ride_history_usecase.dart';
import '../../features/history/presentation/bloc/ride_history_bloc.dart';
import '../../features/home/data/datasources/home_local_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_dashboard_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/login/data/datasources/login_remote_datasource.dart';
import '../../features/login/data/repositories/login_repository_impl.dart';
import '../../features/login/domain/repositories/login_repository.dart';
import '../../features/login/domain/usecases/send_otp_usecase.dart';
import '../../features/login/presentation/bloc/login_bloc.dart';
import '../../features/notifications/data/datasources/notification_local_datasource.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/domain/usecases/request_notification_permission_usecase.dart';
import '../../features/notifications/presentation/bloc/notification_bloc.dart';
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/check_first_time_usecase.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/otp/data/datasources/otp_remote_datasource.dart';
import '../../features/otp/data/repositories/otp_repository_impl.dart';
import '../../features/otp/domain/repositories/otp_repository.dart';
import '../../features/otp/domain/usecases/resend_otp_usecase.dart';
import '../../features/otp/domain/usecases/verify_otp_usecase.dart';
import '../../features/otp/presentation/bloc/otp_bloc.dart';
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings_usecase.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  // External
  SharedPreferences? sharedPreferences;
  try {
    sharedPreferences = await SharedPreferences.getInstance();
    if (!sl.isRegistered<SharedPreferences>()) {
      sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences!);
    }
  } catch (e) {
    debugPrint('SharedPreferences init error: $e');
  }

  // Data Sources
  if (!sl.isRegistered<OnboardingLocalDataSource>()) {
    sl.registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(
        sharedPreferences: sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : sharedPreferences,
      ),
    );
  }
  if (!sl.isRegistered<LoginRemoteDataSource>()) {
    sl.registerLazySingleton<LoginRemoteDataSource>(
      () => const LoginRemoteDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<OtpRemoteDataSource>()) {
    sl.registerLazySingleton<OtpRemoteDataSource>(
      () => const OtpRemoteDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<NotificationLocalDataSource>()) {
    sl.registerLazySingleton<NotificationLocalDataSource>(
      () => NotificationLocalDataSourceImpl(
        sharedPreferences: sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : sharedPreferences,
      ),
    );
  }
  if (!sl.isRegistered<ContactsLocalDataSource>()) {
    sl.registerLazySingleton<ContactsLocalDataSource>(
      () => ContactsLocalDataSourceImpl(
        sharedPreferences: sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : sharedPreferences,
      ),
    );
  }
  if (!sl.isRegistered<HomeLocalDataSource>()) {
    sl.registerLazySingleton<HomeLocalDataSource>(
      () => const HomeLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<RideHistoryLocalDataSource>()) {
    sl.registerLazySingleton<RideHistoryLocalDataSource>(
      () => const RideHistoryLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<FavouritesLocalDataSource>()) {
    sl.registerLazySingleton<FavouritesLocalDataSource>(
      () => const FavouritesLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<SettingsLocalDataSource>()) {
    sl.registerLazySingleton<SettingsLocalDataSource>(
      () => const SettingsLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<BookingLocalDataSource>()) {
    sl.registerLazySingleton<BookingLocalDataSource>(
      () => const BookingLocalDataSourceImpl(),
    );
  }

  // Repositories
  if (!sl.isRegistered<OnboardingRepository>()) {
    sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<LoginRepository>()) {
    sl.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImpl(remoteDataSource: sl()),
    );
  }
  if (!sl.isRegistered<OtpRepository>()) {
    sl.registerLazySingleton<OtpRepository>(
      () => OtpRepositoryImpl(remoteDataSource: sl()),
    );
  }
  if (!sl.isRegistered<NotificationRepository>()) {
    sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<ContactsRepository>()) {
    sl.registerLazySingleton<ContactsRepository>(
      () => ContactsRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<HomeRepository>()) {
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<RideHistoryRepository>()) {
    sl.registerLazySingleton<RideHistoryRepository>(
      () => RideHistoryRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<FavouritesRepository>()) {
    sl.registerLazySingleton<FavouritesRepository>(
      () => FavouritesRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<SettingsRepository>()) {
    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<BookingRepository>()) {
    sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(localDataSource: sl()),
    );
  }

  // UseCases
  if (!sl.isRegistered<CheckFirstTimeUseCase>()) {
    sl.registerLazySingleton<CheckFirstTimeUseCase>(
      () => CheckFirstTimeUseCase(sl()),
    );
  }

  if (!sl.isRegistered<CompleteOnboardingUseCase>()) {
    sl.registerLazySingleton<CompleteOnboardingUseCase>(
      () => CompleteOnboardingUseCase(sl()),
    );
  }

  if (!sl.isRegistered<SendOtpUseCase>()) {
    sl.registerLazySingleton<SendOtpUseCase>(
      () => SendOtpUseCase(sl()),
    );
  }

  if (!sl.isRegistered<VerifyOtpUseCase>()) {
    sl.registerLazySingleton<VerifyOtpUseCase>(
      () => VerifyOtpUseCase(sl()),
    );
  }

  if (!sl.isRegistered<ResendOtpUseCase>()) {
    sl.registerLazySingleton<ResendOtpUseCase>(
      () => ResendOtpUseCase(sl()),
    );
  }

  if (!sl.isRegistered<RequestNotificationPermissionUseCase>()) {
    sl.registerLazySingleton<RequestNotificationPermissionUseCase>(
      () => RequestNotificationPermissionUseCase(sl()),
    );
  }

  if (!sl.isRegistered<RequestContactsPermissionUseCase>()) {
    sl.registerLazySingleton<RequestContactsPermissionUseCase>(
      () => RequestContactsPermissionUseCase(sl()),
    );
  }

  if (!sl.isRegistered<GetHomeDashboardUseCase>()) {
    sl.registerLazySingleton<GetHomeDashboardUseCase>(
      () => GetHomeDashboardUseCase(sl()),
    );
  }

  if (!sl.isRegistered<GetRideHistoryUseCase>()) {
    sl.registerLazySingleton<GetRideHistoryUseCase>(
      () => GetRideHistoryUseCase(sl()),
    );
  }

  if (!sl.isRegistered<GetFavouritesUseCase>()) {
    sl.registerLazySingleton<GetFavouritesUseCase>(
      () => GetFavouritesUseCase(sl()),
    );
  }

  if (!sl.isRegistered<GetSettingsUseCase>()) {
    sl.registerLazySingleton<GetSettingsUseCase>(
      () => GetSettingsUseCase(sl()),
    );
  }

  if (!sl.isRegistered<GetRecentJourneysUseCase>()) {
    sl.registerLazySingleton<GetRecentJourneysUseCase>(
      () => GetRecentJourneysUseCase(sl()),
    );
  }

  if (!sl.isRegistered<GetAvailableVehiclesUseCase>()) {
    sl.registerLazySingleton<GetAvailableVehiclesUseCase>(
      () => GetAvailableVehiclesUseCase(sl()),
    );
  }

  // BLoCs
  if (!sl.isRegistered<OnboardingBloc>()) {
    sl.registerFactory<OnboardingBloc>(
      () => OnboardingBloc(
        checkFirstTimeUseCase: sl(),
        completeOnboardingUseCase: sl(),
      ),
    );
  }

  if (!sl.isRegistered<SplashBloc>()) {
    sl.registerFactory<SplashBloc>(
      () => SplashBloc(),
    );
  }

  if (!sl.isRegistered<LoginBloc>()) {
    sl.registerFactory<LoginBloc>(
      () => LoginBloc(sendOtpUseCase: sl()),
    );
  }

  if (!sl.isRegistered<OtpBloc>()) {
    sl.registerFactoryParam<OtpBloc, String, dynamic>(
      (fullPhoneNumber, _) => OtpBloc(
        fullPhoneNumber: fullPhoneNumber,
        verifyOtpUseCase: sl(),
        resendOtpUseCase: sl(),
      ),
    );
  }

  if (!sl.isRegistered<NotificationBloc>()) {
    sl.registerFactory<NotificationBloc>(
      () => NotificationBloc(requestPermissionUseCase: sl()),
    );
  }

  if (!sl.isRegistered<ContactsBloc>()) {
    sl.registerFactory<ContactsBloc>(
      () => ContactsBloc(requestPermissionUseCase: sl()),
    );
  }

  if (!sl.isRegistered<HomeBloc>()) {
    sl.registerFactory<HomeBloc>(
      () => HomeBloc(getHomeDashboardUseCase: sl()),
    );
  }

  if (!sl.isRegistered<RideHistoryBloc>()) {
    sl.registerFactory<RideHistoryBloc>(
      () => RideHistoryBloc(getRideHistoryUseCase: sl()),
    );
  }

  if (!sl.isRegistered<FavouritesBloc>()) {
    sl.registerFactory<FavouritesBloc>(
      () => FavouritesBloc(getFavouritesUseCase: sl()),
    );
  }

  if (!sl.isRegistered<SettingsBloc>()) {
    sl.registerFactory<SettingsBloc>(
      () => SettingsBloc(getSettingsUseCase: sl()),
    );
  }

  if (!sl.isRegistered<BookingBloc>()) {
    sl.registerFactory<BookingBloc>(
      () => BookingBloc(
        getRecentJourneysUseCase: sl(),
        getAvailableVehiclesUseCase: sl(),
      ),
    );
  }
}

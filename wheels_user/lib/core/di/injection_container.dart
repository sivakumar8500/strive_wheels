import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../network/api_client.dart';
import '../network/api_constants.dart';
import '../network/auth_interceptor.dart';

import '../../features/booking/data/datasources/booking_local_datasource.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/get_available_vehicles_usecase.dart';
import '../../features/booking/domain/usecases/get_recent_journeys_usecase.dart';
import '../../features/booking/presentation/bloc/booking_bloc.dart';
import '../../features/permissions/data/datasources/permissions_local_datasource.dart';
import '../../features/permissions/data/repositories/permissions_repository_impl.dart';
import '../../features/permissions/domain/repositories/permissions_repository.dart';
import '../../features/permissions/domain/usecases/save_permissions_usecase.dart';
import '../../features/permissions/domain/usecases/get_permissions_usecase.dart';
import '../../features/permissions/presentation/bloc/permissions_bloc.dart';
import '../../features/favourites/data/datasources/favourites_remote_data_source.dart';
import '../../features/favourites/data/repositories/favourites_repository_impl.dart';
import '../../features/favourites/domain/repositories/favourites_repository.dart';
import '../../features/favourites/domain/usecases/add_favorite_usecase.dart';
import '../../features/favourites/domain/usecases/delete_favorite_usecase.dart';
import '../../features/favourites/domain/usecases/get_favourites_usecase.dart';
import '../../features/favourites/domain/usecases/update_favorite_usecase.dart';
import '../../features/favourites/presentation/bloc/favourites_bloc.dart';
import '../../features/history/data/datasources/ride_history_local_datasource.dart';
import '../../features/history/data/datasources/ride_history_remote_data_source.dart';
import '../../features/history/data/repositories/ride_history_repository_impl.dart';
import '../../features/history/domain/repositories/ride_history_repository.dart';
import '../../features/history/domain/usecases/get_ride_history_usecase.dart';
import '../../features/history/presentation/bloc/ride_history_bloc.dart';
import '../../features/home/data/datasources/home_local_datasource.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_dashboard_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/login/data/datasources/login_remote_datasource.dart';
import '../../features/login/data/repositories/login_repository_impl.dart';
import '../../features/login/domain/repositories/login_repository.dart';
import '../../features/login/domain/usecases/send_otp_usecase.dart';
import '../../features/login/presentation/bloc/login_bloc.dart';

import '../theme/data/datasources/theme_local_datasource.dart';
import '../theme/data/repositories/theme_repository_impl.dart';
import '../theme/domain/repositories/theme_repository.dart';
import '../theme/domain/usecases/get_theme_mode_usecase.dart';
import '../theme/domain/usecases/set_theme_mode_usecase.dart';
import '../theme/presentation/bloc/theme_bloc.dart';
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
import '../../features/schedule_ride/data/datasources/schedule_ride_local_datasource.dart';
import '../../features/schedule_ride/data/repositories/schedule_ride_repository_impl.dart';
import '../../features/schedule_ride/domain/repositories/schedule_ride_repository.dart';
import '../../features/schedule_ride/domain/usecases/get_schedule_ride_usecase.dart';
import '../../features/schedule_ride/presentation/bloc/schedule_ride_bloc.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';
import '../../features/trip_overview/data/datasources/trip_overview_local_datasource.dart';
import '../../features/trip_overview/data/repositories/trip_overview_repository_impl.dart';
import '../../features/trip_overview/domain/repositories/trip_overview_repository.dart';
import '../../features/trip_overview/domain/usecases/get_trip_overview_usecase.dart';
import '../../features/trip_overview/presentation/bloc/trip_overview_bloc.dart';
import '../../features/driver_search/data/datasources/driver_search_local_datasource.dart';
import '../../features/driver_search/data/repositories/driver_search_repository_impl.dart';
import '../../features/driver_search/domain/repositories/driver_search_repository.dart';
import '../../features/driver_search/domain/usecases/get_driver_search_usecase.dart';
import '../../features/driver_search/presentation/bloc/driver_search_bloc.dart';
import '../../features/payment_method/data/datasources/payment_method_local_datasource.dart';
import '../../features/payment_method/data/repositories/payment_method_repository_impl.dart';
import '../../features/payment_method/domain/repositories/payment_method_repository.dart';
import '../../features/payment_method/domain/usecases/get_payment_method_usecase.dart';
import '../../features/payment_method/presentation/bloc/payment_method_bloc.dart';
import '../../features/vehicle_details/data/datasources/vehicle_details_local_datasource.dart';
import '../../features/vehicle_details/data/repositories/vehicle_details_repository_impl.dart';
import '../../features/vehicle_details/domain/repositories/vehicle_details_repository.dart';
import '../../features/vehicle_details/domain/usecases/get_vehicle_details_usecase.dart';
import '../../features/vehicle_details/presentation/bloc/vehicle_details_bloc.dart';

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

  // Core Network Setup
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() {
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: ApiConstants.connectTimeout,
          receiveTimeout: ApiConstants.receiveTimeout,
          headers: {
            ApiConstants.contentTypeKey: ApiConstants.applicationJson,
          },
        ),
      );

      // Add interceptors
      dio.interceptors.add(
        AuthInterceptor(
          sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : sharedPreferences!,
        ),
      );
      dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

      return dio;
    });
  }

  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));
  }

  // Data Sources
  if (!sl.isRegistered<ThemeLocalDataSource>()) {
    sl.registerLazySingleton<ThemeLocalDataSource>(
      () => ThemeLocalDataSourceImpl(
        sharedPreferences: sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : sharedPreferences,
      ),
    );
  }
  if (!sl.isRegistered<OnboardingLocalDataSource>()) {
    sl.registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(
        sharedPreferences: sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : sharedPreferences,
      ),
    );
  }
  if (!sl.isRegistered<LoginRemoteDataSource>()) {
    sl.registerLazySingleton<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(dio: sl()),
    );
  }
  if (!sl.isRegistered<OtpRemoteDataSource>()) {
    sl.registerLazySingleton<OtpRemoteDataSource>(
      () => OtpRemoteDataSourceImpl(
        dio: sl(),
        sharedPreferences: sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : sharedPreferences!,
      ),
    );
  }
  if (!sl.isRegistered<PermissionsLocalDataSource>()) {
    sl.registerLazySingleton<PermissionsLocalDataSource>(
      () => PermissionsLocalDataSourceImpl(
        sl.isRegistered<SharedPreferences>() ? sl<SharedPreferences>() : sharedPreferences!,
      ),
    );
  }
  if (!sl.isRegistered<HomeLocalDataSource>()) {
    sl.registerLazySingleton<HomeLocalDataSource>(
      () => const HomeLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<HomeRemoteDataSource>()) {
    sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(dio: sl()),
    );
  }
  if (!sl.isRegistered<RideHistoryLocalDataSource>()) {
    sl.registerLazySingleton<RideHistoryLocalDataSource>(
      () => const RideHistoryLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<RideHistoryRemoteDataSource>()) {
    sl.registerLazySingleton<RideHistoryRemoteDataSource>(
      () => RideHistoryRemoteDataSourceImpl(dio: sl()),
    );
  }
  if (!sl.isRegistered<FavouritesRemoteDataSource>()) {
    sl.registerLazySingleton<FavouritesRemoteDataSource>(
      () => FavouritesRemoteDataSourceImpl(dio: sl()),
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
  if (!sl.isRegistered<ThemeRepository>()) {
    sl.registerLazySingleton<ThemeRepository>(
      () => ThemeRepositoryImpl(localDataSource: sl()),
    );
  }
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
  if (!sl.isRegistered<PermissionsRepository>()) {
    sl.registerLazySingleton<PermissionsRepository>(
      () => PermissionsRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<HomeRepository>()) {
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
      ),
    );
  }
  if (!sl.isRegistered<RideHistoryRepository>()) {
    sl.registerLazySingleton<RideHistoryRepository>(
      () => RideHistoryRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
      ),
    );
  }
  if (!sl.isRegistered<FavouritesRepository>()) {
    sl.registerLazySingleton<FavouritesRepository>(
      () => FavouritesRepositoryImpl(remoteDataSource: sl()),
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
  if (!sl.isRegistered<GetThemeModeUseCase>()) {
    sl.registerLazySingleton<GetThemeModeUseCase>(
      () => GetThemeModeUseCase(sl()),
    );
  }
  if (!sl.isRegistered<SetThemeModeUseCase>()) {
    sl.registerLazySingleton<SetThemeModeUseCase>(
      () => SetThemeModeUseCase(sl()),
    );
  }
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
  if (!sl.isRegistered<LoginWithPhoneUseCase>()) {
    sl.registerLazySingleton<LoginWithPhoneUseCase>(
      () => LoginWithPhoneUseCase(sl()),
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

  if (!sl.isRegistered<SavePermissionsUseCase>()) {
    sl.registerLazySingleton<SavePermissionsUseCase>(
      () => SavePermissionsUseCase(sl()),
    );
  }

  if (!sl.isRegistered<GetPermissionsUseCase>()) {
    sl.registerLazySingleton<GetPermissionsUseCase>(
      () => GetPermissionsUseCase(sl()),
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

  if (!sl.isRegistered<AddFavoriteUseCase>()) {
    sl.registerLazySingleton<AddFavoriteUseCase>(
      () => AddFavoriteUseCase(sl()),
    );
  }

  if (!sl.isRegistered<UpdateFavoriteUseCase>()) {
    sl.registerLazySingleton<UpdateFavoriteUseCase>(
      () => UpdateFavoriteUseCase(sl()),
    );
  }

  if (!sl.isRegistered<DeleteFavoriteUseCase>()) {
    sl.registerLazySingleton<DeleteFavoriteUseCase>(
      () => DeleteFavoriteUseCase(sl()),
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
  if (!sl.isRegistered<ThemeBloc>()) {
    sl.registerFactory<ThemeBloc>(
      () => ThemeBloc(
        getThemeModeUseCase: sl(),
        setThemeModeUseCase: sl(),
      ),
    );
  }
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
      () => SplashBloc(sl()),
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

  if (!sl.isRegistered<PermissionsBloc>()) {
    sl.registerFactory<PermissionsBloc>(
      () => PermissionsBloc(
        getPermissionsUseCase: sl(),
        savePermissionsUseCase: sl(),
      ),
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
      () => FavouritesBloc(
        getFavouritesUseCase: sl(),
        addFavoriteUseCase: sl(),
        updateFavoriteUseCase: sl(),
        deleteFavoriteUseCase: sl(),
      ),
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

  // Vehicle Details Feature
  if (!sl.isRegistered<VehicleDetailsLocalDataSource>()) {
    sl.registerLazySingleton<VehicleDetailsLocalDataSource>(
      () => const VehicleDetailsLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<VehicleDetailsRepository>()) {
    sl.registerLazySingleton<VehicleDetailsRepository>(
      () => VehicleDetailsRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<GetVehicleDetailsUseCase>()) {
    sl.registerLazySingleton<GetVehicleDetailsUseCase>(
      () => GetVehicleDetailsUseCase(sl()),
    );
  }
  if (!sl.isRegistered<VehicleDetailsBloc>()) {
    sl.registerFactory<VehicleDetailsBloc>(
      () => VehicleDetailsBloc(getVehicleDetailsUseCase: sl()),
    );
  }

  // Schedule Ride Feature
  if (!sl.isRegistered<ScheduleRideLocalDataSource>()) {
    sl.registerLazySingleton<ScheduleRideLocalDataSource>(
      () => const ScheduleRideLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<ScheduleRideRepository>()) {
    sl.registerLazySingleton<ScheduleRideRepository>(
      () => ScheduleRideRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<GetScheduleRideUseCase>()) {
    sl.registerLazySingleton<GetScheduleRideUseCase>(
      () => GetScheduleRideUseCase(sl()),
    );
  }
  if (!sl.isRegistered<ScheduleRideBloc>()) {
    sl.registerFactory<ScheduleRideBloc>(
      () => ScheduleRideBloc(getScheduleRideUseCase: sl()),
    );
  }

  // Trip Overview Feature
  if (!sl.isRegistered<TripOverviewLocalDataSource>()) {
    sl.registerLazySingleton<TripOverviewLocalDataSource>(
      () => const TripOverviewLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<TripOverviewRepository>()) {
    sl.registerLazySingleton<TripOverviewRepository>(
      () => TripOverviewRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<GetTripOverviewUseCase>()) {
    sl.registerLazySingleton<GetTripOverviewUseCase>(
      () => GetTripOverviewUseCase(sl()),
    );
  }
  if (!sl.isRegistered<TripOverviewBloc>()) {
    sl.registerFactory<TripOverviewBloc>(
      () => TripOverviewBloc(getTripOverviewUseCase: sl()),
    );
  }

  // Driver Search Feature
  if (!sl.isRegistered<DriverSearchLocalDataSource>()) {
    sl.registerLazySingleton<DriverSearchLocalDataSource>(
      () => const DriverSearchLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<DriverSearchRepository>()) {
    sl.registerLazySingleton<DriverSearchRepository>(
      () => DriverSearchRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<GetDriverSearchUseCase>()) {
    sl.registerLazySingleton<GetDriverSearchUseCase>(
      () => GetDriverSearchUseCase(sl()),
    );
  }
  if (!sl.isRegistered<DriverSearchBloc>()) {
    sl.registerFactory<DriverSearchBloc>(
      () => DriverSearchBloc(getDriverSearchUseCase: sl()),
    );
  }

  // Payment Method Feature
  if (!sl.isRegistered<PaymentMethodLocalDataSource>()) {
    sl.registerLazySingleton<PaymentMethodLocalDataSource>(
      () => const PaymentMethodLocalDataSourceImpl(),
    );
  }
  if (!sl.isRegistered<PaymentMethodRepository>()) {
    sl.registerLazySingleton<PaymentMethodRepository>(
      () => PaymentMethodRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<GetPaymentMethodUseCase>()) {
    sl.registerLazySingleton<GetPaymentMethodUseCase>(
      () => GetPaymentMethodUseCase(sl()),
    );
  }
  if (!sl.isRegistered<PaymentMethodBloc>()) {
    sl.registerFactory<PaymentMethodBloc>(
      () => PaymentMethodBloc(getPaymentMethodUseCase: sl()),
    );
  }
}

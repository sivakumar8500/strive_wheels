import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
import '../network/websocket_client.dart';
import '../theme/data/datasources/theme_local_datasource.dart';
import '../theme/data/repositories/theme_repository_impl.dart';
import '../theme/domain/repositories/theme_repository.dart';
import '../theme/domain/usecases/get_theme_mode_usecase.dart';
import '../theme/domain/usecases/set_theme_mode_usecase.dart';
import '../theme/presentation/bloc/theme_bloc.dart';
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_items.dart';
import '../../features/onboarding/domain/usecases/check_first_time_usecase.dart';
import '../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/splash/data/datasources/splash_local_datasource.dart';
import '../../features/splash/data/repositories/splash_repository_impl.dart';
import '../../features/splash/domain/repositories/splash_repository.dart';
import '../../features/splash/domain/usecases/check_initial_auth_status.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_with_phone_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../../features/auth/presentation/bloc/otp_bloc.dart';
import '../../features/auth/presentation/bloc/permissions_bloc.dart';
import '../../features/registration/presentation/bloc/registration_bloc.dart';
import '../../features/registration/data/datasources/registration_remote_data_source.dart';
import '../../features/registration/data/repositories/registration_repository_impl.dart';
import '../../features/registration/domain/repositories/registration_repository.dart';
import '../../features/registration/domain/usecases/get_vehicle_types_usecase.dart';
import '../../features/registration/domain/usecases/submit_instant_registration_usecase.dart';
import '../../features/registration/domain/usecases/submit_personal_info_usecase.dart';
import '../../features/registration/domain/usecases/submit_address_usecase.dart';
import '../../features/registration/domain/usecases/submit_kyc_usecase.dart';
import '../../features/registration/domain/usecases/submit_vehicle_details_usecase.dart';
import '../../features/registration/domain/usecases/submit_vehicle_docs_usecase.dart';
import '../../features/registration/domain/usecases/submit_bank_details_usecase.dart';
import '../../features/registration/domain/usecases/submit_emergency_contact_usecase.dart';
import '../../features/registration/domain/usecases/upload_file_usecase.dart';

import '../../features/home/data/datasources/booking_websocket_data_source.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/booking_repository_impl.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/booking_repository.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/booking_usecases.dart';
import '../../features/home/domain/usecases/update_availability_usecase.dart';
import '../../features/home/domain/usecases/update_location_usecase.dart';
import '../../features/home/presentation/bloc/booking_bloc.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/trips/data/datasources/rider_remote_data_source.dart';
import '../../features/trips/data/datasources/trips_remote_data_source.dart';
import '../../features/trips/data/repositories/rider_repository_impl.dart';
import '../../features/trips/data/repositories/trips_repository_impl.dart';
import '../../features/trips/domain/repositories/rider_repository.dart';
import '../../features/trips/domain/repositories/trips_repository.dart';
import '../../features/trips/domain/usecases/get_trips_usecase.dart';
import '../../features/trips/presentation/bloc/rider_trip_bloc.dart';
import '../../features/trips/presentation/bloc/trips_bloc.dart';
import '../../features/earnings/data/datasources/earnings_remote_data_source.dart';
import '../../features/earnings/data/repositories/earnings_repository_impl.dart';
import '../../features/earnings/domain/repositories/earnings_repository.dart';
import '../../features/earnings/domain/usecases/get_earnings_usecase.dart';
import '../../features/earnings/presentation/bloc/earnings_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  }
  
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() => Dio());
  }

  if (!sl.isRegistered<WebSocketClient>()) {
    sl.registerLazySingleton<WebSocketClient>(() => WebSocketClient());
  }

  // Network
  if (!sl.isRegistered<ApiClient>()) {
    sl.registerLazySingleton<ApiClient>(() => ApiClient(
      dio: sl(),
      sharedPreferences: sl(),
    ));
  }

  // Data sources
  if (!sl.isRegistered<ThemeLocalDataSource>()) {
    sl.registerLazySingleton<ThemeLocalDataSource>(
      () => ThemeLocalDataSourceImpl(sharedPreferences: sl()),
    );
  }
  if (!sl.isRegistered<SplashLocalDataSource>()) {
    sl.registerLazySingleton<SplashLocalDataSource>(
      () => SplashLocalDataSourceImpl(sharedPreferences: sl()),
    );
  }
  if (!sl.isRegistered<OnboardingLocalDataSource>()) {
    sl.registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(sharedPreferences: sl()),
    );
  }
  if (!sl.isRegistered<AuthLocalDataSource>()) {
    sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
    );
  }
  if (!sl.isRegistered<AuthRemoteDataSource>()) {
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiClient: sl()),
    );
  }
  if (!sl.isRegistered<BookingWebSocketDataSource>()) {
    sl.registerLazySingleton<BookingWebSocketDataSource>(
      () => BookingWebSocketDataSourceImpl(webSocketClient: sl()),
    );
  }
  if (!sl.isRegistered<HomeRemoteDataSource>()) {
    sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(apiClient: sl()),
    );
  }
  if (!sl.isRegistered<ProfileRemoteDataSource>()) {
    sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<TripsRemoteDataSource>()) {
    sl.registerLazySingleton<TripsRemoteDataSource>(
      () => TripsRemoteDataSourceImpl(sl()),
    );
  }
  if (!sl.isRegistered<RiderRemoteDataSource>()) {
    sl.registerLazySingleton<RiderRemoteDataSource>(
      () => RiderRemoteDataSourceImpl(apiClient: sl()),
    );
  }
  if (!sl.isRegistered<EarningsRemoteDataSource>()) {
    sl.registerLazySingleton<EarningsRemoteDataSource>(
      () => EarningsRemoteDataSourceImpl(sl()),
    );
  }

  // Repositories
  if (!sl.isRegistered<ThemeRepository>()) {
    sl.registerLazySingleton<ThemeRepository>(
      () => ThemeRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<SplashRepository>()) {
    sl.registerLazySingleton<SplashRepository>(
      () => SplashRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<OnboardingRepository>()) {
    sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(localDataSource: sl()),
    );
  }
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
    );
  }
  if (!sl.isRegistered<BookingRepository>()) {
    sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(webSocketDataSource: sl()),
    );
  }
  if (!sl.isRegistered<HomeRepository>()) {
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl()),
    );
  }
  if (!sl.isRegistered<ProfileRepository>()) {
    sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<TripsRepository>()) {
    sl.registerLazySingleton<TripsRepository>(
      () => TripsRepositoryImpl(sl()),
    );
  }
  if (!sl.isRegistered<RiderRepository>()) {
    sl.registerLazySingleton<RiderRepository>(
      () => RiderRepositoryImpl(remoteDataSource: sl()),
    );
  }
  if (!sl.isRegistered<EarningsRepository>()) {
    sl.registerLazySingleton<EarningsRepository>(
      () => EarningsRepositoryImpl(sl()),
    );
  }

  // Use cases
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
  if (!sl.isRegistered<CheckInitialAuthStatus>()) {
    sl.registerLazySingleton<CheckInitialAuthStatus>(
      () => CheckInitialAuthStatus(sl()),
    );
  }
  if (!sl.isRegistered<GetOnboardingItems>()) {
    sl.registerLazySingleton<GetOnboardingItems>(
      () => GetOnboardingItems(sl()),
    );
  }
  if (!sl.isRegistered<CompleteOnboarding>()) {
    sl.registerLazySingleton<CompleteOnboarding>(
      () => CompleteOnboarding(sl()),
    );
  }
  if (!sl.isRegistered<CheckFirstTimeUseCase>()) {
    sl.registerLazySingleton<CheckFirstTimeUseCase>(
      () => CheckFirstTimeUseCase(sl()),
    );
  }
  if (!sl.isRegistered<LoginWithPhoneUseCase>()) {
    sl.registerLazySingleton<LoginWithPhoneUseCase>(
      () => LoginWithPhoneUseCase(sl()),
    );
  }
  if (!sl.isRegistered<VerifyOtpUseCase>()) {
    sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));
  }
  if (!sl.isRegistered<UpdateLocationUseCase>()) {
    sl.registerLazySingleton<UpdateLocationUseCase>(
      () => UpdateLocationUseCase(sl()),
    );
  }
  if (!sl.isRegistered<UpdateAvailabilityUseCase>()) {
    sl.registerLazySingleton<UpdateAvailabilityUseCase>(
      () => UpdateAvailabilityUseCase(sl()),
    );
  }
  if (!sl.isRegistered<ConnectToBookingSocketUseCase>()) {
    sl.registerLazySingleton<ConnectToBookingSocketUseCase>(
      () => ConnectToBookingSocketUseCase(sl()),
    );
  }
  if (!sl.isRegistered<DisconnectBookingSocketUseCase>()) {
    sl.registerLazySingleton<DisconnectBookingSocketUseCase>(
      () => DisconnectBookingSocketUseCase(sl()),
    );
  }
  if (!sl.isRegistered<AcceptBookingUseCase>()) {
    sl.registerLazySingleton<AcceptBookingUseCase>(
      () => AcceptBookingUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetRideRequestsStreamUseCase>()) {
    sl.registerLazySingleton<GetRideRequestsStreamUseCase>(
      () => GetRideRequestsStreamUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetBookingSuccessStreamUseCase>()) {
    sl.registerLazySingleton<GetBookingSuccessStreamUseCase>(
      () => GetBookingSuccessStreamUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetBookingErrorStreamUseCase>()) {
    sl.registerLazySingleton<GetBookingErrorStreamUseCase>(
      () => GetBookingErrorStreamUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetProfileUseCase>()) {
    sl.registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(sl()),
    );
  }
  if (!sl.isRegistered<UpdateProfileUseCase>()) {
    sl.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetTripsUseCase>()) {
    sl.registerLazySingleton<GetTripsUseCase>(
      () => GetTripsUseCase(sl()),
    );
  }
  if (!sl.isRegistered<GetEarningsUseCase>()) {
    sl.registerLazySingleton<GetEarningsUseCase>(
      () => GetEarningsUseCase(sl()),
    );
  }

  // Registration dependencies
  if (!sl.isRegistered<RegistrationRemoteDataSource>()) {
    sl.registerLazySingleton<RegistrationRemoteDataSource>(
      () => RegistrationRemoteDataSourceImpl(apiClient: sl()),
    );
  }
  if (!sl.isRegistered<RegistrationRepository>()) {
    sl.registerLazySingleton<RegistrationRepository>(
      () => RegistrationRepositoryImpl(remoteDataSource: sl()),
    );
  }
  if (!sl.isRegistered<SubmitInstantRegistrationUseCase>()) {
    sl.registerLazySingleton<SubmitInstantRegistrationUseCase>(
      () => SubmitInstantRegistrationUseCase(sl()),
    );
  }
  if (!sl.isRegistered<SubmitPersonalInfoUsecase>()) {
    sl.registerLazySingleton<SubmitPersonalInfoUsecase>(
      () => SubmitPersonalInfoUsecase(sl()),
    );
  }

  if (!sl.isRegistered<SubmitAddressUsecase>()) {
    sl.registerLazySingleton<SubmitAddressUsecase>(
      () => SubmitAddressUsecase(sl()),
    );
  }

  if (!sl.isRegistered<SubmitKycUsecase>()) {
    sl.registerLazySingleton<SubmitKycUsecase>(
      () => SubmitKycUsecase(sl()),
    );
  }

  if (!sl.isRegistered<GetVehicleTypesUseCase>()) {
    sl.registerLazySingleton<GetVehicleTypesUseCase>(
      () => GetVehicleTypesUseCase(sl()),
    );
  }

  if (!sl.isRegistered<SubmitVehicleDetailsUsecase>()) {
    sl.registerLazySingleton<SubmitVehicleDetailsUsecase>(
      () => SubmitVehicleDetailsUsecase(sl()),
    );
  }

  if (!sl.isRegistered<SubmitVehicleDocsUsecase>()) {
    sl.registerLazySingleton<SubmitVehicleDocsUsecase>(
      () => SubmitVehicleDocsUsecase(sl()),
    );
  }

  if (!sl.isRegistered<SubmitBankDetailsUsecase>()) {
    sl.registerLazySingleton<SubmitBankDetailsUsecase>(
      () => SubmitBankDetailsUsecase(sl()),
    );
  }

  if (!sl.isRegistered<SubmitEmergencyContactUsecase>()) {
    sl.registerLazySingleton<SubmitEmergencyContactUsecase>(
      () => SubmitEmergencyContactUsecase(sl()),
    );
  }

  if (!sl.isRegistered<UploadFileUseCase>()) {
    sl.registerLazySingleton<UploadFileUseCase>(
      () => UploadFileUseCase(sl()),
    );
  }

  // BLoCs
  if (!sl.isRegistered<ThemeBloc>()) {
    sl.registerFactory<ThemeBloc>(
      () => ThemeBloc(getThemeModeUseCase: sl(), setThemeModeUseCase: sl()),
    );
  }
  if (!sl.isRegistered<SplashBloc>()) {
    sl.registerFactory<SplashBloc>(
      () =>
          SplashBloc(checkInitialAuthStatus: sl(), checkFirstTimeUseCase: sl()),
    );
  }
  if (!sl.isRegistered<OnboardingBloc>()) {
    sl.registerFactory<OnboardingBloc>(
      () => OnboardingBloc(getOnboardingItems: sl(), completeOnboarding: sl()),
    );
  }
  if (!sl.isRegistered<LoginBloc>()) {
    sl.registerFactory<LoginBloc>(() => LoginBloc(loginWithPhoneUseCase: sl()));
  }
  if (!sl.isRegistered<OtpBloc>()) {
    sl.registerFactory<OtpBloc>(
      () => OtpBloc(verifyOtpUseCase: sl(), loginWithPhoneUseCase: sl()),
    );
  }
  if (!sl.isRegistered<PermissionsBloc>()) {
    sl.registerFactory<PermissionsBloc>(() => PermissionsBloc());
  }
  if (!sl.isRegistered<RegistrationBloc>()) {
    sl.registerFactory<RegistrationBloc>(() => RegistrationBloc(
          submitInstantRegistrationUseCase: sl(),
          submitPersonalInfoUsecase: sl(),
          submitAddressUsecase: sl(),
          submitKycUsecase: sl(),
          submitVehicleDetailsUsecase: sl(),
          submitVehicleDocsUsecase: sl(),
          submitBankDetailsUsecase: sl(),
          submitEmergencyContactUsecase: sl(),
          uploadFileUseCase: sl(),
        ));
  }
  if (!sl.isRegistered<HomeBloc>()) {
    sl.registerFactory<HomeBloc>(
      () => HomeBloc(
        updateLocationUseCase: sl(),
        updateAvailabilityUseCase: sl(),
      ),
    );
  }
  if (!sl.isRegistered<BookingBloc>()) {
    sl.registerFactory<BookingBloc>(
      () => BookingBloc(
        connectToBookingSocket: sl(),
        disconnectBookingSocket: sl(),
        acceptBooking: sl(),
        getRideRequestsStream: sl(),
        getBookingSuccessStream: sl(),
        getBookingErrorStream: sl(),
      ),
    );
  }
  if (!sl.isRegistered<ProfileBloc>()) {
    sl.registerFactory<ProfileBloc>(
      () => ProfileBloc(sl(), sl()),
    );
  }
  if (!sl.isRegistered<TripsBloc>()) {
    sl.registerFactory<TripsBloc>(
      () => TripsBloc(getTripsUseCase: sl()),
    );
  }
  if (!sl.isRegistered<RiderTripBloc>()) {
    sl.registerFactory<RiderTripBloc>(
      () => RiderTripBloc(sl()),
    );
  }
  if (!sl.isRegistered<EarningsBloc>()) {
    sl.registerFactory<EarningsBloc>(
      () => EarningsBloc(getEarningsUseCase: sl()),
    );
  }
}


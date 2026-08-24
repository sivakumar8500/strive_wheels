import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';
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
import '../../features/auth/presentation/bloc/registration_bloc.dart';
import '../../features/auth/data/datasources/registration_remote_data_source.dart';
import '../../features/auth/data/repositories/registration_repository_impl.dart';
import '../../features/auth/domain/repositories/registration_repository.dart';
import '../../features/auth/domain/usecases/registration/submit_personal_info_usecase.dart';
import '../../features/auth/domain/usecases/registration/submit_address_usecase.dart';
import '../../features/auth/domain/usecases/registration/upload_file_usecase.dart';
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
          submitPersonalInfoUsecase: sl(),
          submitAddressUsecase: sl(),
          uploadFileUseCase: sl(),
        ));
  }
}

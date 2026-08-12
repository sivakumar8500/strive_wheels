import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_with_phone_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../../features/auth/presentation/bloc/otp_bloc.dart';
import '../../features/auth/presentation/bloc/permissions_bloc.dart';
import '../../features/auth/presentation/bloc/registration_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencyInjection() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
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
      () => AuthRepositoryImpl(localDataSource: sl()),
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
    sl.registerFactory<RegistrationBloc>(() => RegistrationBloc());
  }
}

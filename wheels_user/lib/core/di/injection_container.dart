import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/contacts/data/datasources/contacts_local_datasource.dart';
import '../../features/contacts/data/repositories/contacts_repository_impl.dart';
import '../../features/contacts/domain/repositories/contacts_repository.dart';
import '../../features/contacts/domain/usecases/request_contacts_permission_usecase.dart';
import '../../features/contacts/presentation/bloc/contacts_bloc.dart';
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
}

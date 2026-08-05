import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_strings.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/domain/usecases/check_first_time_usecase.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/pages/onboarding_page.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/splash/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencyInjection();
  final isFirstTime = await sl<CheckFirstTimeUseCase>()();
  runApp(WheelsUserApp(isFirstTime: isFirstTime));
}

class WheelsUserApp extends StatelessWidget {
  final bool isFirstTime;

  const WheelsUserApp({
    super.key,
    required this.isFirstTime,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: isFirstTime
          ? BlocProvider<OnboardingBloc>(
              create: (_) => sl<OnboardingBloc>(),
              child: const OnboardingPage(),
            )
          : BlocProvider<SplashBloc>(
              create: (_) => sl<SplashBloc>(),
              child: const SplashPage(),
            ),
    );
  }
}

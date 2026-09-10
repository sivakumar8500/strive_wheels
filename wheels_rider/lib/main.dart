// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'core/constants/app_strings.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/presentation/bloc/theme_bloc.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/splash/presentation/pages/splash_page.dart';

import 'core/network/session_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = false;
  }
  await initDependencyInjection();
  runApp(const WheelsRiderApp());
}

class WheelsRiderApp extends StatefulWidget {
  const WheelsRiderApp({super.key});

  @override
  State<WheelsRiderApp> createState() => _WheelsRiderAppState();
}

class _WheelsRiderAppState extends State<WheelsRiderApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (sl.isRegistered<SessionManager>()) {
        debugPrint('[WheelsRiderApp] App resumed. Proactively checking access token...');
        sl<SessionManager>().getValidAccessToken();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => sl<ThemeBloc>()..add(const ThemeEvent.loadTheme()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: BlocProvider<SplashBloc>(
              create: (context) => sl<SplashBloc>(),
              child: const SplashPage(),
            ),
          );
        },
      ),
    );
  }
}

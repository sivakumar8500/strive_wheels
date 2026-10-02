import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/constants/app_assets.dart';
import 'package:wheels_user/core/constants/app_colors.dart';
import 'package:wheels_user/features/home/presentation/widgets/moving_car.dart';

void main() {
  Widget buildWidgetUnderTest({
    double height = 50.0,
    double carWidth = 96.0,
    String? assetPath = AppAssets.movingVehicle,
    Duration duration = const Duration(seconds: 5),
    Color? carColor,
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return MaterialApp(
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 100,
          child: MovingCar(
            height: height,
            carWidth: carWidth,
            assetPath: assetPath,
            duration: duration,
            carColor: carColor,
          ),
        ),
      ),
    );
  }

  testWidgets('MovingCar renders default moving vehicle image', (tester) async {
    await tester.pumpWidget(buildWidgetUnderTest());
    await tester.pump();

    expect(find.byType(MovingCar), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('MovingCar renders fallback vector car when assetPath is null', (tester) async {
    await tester.pumpWidget(
      buildWidgetUnderTest(
        assetPath: null,
        carColor: AppColors.primaryBlue,
        themeMode: ThemeMode.dark,
      ),
    );
    await tester.pump();

    expect(find.byType(MovingCar), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('MovingCar renders Image.asset when custom assetPath is provided', (tester) async {
    await tester.pumpWidget(
      buildWidgetUnderTest(
        assetPath: 'assets/images/nav_car_marker.png',
      ),
    );
    await tester.pump();

    expect(find.byType(MovingCar), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}

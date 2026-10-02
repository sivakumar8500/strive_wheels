import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/core/constants/app_assets.dart';
import 'package:wheels_rider/core/constants/app_colors.dart';
import 'package:wheels_rider/features/home/presentation/widgets/moving_car.dart';

void main() {
  Widget buildWidgetUnderTest({
    double height = 28.0,
    double carWidth = 56.0,
    String? assetPath = AppAssets.movingVehicle,
    Duration duration = const Duration(seconds: 4),
    Color? carColor,
    bool repeat = false,
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
            repeat: repeat,
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
        assetPath: 'assets/images/rider_marker.png',
      ),
    );
    await tester.pump();

    expect(find.byType(MovingCar), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/features/settings/presentation/widgets/corporate_details_card.dart';

void main() {
  Widget buildWidget({
    required String companyName,
    String? corporateEmail,
    String? corporateId,
    String? department,
    String? designation,
    String? spendingLimit,
    String? location,
    Brightness brightness = Brightness.light,
    double width = 360,
  }) {
    return MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            child: CorporateDetailsCard(
              companyName: companyName,
              corporateEmail: corporateEmail,
              corporateId: corporateId,
              department: department,
              designation: designation,
              spendingLimit: spendingLimit,
              location: location,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders all corporate details cleanly without overflow on narrow width (320px)', (tester) async {
    await tester.pumpWidget(
      buildWidget(
        width: 320,
        companyName: 'XYZ Global Tech Corp',
        corporateEmail: 'corp@reeyanshsiva.com',
        corporateId: 'EMP-9082',
        department: 'Engineering',
        designation: 'Staff Mobile Architect',
        spendingLimit: '5000.0',
        location: 'Building 5, Mindspace, Hitech City, Hyderabad',
      ),
    );

    // Verify key texts are present
    expect(find.text('Collaborated Company'), findsOneWidget);
    expect(find.text('Verified'), findsOneWidget);
    expect(find.text('XYZ Global Tech Corp'), findsOneWidget);
    expect(find.text('Building 5, Mindspace, Hitech City, Hyderabad'), findsOneWidget);
    expect(find.text('corp@reeyanshsiva.com'), findsOneWidget);
    expect(find.text('EMP-9082'), findsOneWidget);
    expect(find.text('Engineering'), findsOneWidget);
    expect(find.text('Staff Mobile Architect'), findsOneWidget);
    expect(find.text('₹5,000'), findsOneWidget);

    // No overflow exception should be thrown
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders in dark mode without issue', (tester) async {
    await tester.pumpWidget(
      buildWidget(
        brightness: Brightness.dark,
        companyName: 'Strive Logistics Ltd',
        corporateEmail: 'fleet@strive.com',
        spendingLimit: '12500',
      ),
    );

    expect(find.text('Collaborated Company'), findsOneWidget);
    expect(find.text('Strive Logistics Ltd'), findsOneWidget);
    expect(find.text('fleet@strive.com'), findsOneWidget);
    expect(find.text('₹12,500'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

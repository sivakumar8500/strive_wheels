import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_rider/core/widgets/corporate_details_card.dart';

void main() {
  Widget createWidgetUnderTest({
    required String companyName,
    String? corporateApprovalStatus,
    String? corporateRoute,
    String? companyLocation,
    String? companyEmail,
    String? companyPhone,
    Brightness brightness = Brightness.light,
  }) {
    return MaterialApp(
      theme: ThemeData(brightness: brightness),
      home: Scaffold(
        body: CorporateDetailsCard(
          companyName: companyName,
          corporateApprovalStatus: corporateApprovalStatus,
          corporateRoute: corporateRoute,
          companyLocation: companyLocation,
          companyEmail: companyEmail,
          companyPhone: companyPhone,
        ),
      ),
    );
  }

  group('CorporateDetailsCard Widget Tests', () {
    testWidgets('renders approved corporate card with all details in light theme', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          companyName: 'Acme Technologies',
          corporateApprovalStatus: 'APPROVED',
          corporateRoute: 'Hitech City ➔ Financial District',
          companyLocation: 'Madhapur, Hyderabad',
          companyEmail: 'fleet@acme.com',
          companyPhone: '+91 9876543210',
          brightness: Brightness.light,
        ),
      );

      expect(find.text('Acme Technologies'), findsOneWidget);
      expect(find.text('APPROVED'), findsOneWidget);
      expect(find.text('Assigned Route:'), findsOneWidget);
      expect(find.text('Hitech City ➔ Financial District'), findsOneWidget);
      expect(find.text('Company Email:'), findsOneWidget);
      expect(find.text('fleet@acme.com'), findsOneWidget);
      expect(find.text('Company Phone:'), findsOneWidget);
      expect(find.text('+91 9876543210'), findsOneWidget);
      expect(find.text('Company Location:'), findsOneWidget);
      expect(find.text('Madhapur, Hyderabad'), findsNWidgets(2));
      expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
    });

    testWidgets('renders pending corporate card with fallback location in dark theme', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          companyName: 'Global Corp',
          corporateApprovalStatus: 'PENDING',
          brightness: Brightness.dark,
        ),
      );

      expect(find.text('Global Corp'), findsOneWidget);
      expect(find.text('PENDING'), findsOneWidget);
      expect(find.text('Corporate Fleet Partner'), findsOneWidget);
      expect(find.byIcon(Icons.pending_actions_rounded), findsOneWidget);
    });
  });
}

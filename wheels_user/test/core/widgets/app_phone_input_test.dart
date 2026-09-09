import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/widgets/app_phone_input.dart';

void main() {
  testWidgets('AppPhoneInput displays country code and hint text',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    String enteredText = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPhoneInput(
            controller: controller,
            selectedCountryCode: '+91',
            onChanged: (val) => enteredText = val,
          ),
        ),
      ),
    );

    expect(find.text('+91'), findsOneWidget);
    expect(find.text('Enter Mobile Number'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '9876543210');
    expect(enteredText, '9876543210');
  });

  testWidgets('AppPhoneInput displays error text when provided',
      (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPhoneInput(
            controller: controller,
            errorText: 'Invalid phone number',
          ),
        ),
      ),
    );

    expect(find.text('Invalid phone number'), findsOneWidget);
  });
}

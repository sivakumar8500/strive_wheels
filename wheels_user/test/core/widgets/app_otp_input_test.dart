import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/core/widgets/app_otp_input.dart';

void main() {
  testWidgets('AppOtpInput renders 6 digit input boxes',
      (WidgetTester tester) async {
    String enteredOtp = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppOtpInput(
            length: 6,
            onChanged: (val) => enteredOtp = val,
          ),
        ),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(6));

    await tester.enterText(find.byType(TextField).at(0), '7');
    await tester.enterText(find.byType(TextField).at(1), '0');
    expect(enteredOtp, '70');
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheels_user/features/home/presentation/widgets/home_search_bar.dart';

void main() {
  testWidgets('HomeSearchBar renders with initials fallback when profileImageUrl is null', (tester) async {
    bool avatarTapped = false;
    bool notificationTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeSearchBar(
            userName: 'Aditi Rao',
            onAvatarTap: () => avatarTapped = true,
            onNotificationTap: () => notificationTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('AR'), findsOneWidget);

    await tester.tap(find.byKey(const Key('home_search_avatar_button')));
    expect(avatarTapped, isTrue);

    await tester.tap(find.byKey(const Key('home_search_notifications_button')));
    expect(notificationTapped, isTrue);
  });

  testWidgets('HomeSearchBar renders Image.network when profileImageUrl is a url', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeSearchBar(
            userName: 'Nikhil Kumar',
            profileImageUrl: 'https://example.com/nikhil.jpg',
          ),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('HomeSearchBar renders Image.network when profileImageUrl is a relative path', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeSearchBar(
            userName: 'Nikhil Kumar',
            profileImageUrl: '/media/profiles/nikhil.jpg',
          ),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/core/theme/presentation/bloc/theme_bloc.dart';
import 'package:wheels_rider/core/widgets/theme_toggle_button.dart';

class MockThemeBloc extends MockBloc<ThemeEvent, ThemeState>
    implements ThemeBloc {}

void main() {
  late MockThemeBloc mockThemeBloc;

  setUp(() {
    mockThemeBloc = MockThemeBloc();
  });

  Widget createWidgetUnderTest(Widget child) {
    return BlocProvider<ThemeBloc>.value(
      value: mockThemeBloc,
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  group('ThemeToggleButton Widget', () {
    testWidgets('renders dark_mode icon in light theme mode', (tester) async {
      when(
        () => mockThemeBloc.state,
      ).thenReturn(const ThemeState(themeMode: ThemeMode.light));

      await tester.pumpWidget(createWidgetUnderTest(const ThemeToggleButton()));

      expect(find.byKey(const Key('theme_toggle_button')), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
    });

    testWidgets('renders light_mode icon in dark theme mode', (tester) async {
      when(
        () => mockThemeBloc.state,
      ).thenReturn(const ThemeState(themeMode: ThemeMode.dark));

      await tester.pumpWidget(createWidgetUnderTest(const ThemeToggleButton()));

      expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    });

    testWidgets('dispatches toggleTheme event when pressed', (tester) async {
      when(
        () => mockThemeBloc.state,
      ).thenReturn(const ThemeState(themeMode: ThemeMode.light));

      await tester.pumpWidget(createWidgetUnderTest(const ThemeToggleButton()));
      await tester.tap(find.byKey(const Key('theme_toggle_button')));

      verify(() => mockThemeBloc.add(const ThemeEvent.toggleTheme())).called(1);
    });
  });

  group('ThemeSelectionTile Widget', () {
    testWidgets('renders palette icon and opens popup menu', (tester) async {
      when(
        () => mockThemeBloc.state,
      ).thenReturn(const ThemeState(themeMode: ThemeMode.system));

      await tester.pumpWidget(
        createWidgetUnderTest(const ThemeSelectionTile()),
      );

      expect(find.byKey(const Key('theme_selection_tile')), findsOneWidget);
      await tester.tap(find.byKey(const Key('theme_selection_tile')));
      await tester.pumpAndSettle();

      expect(find.text('System Default'), findsOneWidget);
      expect(find.text('Light Mode'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
    });
  });
}

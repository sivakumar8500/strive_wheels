import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/driver_search/domain/entities/driver_search_entity.dart';
import 'package:wheels_user/features/driver_search/presentation/bloc/driver_search_bloc.dart';
import 'package:wheels_user/features/driver_search/presentation/bloc/driver_search_event.dart';
import 'package:wheels_user/features/driver_search/presentation/bloc/driver_search_state.dart';
import 'package:wheels_user/features/driver_search/presentation/pages/driver_search_page.dart';

class MockDriverSearchBloc
    extends MockBloc<DriverSearchEvent, DriverSearchState>
    implements DriverSearchBloc {}

void main() {
  late MockDriverSearchBloc mockBloc;

  const tEntity = DriverSearchEntity(
    statusTitle: 'Searching for nearby drivers...',
    statusSubtitle: 'Connecting you to the nearest premium vehicle.',
    estimatedConfirmationText: '5 - 30 mins',
    orderTime: '10:42 AM',
    scanRadiusText: 'Scanning 1.2km radius...',
    activeStepIndex: 1,
  );

  setUpAll(() {
    registerFallbackValue(const LoadDriverSearchEvent());
    registerFallbackValue(const CancelDriverSearchEvent());
  });

  setUp(() {
    mockBloc = MockDriverSearchBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<DriverSearchBloc>.value(
        value: mockBloc,
        child: const DriverSearchPage(),
      ),
    );
  }

  testWidgets('renders Searching for nearby drivers header, estimated time, and cancel button',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const DriverSearchState(
      isLoading: false,
      driverSearch: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    expect(find.text('Searching for nearby drivers...'), findsOneWidget);
    expect(find.text('ESTIMATED CONFIRMATION'), findsOneWidget);
    expect(find.text('5 - 30 mins'), findsOneWidget);
    expect(find.text('Ride Status'), findsOneWidget);
    expect(find.text('Cancel Request'), findsOneWidget);
  });

  testWidgets('tapping Cancel Request button fires CancelDriverSearchEvent',
      (tester) async {
    when(() => mockBloc.state).thenReturn(const DriverSearchState(
      isLoading: false,
      driverSearch: tEntity,
    ));

    await tester.pumpWidget(buildTestWidget());

    final cancelButton = find.text('Cancel Request');
    await tester.ensureVisible(cancelButton);
    await tester.tap(cancelButton);
    await tester.pump();

    verify(() => mockBloc.add(const CancelDriverSearchEvent())).called(1);
  });
}

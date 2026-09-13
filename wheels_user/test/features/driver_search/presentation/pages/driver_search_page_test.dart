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

import 'package:wheels_user/core/di/injection_container.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_bloc.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_event.dart';
import 'package:wheels_user/features/home/presentation/bloc/home_state.dart';

class MockDriverSearchBloc
    extends MockBloc<DriverSearchEvent, DriverSearchState>
    implements DriverSearchBloc {}

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}

void main() {
  late MockDriverSearchBloc mockBloc;
  late MockHomeBloc mockHomeBloc;

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
    mockHomeBloc = MockHomeBloc();
    when(() => mockHomeBloc.state).thenReturn(const HomeState());
    if (!sl.isRegistered<HomeBloc>()) {
      sl.registerFactory<HomeBloc>(() => mockHomeBloc);
    }
  });

  setUp(() {
    mockBloc = MockDriverSearchBloc();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: BlocProvider<DriverSearchBloc>.value(
        value: mockBloc,
        child: const DriverSearchPage(
          vehicleTypeId: 1,
          pickupLat: 17.4486,
          pickupLng: 78.3908,
          pickupAddress: 'Hitech City, Hyderabad',
          dropLat: 17.4435,
          dropLng: 78.3772,
          dropAddress: 'Gachibowli, Hyderabad',
        ),
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

    expect(find.text('Searching for nearby drivers...'), findsWidgets);
    expect(find.text('ESTIMATED CONFIRMATION'), findsOneWidget);
    expect(find.text('5 - 30 mins'), findsOneWidget);
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
    await tester.pump(const Duration(milliseconds: 300));

    final confirmCancelButton = find.text('Yes, Cancel');
    await tester.tap(confirmCancelButton);
    await tester.pump();

    verify(() => mockBloc.add(const CancelDriverSearchEvent())).called(1);
  });
}

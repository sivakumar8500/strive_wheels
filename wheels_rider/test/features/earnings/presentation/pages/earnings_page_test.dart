import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_rider/features/earnings/domain/entities/earnings_entity.dart';
import 'package:wheels_rider/features/earnings/presentation/bloc/earnings_bloc.dart';
import 'package:wheels_rider/features/earnings/presentation/bloc/earnings_state.dart';
import 'package:wheels_rider/features/earnings/presentation/pages/earnings_page.dart';
import 'package:mocktail/mocktail.dart';

class MockEarningsBloc extends Mock implements EarningsBloc {}

void main() {
  late MockEarningsBloc mockBloc;

  setUp(() {
    mockBloc = MockEarningsBloc();
    when(() => mockBloc.stream).thenAnswer((_) => Stream.empty());
    when(() => mockBloc.state).thenReturn(EarningsInitial());
    when(() => mockBloc.close()).thenAnswer((_) async {});
  });

  final tDate = DateTime(2026, 8, 30);
  final tActivity = EarningsActivityEntity(
    id: '1',
    type: 'TRIP',
    title: 'Trip to Airport',
    subtitle: 'Today',
    amount: 50.0,
    timestamp: tDate,
  );

  final tEarnings = EarningsEntity(
    totalEarnings: 1240.0,
    trips: 42,
    hours: 38.0,
    rating: 4.9,
    recentActivities: [tActivity],
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<EarningsBloc>.value(
        value: mockBloc,
        child: const EarningsView(), // Testing the View directly
      ),
    );
  }

  testWidgets('shows loading indicator when state is EarningsLoading', (tester) async {
    when(() => mockBloc.state).thenReturn(EarningsLoading());
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when state is EarningsError', (tester) async {
    when(() => mockBloc.state).thenReturn(EarningsError('Failed!'));
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Failed!'), findsOneWidget);
  });

  testWidgets('renders earnings data when state is EarningsLoaded', (tester) async {
    when(() => mockBloc.state).thenReturn(EarningsLoaded(tEarnings));
    await tester.pumpWidget(createWidgetUnderTest());
    
    expect(find.text('₹1240'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
    expect(find.text('38.0h'), findsOneWidget);
    expect(find.text('4.9★'), findsOneWidget);
    expect(find.text('Trip to Airport'), findsOneWidget);
  });
}

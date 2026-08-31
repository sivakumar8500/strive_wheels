import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:wheels_rider/features/profile/domain/entities/profile_entity.dart';
import 'package:wheels_rider/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:wheels_rider/features/profile/presentation/bloc/profile_state.dart';
import 'package:wheels_rider/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}

void main() {
  late MockProfileBloc mockProfileBloc;

  setUp(() {
    mockProfileBloc = MockProfileBloc();
    when(() => mockProfileBloc.stream).thenAnswer((_) => Stream.empty());
    when(() => mockProfileBloc.state).thenReturn(ProfileInitial());
    when(() => mockProfileBloc.close()).thenAnswer((_) async {});
  });

  const tProfile = ProfileEntity(
    id: 1,
    name: 'Alex',
    rating: 4.8,
    profileImageUrl: '',
    phone: '123456',
    totalEarnings: 0.0,
    walletBalance: 0.0,
    dob: '1990-01-01',
    gender: 'Male',
    email: 'test@test.com',
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: const EditProfilePage(profile: tProfile),
      ),
    );
  }

  testWidgets('renders EditProfilePage properly', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Phone'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('123456'), findsOneWidget);
    expect(find.text('test@test.com'), findsOneWidget);
  });

  testWidgets('shows loading indicator when state is ProfileUpdateLoading', (tester) async {
    when(() => mockProfileBloc.state).thenReturn(ProfileUpdateLoading());
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays snackbar on ProfileUpdateSuccess', (tester) async {
    whenListen(
      mockProfileBloc,
      Stream.fromIterable([const ProfileUpdateSuccess(tProfile)]),
      initialState: ProfileInitial(),
    );
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // trigger listener
    expect(find.text('Profile updated successfully'), findsOneWidget);
  });
  
  testWidgets('displays snackbar on ProfileUpdateError', (tester) async {
    whenListen(
      mockProfileBloc,
      Stream.fromIterable([const ProfileUpdateError('Error!')]),
      initialState: ProfileInitial(),
    );
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // trigger listener
    expect(find.text('Failed to update: Error!'), findsOneWidget);
  });
}

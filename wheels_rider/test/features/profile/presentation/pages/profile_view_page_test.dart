import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheels_rider/features/profile/domain/entities/profile_entity.dart';
import 'package:wheels_rider/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:wheels_rider/features/profile/presentation/bloc/profile_event.dart';
import 'package:wheels_rider/features/profile/presentation/bloc/profile_state.dart';
import 'package:wheels_rider/features/profile/presentation/pages/profile_view_page.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}

void main() {
  late MockProfileBloc mockProfileBloc;

  setUpAll(() {
    registerFallbackValue(GetProfileEvent());
  });

  setUp(() {
    mockProfileBloc = MockProfileBloc();
    when(() => mockProfileBloc.stream).thenAnswer((_) => Stream.empty());
    when(() => mockProfileBloc.state).thenReturn(ProfileInitial());
    when(() => mockProfileBloc.close()).thenAnswer((_) async {});
  });

  const tProfile = ProfileEntity(
    id: 1,
    name: 'Puja Sri',
    rating: 4.9,
    profileImageUrl: '',
    phone: '+91 9876543210',
    totalEarnings: 15400.0,
    walletBalance: 2350.0,
    dob: '1995-05-15',
    gender: 'FEMALE',
    status: 'ACTIVE',
    email: 'puja.sri@strivewheels.com',
    vehicleMake: 'Toyota',
    vehicleModel: 'Innova Crysta',
    vehicleNumber: 'TS 09 EQ 1234',
    vehicleColor: 'Pearl White',
    vehicleYear: '2023',
    vehicleType: 'SUV',
    fuelType: 'Diesel',
    isCorporate: true,
    companyName: 'Tech Mahindra',
    corporateRoute: 'Hitec City ➔ Gachibowli',
    corporateApprovalStatus: 'APPROVED',
  );

  Widget createWidgetUnderTest({ProfileEntity? initialProfile}) {
    return MaterialApp(
      home: BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: ProfileViewPage(initialProfile: initialProfile),
      ),
    );
  }

  testWidgets('renders ProfileViewPage with all details properly', (tester) async {
    when(() => mockProfileBloc.state).thenReturn(const ProfileLoaded(tProfile));
    await tester.pumpWidget(createWidgetUnderTest(initialProfile: tProfile));

    expect(find.text('Driver Profile'), findsOneWidget);
    expect(find.text('Puja Sri'), findsOneWidget);
    expect(find.text('VERIFIED DRIVER'), findsOneWidget);
    expect(find.text('4.9 ★'), findsOneWidget);
    expect(find.text('₹15400'), findsOneWidget);
    expect(find.text('₹2350'), findsOneWidget);
    expect(find.text('+91 9876543210'), findsOneWidget);
    expect(find.text('puja.sri@strivewheels.com'), findsOneWidget);
    expect(find.text('1995-05-15'), findsOneWidget);
    expect(find.text('FEMALE'), findsOneWidget);
    expect(find.text('Toyota Innova Crysta'), findsOneWidget);
    expect(find.text('TS 09 EQ 1234'), findsOneWidget);
    expect(find.text('Tech Mahindra'), findsOneWidget);
    expect(find.text('Edit Profile Details'), findsOneWidget);
  });

  testWidgets('shows loading indicator when state is ProfileLoading and no initial profile', (tester) async {
    when(() => mockProfileBloc.state).thenReturn(ProfileLoading());
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error state when ProfileError occurs', (tester) async {
    when(() => mockProfileBloc.state).thenReturn(const ProfileError('Network timeout'));
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Failed to load profile'), findsOneWidget);
    expect(find.text('Network timeout'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}

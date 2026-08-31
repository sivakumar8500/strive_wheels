import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_rider/features/profile/domain/entities/profile_entity.dart';
import 'package:wheels_rider/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:wheels_rider/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:wheels_rider/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:wheels_rider/features/profile/presentation/bloc/profile_event.dart';
import 'package:wheels_rider/features/profile/presentation/bloc/profile_state.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

void main() {
  late ProfileBloc bloc;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    bloc = ProfileBloc(mockGetProfileUseCase, mockUpdateProfileUseCase);
  });

  const tProfileEntity = ProfileEntity(id: 1, name: 'Alex', rating: 4.98, profileImageUrl: 'url', totalEarnings: 0.0, walletBalance: 0.0, phone: '1234567890', email: 'test@test.com', dob: '1990-01-01', gender: 'Male');

  test('initial state should be ProfileInitial', () {
    expect(bloc.state, isA<ProfileInitial>());
  });

  blocTest<ProfileBloc, ProfileState>(
    'should emit [ProfileLoading, ProfileLoaded] when get data is successful',
    build: () {
      when(() => mockGetProfileUseCase())
          .thenAnswer((_) async => tProfileEntity);
      return bloc;
    },
    act: (bloc) => bloc.add(GetProfileEvent()),
    expect: () => [
      isA<ProfileLoading>(),
      isA<ProfileLoaded>().having((s) => s.profile, 'profile', tProfileEntity),
    ],
  );

  blocTest<ProfileBloc, ProfileState>(
    'should emit [ProfileUpdateLoading, ProfileUpdateSuccess] when update is successful',
    build: () {
      when(() => mockUpdateProfileUseCase(any()))
          .thenAnswer((_) async => tProfileEntity);
      return bloc;
    },
    act: (bloc) => bloc.add(const UpdateProfileEvent({'name': 'Alex'})),
    expect: () => [
      isA<ProfileUpdateLoading>(),
      isA<ProfileUpdateSuccess>().having((s) => s.profile, 'profile', tProfileEntity),
    ],
  );
}

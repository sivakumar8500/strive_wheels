import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/permissions/domain/entities/permissions_entity.dart';
import 'package:wheels_user/features/permissions/domain/usecases/get_permissions_usecase.dart';
import 'package:wheels_user/features/permissions/domain/usecases/save_permissions_usecase.dart';
import 'package:wheels_user/features/permissions/presentation/bloc/permissions_bloc.dart';
import 'package:wheels_user/features/permissions/presentation/bloc/permissions_event.dart';
import 'package:wheels_user/features/permissions/presentation/bloc/permissions_state.dart';

class MockGetPermissionsUseCase extends Mock implements GetPermissionsUseCase {}
class MockSavePermissionsUseCase extends Mock implements SavePermissionsUseCase {}
class FakePermissionsEntity extends Fake implements PermissionsEntity {}

void main() {
  late PermissionsBloc bloc;
  late MockGetPermissionsUseCase mockGetPermissionsUseCase;
  late MockSavePermissionsUseCase mockSavePermissionsUseCase;

  setUpAll(() {
    registerFallbackValue(FakePermissionsEntity());
  });

  setUp(() {
    mockGetPermissionsUseCase = MockGetPermissionsUseCase();
    mockSavePermissionsUseCase = MockSavePermissionsUseCase();
    bloc = PermissionsBloc(
      getPermissionsUseCase: mockGetPermissionsUseCase,
      savePermissionsUseCase: mockSavePermissionsUseCase,
    );
  });

  const tPermissionsEntity = PermissionsEntity(
    notificationsAllowed: true,
    contactsAllowed: false,
    locationAllowed: true,
  );

  test('initial state should be PermissionsState()', () {
    expect(bloc.state, const PermissionsState());
  });

  blocTest<PermissionsBloc, PermissionsState>(
    'emits correct state on LoadPermissionsEvent success',
    build: () {
      when(() => mockGetPermissionsUseCase())
          .thenAnswer((_) async => tPermissionsEntity);
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadPermissionsEvent()),
    expect: () => [
      const PermissionsState(isLoading: true),
      const PermissionsState(
        isLoading: false,
        notificationsAllowed: true,
        contactsAllowed: false,
        locationAllowed: true,
      ),
    ],
  );



  blocTest<PermissionsBloc, PermissionsState>(
    'emits correct state on SubmitPermissionsEvent success',
    build: () {
      when(() => mockSavePermissionsUseCase(any())).thenAnswer((_) async => true);
      return bloc;
    },
    act: (bloc) => bloc.add(const SubmitPermissionsEvent()),
    expect: () => [
      const PermissionsState(isSubmitting: true),
      const PermissionsState(isSubmitting: false, isSuccess: true),
    ],
  );
}

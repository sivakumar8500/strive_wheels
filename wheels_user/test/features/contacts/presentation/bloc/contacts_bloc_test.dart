import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wheels_user/features/contacts/domain/entities/contacts_permission_entity.dart';
import 'package:wheels_user/features/contacts/domain/usecases/request_contacts_permission_usecase.dart';
import 'package:wheels_user/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:wheels_user/features/contacts/presentation/bloc/contacts_event.dart';
import 'package:wheels_user/features/contacts/presentation/bloc/contacts_state.dart';

class MockRequestContactsPermissionUseCase extends Mock
    implements RequestContactsPermissionUseCase {}

void main() {
  late ContactsBloc contactsBloc;
  late MockRequestContactsPermissionUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockRequestContactsPermissionUseCase();
    contactsBloc = ContactsBloc(requestPermissionUseCase: mockUseCase);
    registerFallbackValue(
      const ContactsPermissionEntity(isEnabled: true),
    );
  });

  tearDown(() {
    contactsBloc.close();
  });

  test('initial state has false for all flags', () {
    expect(contactsBloc.state.isSubmitting, isFalse);
    expect(contactsBloc.state.isPermissionGranted, isFalse);
    expect(contactsBloc.state.isSkipped, isFalse);
  });

  blocTest<ContactsBloc, ContactsState>(
    'emits isSubmitting true and then isPermissionGranted true on AllowContactsEvent',
    build: () {
      when(() => mockUseCase(any())).thenAnswer((_) async => true);
      return contactsBloc;
    },
    act: (bloc) => bloc.add(const AllowContactsEvent()),
    expect: () => [
      const ContactsState(isSubmitting: true),
      const ContactsState(isSubmitting: false, isPermissionGranted: true),
    ],
  );

  blocTest<ContactsBloc, ContactsState>(
    'emits isSubmitting true and then isSkipped true on SkipContactsEvent',
    build: () {
      when(() => mockUseCase(any())).thenAnswer((_) async => true);
      return contactsBloc;
    },
    act: (bloc) => bloc.add(const SkipContactsEvent()),
    expect: () => [
      const ContactsState(isSubmitting: true),
      const ContactsState(isSubmitting: false, isSkipped: true),
    ],
  );

  blocTest<ContactsBloc, ContactsState>(
    'emits errorMessage when allow contacts fails',
    build: () {
      when(() => mockUseCase(any())).thenAnswer((_) async => false);
      return contactsBloc;
    },
    act: (bloc) => bloc.add(const AllowContactsEvent()),
    expect: () => [
      const ContactsState(isSubmitting: true),
      const ContactsState(
        isSubmitting: false,
        errorMessage: 'Failed to update contacts permission settings.',
      ),
    ],
  );
}

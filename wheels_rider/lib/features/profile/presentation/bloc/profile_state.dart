import '../../domain/entities/profile_entity.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}

class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile;

  const ProfileUpdateSuccess(this.profile);
}

class ProfileUpdateError extends ProfileState {
  final String message;

  const ProfileUpdateError(this.message);
}

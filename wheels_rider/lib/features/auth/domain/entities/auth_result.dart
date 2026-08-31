import '../repositories/auth_repository.dart';

/// Domain entity that carries both the authentication status
/// and the current registration step from the API response.
class AuthResult {
  final AuthStatus authStatus;
  final int? currentStep;

  const AuthResult({required this.authStatus, this.currentStep});
}

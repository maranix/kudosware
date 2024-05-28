import 'package:kudosware/core/model/model.dart';

export './firebase_authentication_service.dart';

abstract interface class AuthenticationService {
  /// Signs in with the provided [SigninContract].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<User> login(LogInContract contract);

  /// Creates a new user with the provided [SignupContract].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<User> signup(SignUpContract contract);

  /// Logs out the current user.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logout();
}

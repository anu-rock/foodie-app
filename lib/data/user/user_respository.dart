import 'user.dart';

/// A class that helps with user-related data and actions.
abstract class UserRepository {
  AuthStatus get authStatus;

  /// Returns the currently logged in user,
  /// null if no user is logged in.
  Future<User> getCurrentUser();

  /// Returns the current user when auth status changes.
  ///
  /// On successful login, current user is returned.
  /// On successful logout, null is returned.
  Stream<User> onAuthChanged();

  /// Logs a user in based on email and password based authentication.
  ///
  /// Returned [LoginResult] instance will have `isSuccessful` set as per
  /// the authentication result and message set to indicate the appropriate
  /// success of failure message.
  Future<LoginResult> loginWithEmail(String email, String password);

  /// Logs out the current user.
  Future<void> logout();
}

enum AuthStatus {
  Uninitialized,
  Authenticating,
  Authenticated,
  Unauthenticated,
}

class LoginResult {
  final bool isSuccessful;
  final String message;

  LoginResult({
    this.isSuccessful = false,
    this.message,
  });
}

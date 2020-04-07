import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;

/// Collection of authentication related utility functions.
class AuthUtil {
  /// Returns the currently logged-in user,
  /// or null if no user is signed in.
  static Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }
}

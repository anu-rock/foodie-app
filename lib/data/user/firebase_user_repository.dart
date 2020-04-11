import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'user_respository.dart';
import 'user.dart';

/// A concrete implementation of [UserRepository] based on [FirebaseAuth].
///
/// [FirebaseAuth] package internally takes care of caching data,
/// so a separate implementation of [UserRepository] for caching is not required.
class FirebaseUserRepository implements UserRepository {
  // Getting this from outside makes this class testable
  FirebaseAuth authInstance;
  AuthStatus _status = AuthStatus.Uninitialized;

  FirebaseUserRepository({this.authInstance});

  @override
  AuthStatus get authStatus => this._status;

  @override
  Future<User> getCurrentUser() async {
    var fbUser = await this.authInstance.currentUser();

    if (fbUser != null) {
      return this._fromFirebaseUser(fbUser);
    }

    return null;
  }

  @override
  Future<LoginResult> loginWithEmail(String email, String password) async {
    try {
      this._status = AuthStatus.Authenticating;
      await this
          .authInstance
          .signInWithEmailAndPassword(email: email, password: password);
      this._status = AuthStatus.Authenticated;
      return Future<LoginResult>.value(
        LoginResult(
          isSuccessful: true,
          message: 'Successfully logged in.',
        ),
      );
    } on PlatformException catch (e) {
      this._status = AuthStatus.Unauthenticated;
      return Future<LoginResult>.value(
        LoginResult(
          isSuccessful: false,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<void> logout() async {
    this._status = AuthStatus.Unauthenticated;
    await this.authInstance.signOut();
  }

  @override
  Stream<User> onAuthChanged() {
    return this.authInstance.onAuthStateChanged.map((fbUser) {
      if (fbUser == null) {
        this._status = AuthStatus.Unauthenticated;
        return null;
      }

      this._status = AuthStatus.Authenticated;
      return this._fromFirebaseUser(fbUser);
    });
  }

  User _fromFirebaseUser(FirebaseUser fbUser) {
    if (fbUser == null) return null;

    return User(
      id: fbUser.uid,
      displayName: fbUser.displayName,
      email: fbUser.email,
      phoneNumber: fbUser.phoneNumber,
      photoUrl: fbUser.photoUrl,
      isEmailVerified: fbUser.isEmailVerified,
    );
  }
}

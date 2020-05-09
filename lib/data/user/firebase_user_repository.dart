import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:foodieapp/constants.dart';

import 'user_respository.dart';
import 'user.dart';

/// A concrete implementation of [UserRepository] based on [FirebaseAuth].
///
/// [FirebaseAuth] package internally takes care of caching data,
/// so a separate implementation of [UserRepository] for caching is not required.
class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth _auth;
  final Firestore _store;
  CollectionReference _usersCollection;
  AuthStatus _status = AuthStatus.Uninitialized;

  // Getting this from outside makes this class testable
  FirebaseUserRepository({
    Firestore storeInstance,
    FirebaseAuth authInstance,
  })  : this._store = storeInstance ?? Firestore.instance,
        this._auth = authInstance ?? FirebaseAuth.instance {
    this._usersCollection = _store.collection(kFirestoreUsers);
  }

  @override
  AuthStatus get authStatus => this._status;

  @override
  Future<User> getCurrentUser() async {
    var fbUser = await this._auth.currentUser();

    if (fbUser != null) {
      return await this._fromDatabase(fbUser);
    }

    return null;
  }

  @override
  Future<LoginResult> loginWithEmail(String email, String password) async {
    try {
      this._status = AuthStatus.Authenticating;
      await this._auth.signInWithEmailAndPassword(email: email, password: password);
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
    await this._auth.signOut();
  }

  @override
  Stream<User> onAuthChanged() {
    return this._auth.onAuthStateChanged.asyncMap((fbUser) async {
      if (fbUser == null) {
        this._status = AuthStatus.Unauthenticated;
        return null;
      }

      this._status = AuthStatus.Authenticated;
      final user = await this._fromDatabase(fbUser);
      return user;
    });
  }

  @override
  Future<void> updateProfile({String displayName, String photoUrl}) async {
    final updatedProfile = UserUpdateInfo();
    updatedProfile.displayName = displayName;
    updatedProfile.photoUrl = photoUrl;

    // Update in FirebaseAuth
    final currentUser = await this._auth.currentUser();
    await currentUser.updateProfile(updatedProfile);

    // Update in Firestore
    await this._usersCollection.document(currentUser.uid).updateData({
      'displayName': displayName,
      'photoUrl': photoUrl,
    });
  }

  Future<User> _fromDatabase(FirebaseUser fbUser) async {
    if (fbUser == null) return null;

    final snapshots =
        await this._usersCollection.where('email', isEqualTo: fbUser.email).getDocuments();
    final userDoc = snapshots.documents.first;
    var userData = userDoc.data;
    userData['id'] = userDoc.documentID;

    return User.fromMap(userData);
  }
}

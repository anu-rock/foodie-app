import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/data/user/user.dart';

class AppState extends ChangeNotifier {
  /// Useful to instantly get currentUser,
  /// without the overhead of async methods in
  /// [FirebaseAuth] and [UserRepository] classes.
  User _currentUser;

  /// Getter for currentUser state.
  User get currentUser {
    return this._currentUser;
  }

  /// Updates `currentUser` state to the given user object.
  void setCurrentUser(User user) {
    this._currentUser = user;
  }
}

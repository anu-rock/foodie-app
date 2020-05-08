import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/data/user/user.dart';

class AppState extends ChangeNotifier {
  /// Useful to instantly get currentUser,
  /// without the overhead of async methods in
  /// [FirebaseAuth] and [UserRepository] classes.
  User _currentUser;

  bool _isTabBarVisible = true;

  /// Getter for currentUser state.
  User get currentUser {
    return this._currentUser;
  }

  /// Updates `currentUser` state to the given user object.
  void setCurrentUser(User user) {
    this._currentUser = user;
  }

  /// Getter for isTabBarVisible state.
  bool get isTabBarVisible {
    return this._isTabBarVisible;
  }

  /// Updates `isTabBarVisible` state to false.
  void hideTabBar() {
    this._isTabBarVisible = false;
    this.notifyListeners();
  }

  /// Updates `isTabBarVisible` state to true.
  void showTabBar() {
    this._isTabBarVisible = true;
    this.notifyListeners();
  }
}

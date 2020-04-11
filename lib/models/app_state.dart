import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/data/user/user.dart';
import 'package:foodieapp/tabs/home_tab_navigator.dart';

class AppState extends ChangeNotifier {
  /// It's always useful to know the currently selected tab.
  /// This information may be used inside any screen/widget
  /// to take tab-based decisions.
  String _selectedTab = HomeTabNavigator.id;

  /// Useful to instantly get currentUser,
  /// without the overhead of async methods in
  /// [FirebaseAuth] and [UserRepository] classes.
  User _currentUser;

  /// Getter for selectedTab state.
  String get selectedTab {
    return this._selectedTab;
  }

  /// Getter for currentUser state.
  User get currentUser {
    return this._currentUser;
  }

  /// Marks the given tab (id) as the selected one,
  /// navigates to its route, and triggers state change.
  void setTab(String id) {
    this._selectedTab = id;
    this.notifyListeners();
  }

  /// Updates `currentUser` state to the given user object.
  void setCurrentUser(User user) {
    this._currentUser = user;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/tabs/home_tab_navigator.dart';

class AppState extends ChangeNotifier {
  String _selectedTab = HomeTabNavigator.id;
  FirebaseUser _currentUser;

  /// Getter for selectedTab state.
  String get selectedTab {
    return this._selectedTab;
  }

  /// Getter for currentUser state.
  FirebaseUser get currentUser {
    return this._currentUser;
  }

  /// Marks the given tab (id) as the selected one,
  /// navigates to its route, and triggers state change.
  void setTab(String id) {
    this._selectedTab = id;
    this.notifyListeners();
  }

  /// Updates `currentUser` state to the given user object.
  void setCurrentUser(FirebaseUser user) {
    this._currentUser = user;
  }
}

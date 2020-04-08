import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/models/user.dart';
import 'package:foodieapp/tabs/home_tab_navigator.dart';

class AppState extends ChangeNotifier {
  String _selectedTab = HomeTabNavigator.id;
  User _currentUser = User(
    id: 1,
    firstName: 'Gaurav',
    lastName: 'Gandhi',
  );

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
  void setTab(BuildContext context, String id) {
    this._selectedTab = id;
    this.notifyListeners();
  }

  /// Marks the given tab (id) as the selected one,
  /// and triggers state change.
  void setCurrentUser(BuildContext context, User user) {
    this._currentUser = user;
    this.notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/profile_own/account_screen.dart';
import 'package:foodieapp/screens/profile_own/profile_screen.dart';

class ProfileTabNavigator extends StatelessWidget {
  static const id = 'profile_tab';

  final GlobalKey<NavigatorState> navigatorKey;

  ProfileTabNavigator({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: this.navigatorKey,
      onGenerateRoute: this._buildRoute,
    );
  }

  Route _buildRoute(RouteSettings settings) {
    switch (settings.name) {
      case AccountScreen.id:
        return CupertinoPageRoute(
          builder: (context) => AccountScreen(),
          settings: settings,
        );
      case ProfileScreen.id:
      default:
        return CupertinoPageRoute(
          builder: (context) => ProfileScreen(),
          settings: settings,
        );
    }
  }
}

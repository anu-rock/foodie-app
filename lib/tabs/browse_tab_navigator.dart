import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:foodieapp/screens/discover/discover_screen.dart';

class BrowseTabNavigator extends StatelessWidget {
  static const id = 'browse_tab';

  final GlobalKey<NavigatorState> navigatorKey;

  BrowseTabNavigator({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: this.navigatorKey,
      onGenerateRoute: this._buildRoute,
    );
  }

  Route _buildRoute(RouteSettings settings) {
    switch (settings.name) {
      case DiscoverScreen.id:
      default:
        return CupertinoPageRoute(
          builder: (context) => DiscoverScreen(),
          settings: settings,
        );
    }
  }
}

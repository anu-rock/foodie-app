import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:foodieapp/screens/social_feed/social_feed_screen.dart';

class SocialTabNavigator extends StatelessWidget {
  static const id = 'social_tab';

  final GlobalKey<NavigatorState> navigatorKey;

  SocialTabNavigator({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: this.navigatorKey,
      onGenerateRoute: this._buildRoute,
    );
  }

  Route _buildRoute(RouteSettings settings) {
    switch (settings.name) {
      case SocialFeedScreen.id:
      default:
        return CupertinoPageRoute(
          builder: (context) => SocialFeedScreen(),
          settings: settings,
        );
    }
  }
}

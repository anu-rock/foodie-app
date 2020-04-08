import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/shop/shop_screen.dart';

class ShopTabNavigator extends StatelessWidget {
  static const id = 'shop_tab';

  final GlobalKey<NavigatorState> navigatorKey;

  ShopTabNavigator({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: this.navigatorKey,
      onGenerateRoute: this._buildRoute,
    );
  }

  Route _buildRoute(RouteSettings settings) {
    switch (settings.name) {
      case ShopScreen.id:
      default:
        return CupertinoPageRoute(
          builder: (context) => ShopScreen(),
          settings: settings,
        );
    }
  }
}

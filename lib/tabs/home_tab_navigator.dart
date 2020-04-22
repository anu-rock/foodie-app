import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/home/home_screen.dart';
import 'package:foodieapp/screens/recipe_directions/recipe_directions_screen.dart';
import 'package:foodieapp/screens/recipe_overview/recipe_overview_screen.dart';
import 'package:foodieapp/screens/recipe_search/recipe_search_screen.dart';

class HomeTabNavigator extends StatelessWidget {
  static const id = 'home_tab';

  final GlobalKey<NavigatorState> navigatorKey;

  HomeTabNavigator({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: this.navigatorKey,
      onGenerateRoute: this._buildRoute,
      observers: [
        HeroController(),
      ],
    );
  }

  Route _buildRoute(RouteSettings settings) {
    switch (settings.name) {
      case RecipeSearchScreen.id:
        return CupertinoPageRoute(
          builder: (context) => RecipeSearchScreen(),
          settings: settings,
        );
      case RecipeOverviewScreen.id:
        return CupertinoPageRoute(
          builder: (context) => RecipeOverviewScreen(),
          settings: settings,
        );
      case RecipeDirectionsScreen.id:
        return CupertinoPageRoute(
          builder: (context) => RecipeDirectionsScreen(),
          settings: settings,
        );
      case HomeScreen.id:
      default:
        return CupertinoPageRoute(
          builder: (context) => HomeScreen(),
          settings: settings,
        );
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/recipe_directions/recipe_directions_screen.dart';
import 'package:foodieapp/screens/recipe_overview/recipe_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/screens/home/home_screen.dart';
import 'package:foodieapp/screens/browse/browse_screen.dart';
import 'package:foodieapp/screens/shop/shop_screen.dart';
import 'package:foodieapp/screens/profile/profile_screen.dart';

void main() => runApp(FoodieApp());

class FadeAnimRoute<T> extends MaterialPageRoute<T> {
  FadeAnimRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes
    // (If you don't want any animation, just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}

class FoodieApp extends StatelessWidget {
  final appState = AppState();

  // This widget is the root of our application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => this.appState,
      child: MaterialApp(
        title: 'Foodie App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: HomeScreen.id,
        // Override route animation per screen
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case BrowseScreen.id:
              return FadeAnimRoute(
                builder: (context) => BrowseScreen(),
                settings: settings,
              );
            case ShopScreen.id:
              return FadeAnimRoute(
                builder: (context) => ShopScreen(),
                settings: settings,
              );
            case ProfileScreen.id:
              return FadeAnimRoute(
                builder: (context) => ProfileScreen(),
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
              return FadeAnimRoute(
                builder: (context) => HomeScreen(),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}

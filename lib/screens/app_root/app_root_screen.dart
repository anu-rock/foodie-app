import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodieapp/screens/recipe_search/recipe_search_screen.dart';
import 'package:foodieapp/tabs/browse_tab_navigator.dart';
import 'package:foodieapp/tabs/home_tab_navigator.dart';
import 'package:foodieapp/tabs/profile_tab_navigator.dart';
import 'package:foodieapp/tabs/social_tab_navigator.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';

class AppRootScreen extends StatefulWidget {
  @override
  _AppRootScreenState createState() => _AppRootScreenState();
}

class _AppRootScreenState extends State<AppRootScreen> {
  final navigatorKeys = {
    HomeTabNavigator.id: GlobalKey<NavigatorState>(),
    BrowseTabNavigator.id: GlobalKey<NavigatorState>(),
    SocialTabNavigator.id: GlobalKey<NavigatorState>(),
    ProfileTabNavigator.id: GlobalKey<NavigatorState>(),
  };

  String selectedTab = HomeTabNavigator.id;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return WillPopScope(
      // A fix to handle back button per tabnavigator
      // See "One more thing" section here:
      // https://medium.com/coding-with-flutter/flutter-case-study-multiple-navigators-with-bottomnavigationbar-90eb6caa6dbf
      onWillPop: () async => !await this.navigatorKeys[selectedTab].currentState.maybePop(),
      child: Scaffold(
        bottomNavigationBar: TabsBar(
          selectedTab: this.selectedTab,
          onTabPress: (String tabId) {
            this.setState(() {
              if (tabId == 'recipe_search') {
                this.selectedTab = HomeTabNavigator.id;
                navigatorKeys[HomeTabNavigator.id].currentState.pushNamed(RecipeSearchScreen.id);
              } else {
                this.selectedTab = tabId;
              }
            });
          },
        ),
        body: IndexedStack(
          index: this._getIndexOfTab(this.selectedTab),
          children: <Widget>[
            HomeTabNavigator(
              navigatorKey: navigatorKeys[HomeTabNavigator.id],
            ),
            Visibility(
              visible: this.selectedTab == BrowseTabNavigator.id,
              child: BrowseTabNavigator(
                navigatorKey: navigatorKeys[BrowseTabNavigator.id],
              ),
            ),
            Visibility(
              visible: this.selectedTab == SocialTabNavigator.id,
              child: SocialTabNavigator(
                navigatorKey: navigatorKeys[SocialTabNavigator.id],
              ),
            ),
            ProfileTabNavigator(
              navigatorKey: navigatorKeys[ProfileTabNavigator.id],
            ),
          ],
        ),
      ),
    );
  }

  int _getIndexOfTab(String tabId) {
    switch (tabId) {
      case BrowseTabNavigator.id:
        return 1;
      case SocialTabNavigator.id:
        return 2;
      case ProfileTabNavigator.id:
        return 3;
      case HomeTabNavigator.id:
      default:
        return 0;
    }
  }
}

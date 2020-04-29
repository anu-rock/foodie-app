import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/tabs/browse_tab_navigator.dart';
import 'package:foodieapp/tabs/home_tab_navigator.dart';
import 'package:foodieapp/tabs/profile_tab_navigator.dart';
import 'package:foodieapp/tabs/shop_tab_navigator.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';

class AppRootScreen extends StatefulWidget {
  @override
  _AppRootScreenState createState() => _AppRootScreenState();
}

class _AppRootScreenState extends State<AppRootScreen> {
  final navigatorKeys = {
    HomeTabNavigator.id: GlobalKey<NavigatorState>(),
    BrowseTabNavigator.id: GlobalKey<NavigatorState>(),
    ShopTabNavigator.id: GlobalKey<NavigatorState>(),
    ProfileTabNavigator.id: GlobalKey<NavigatorState>(),
  };

  String selectedTab = HomeTabNavigator.id;

  @override
  Widget build(BuildContext context) {
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
              this.selectedTab = tabId;
            });
          },
        ),
        body: IndexedStack(
          index: this._getIndexOfTab(this.selectedTab),
          children: <Widget>[
            HomeTabNavigator(
              navigatorKey: navigatorKeys[HomeTabNavigator.id],
            ),
            BrowseTabNavigator(
              navigatorKey: navigatorKeys[BrowseTabNavigator.id],
            ),
            ShopTabNavigator(
              navigatorKey: navigatorKeys[ShopTabNavigator.id],
            ),
            ProfileTabNavigator(
              navigatorKey: navigatorKeys[ProfileTabNavigator.id],
            ),
          ],
        ),
      ),
    );
  }

  /// TODO: Fix potential bug:
  /// Maintaining indexes of navigators separately from navigator list
  /// used inside [IndexStack] may introduce issues later when we add/remove
  /// navigators. A more elegant solution would probably use a map.
  int _getIndexOfTab(String tabId) {
    switch (tabId) {
      case BrowseTabNavigator.id:
        return 1;
      case ShopTabNavigator.id:
        return 2;
      case ProfileTabNavigator.id:
        return 3;
      case HomeTabNavigator.id:
      default:
        return 0;
    }
  }
}

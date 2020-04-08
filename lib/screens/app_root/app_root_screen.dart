import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/tabs/browse_tab_navigator.dart';
import 'package:foodieapp/tabs/home_tab_navigator.dart';
import 'package:foodieapp/tabs/profile_tab_navigator.dart';
import 'package:foodieapp/tabs/shop_tab_navigator.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';
import 'package:provider/provider.dart';

class AppRootScreen extends StatelessWidget {
  final navigatorKeys = {
    HomeTabNavigator.id: GlobalKey<NavigatorState>(),
    BrowseTabNavigator.id: GlobalKey<NavigatorState>(),
    ShopTabNavigator.id: GlobalKey<NavigatorState>(),
    ProfileTabNavigator.id: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedTab = appState.selectedTab;

    return WillPopScope(
      // a fix to handle back button per tabnavigator
      onWillPop: () async =>
          !await this.navigatorKeys[selectedTab].currentState.maybePop(),
      child: Scaffold(
        bottomNavigationBar: TabsBar(),
        body: Stack(
          children: <Widget>[
            _buildOffstageNavigator(HomeTabNavigator.id, selectedTab),
            _buildOffstageNavigator(BrowseTabNavigator.id, selectedTab),
            _buildOffstageNavigator(ShopTabNavigator.id, selectedTab),
            _buildOffstageNavigator(ProfileTabNavigator.id, selectedTab),
          ],
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabId, String selectedTab) {
    return Offstage(
      offstage: selectedTab != tabId,
      child: Builder(
        builder: (context) {
          switch (tabId) {
            case BrowseTabNavigator.id:
              return BrowseTabNavigator(
                navigatorKey: this.navigatorKeys[tabId],
              );
            case ShopTabNavigator.id:
              return ShopTabNavigator(
                navigatorKey: this.navigatorKeys[tabId],
              );
            case ProfileTabNavigator.id:
              return ProfileTabNavigator(
                navigatorKey: this.navigatorKeys[tabId],
              );
            case HomeTabNavigator.id:
            default:
              return HomeTabNavigator(
                navigatorKey: this.navigatorKeys[tabId],
              );
          }
        },
      ),
    );
  }
}

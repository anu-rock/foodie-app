import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/tabs/browse_tab_navigator.dart';
import 'package:foodieapp/tabs/home_tab_navigator.dart';
import 'package:foodieapp/tabs/profile_tab_navigator.dart';
import 'package:foodieapp/tabs/shop_tab_navigator.dart';
import 'package:provider/provider.dart';

const TAB_ICON_SIZE = 25.0;

/// A collection of navigation buttons that emulates
/// tabview-like behavior.
///
/// [TabsBar] should be displayed at the very bottom.
/// When using it with [Scaffold], attached it to its
/// [bottomNavigationBar] property.
class TabsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xffefefef),
            width: 1.0,
          ),
        ),
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        overflow: Overflow.visible,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                key: Key('tab_home'),
                icon: Icon(Icons.home),
                color: appState.selectedTab == HomeTabNavigator.id
                    ? kColorBlue
                    : kColorBluegrey,
                iconSize: TAB_ICON_SIZE,
                onPressed: () => appState.setTab(context, HomeTabNavigator.id),
              ),
              IconButton(
                key: Key('tab_browse'),
                icon: Icon(Icons.fastfood),
                color: appState.selectedTab == BrowseTabNavigator.id
                    ? kColorBlue
                    : kColorBluegrey,
                iconSize: TAB_ICON_SIZE,
                onPressed: () =>
                    appState.setTab(context, BrowseTabNavigator.id),
              ),
              Opacity(
                opacity: 0,
                child: IconButton(
                  key: Key('tab_hidden'),
                  icon: Icon(Icons.blur_on),
                  color: Colors.white,
                  iconSize: TAB_ICON_SIZE,
                  onPressed: () {},
                ),
              ),
              IconButton(
                key: Key('tab_shop'),
                icon: Icon(Icons.shopping_cart),
                color: appState.selectedTab == ShopTabNavigator.id
                    ? kColorBlue
                    : kColorBluegrey,
                iconSize: TAB_ICON_SIZE,
                onPressed: () => appState.setTab(context, ShopTabNavigator.id),
              ),
              IconButton(
                key: Key('tab_profile'),
                icon: Icon(Icons.person),
                color: appState.selectedTab == ProfileTabNavigator.id
                    ? kColorBlue
                    : kColorBluegrey,
                iconSize: TAB_ICON_SIZE,
                onPressed: () =>
                    appState.setTab(context, ProfileTabNavigator.id),
              ),
            ],
          ),
          Positioned(
            top: -15.0,
            child: FloatingActionButton(
              key: Key('tab_camera'),
              child: Icon(Icons.blur_on),
              backgroundColor: kColorGreen,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

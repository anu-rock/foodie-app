import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/tabs/browse_tab_navigator.dart';
import 'package:foodieapp/tabs/home_tab_navigator.dart';
import 'package:foodieapp/tabs/profile_tab_navigator.dart';
import 'package:foodieapp/tabs/social_tab_navigator.dart';

const TAB_ICON_SIZE = 25.0;

/// A collection of navigation buttons that emulates
/// tabview-like behavior.
///
/// [TabsBar] should be displayed at the very bottom.
/// When using it with [Scaffold], attached it to its
/// [bottomNavigationBar] property.
class TabsBar extends StatelessWidget {
  final String selectedTab;
  final Function onTabPress;

  TabsBar({
    @required this.selectedTab,
    @required this.onTabPress,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Visibility(
      visible: appState.isTabBarVisible,
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: kColorLightGrey,
              width: 1.0,
            ),
          ),
        ),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          overflow: Overflow.visible,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  key: Key('tab_home'),
                  icon: Icon(Icons.home),
                  color: this.selectedTab == HomeTabNavigator.id ? kColorBlue : kColorBluegrey,
                  iconSize: TAB_ICON_SIZE,
                  onPressed: () => this.onTabPress(HomeTabNavigator.id),
                ),
                IconButton(
                  key: Key('tab_browse'),
                  icon: Icon(Icons.fastfood),
                  color: this.selectedTab == BrowseTabNavigator.id ? kColorBlue : kColorBluegrey,
                  iconSize: TAB_ICON_SIZE,
                  onPressed: () => this.onTabPress(BrowseTabNavigator.id),
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
                  key: Key('tab_social'),
                  icon: Icon(Icons.public),
                  color: this.selectedTab == SocialTabNavigator.id ? kColorBlue : kColorBluegrey,
                  iconSize: TAB_ICON_SIZE,
                  onPressed: () => this.onTabPress(SocialTabNavigator.id),
                ),
                IconButton(
                  key: Key('tab_profile'),
                  icon: Icon(Icons.person),
                  color: this.selectedTab == ProfileTabNavigator.id ? kColorBlue : kColorBluegrey,
                  iconSize: TAB_ICON_SIZE,
                  onPressed: () => this.onTabPress(ProfileTabNavigator.id),
                ),
              ],
            ),
            Positioned(
              top: -15.0,
              child: FloatingActionButton(
                key: Key('tab_search'),
                child: Icon(Icons.blur_on),
                backgroundColor: kColorGreen,
                onPressed: () => this.onTabPress('recipe_search'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        height: 60.0,
        alignment: Alignment.center,
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
                Expanded(
                  child: _tabButton(
                    key: Key('tab_home'),
                    icon: Icons.home,
                    text: 'Home',
                    color: this.selectedTab == HomeTabNavigator.id ? kColorBlue : kColorBluegrey,
                    onPressed: () => this.onTabPress(HomeTabNavigator.id),
                  ),
                ),
                Expanded(
                  child: _tabButton(
                    key: Key('tab_browse'),
                    icon: FontAwesomeIcons.hamburger,
                    text: 'Browse',
                    color: this.selectedTab == BrowseTabNavigator.id ? kColorBlue : kColorBluegrey,
                    onPressed: () => this.onTabPress(BrowseTabNavigator.id),
                  ),
                ),
                Expanded(
                  child: Opacity(
                    opacity: 0,
                    child: _tabButton(
                      key: Key('tab_hidden'),
                      icon: Icons.blur_on,
                      text: 'Hidden',
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ),
                Expanded(
                  child: _tabButton(
                    key: Key('tab_social'),
                    icon: FontAwesomeIcons.solidCommentDots,
                    text: 'Feed',
                    color: this.selectedTab == SocialTabNavigator.id ? kColorBlue : kColorBluegrey,
                    onPressed: () => this.onTabPress(SocialTabNavigator.id),
                  ),
                ),
                Expanded(
                  child: _tabButton(
                    key: Key('tab_profile'),
                    icon: FontAwesomeIcons.solidUserCircle,
                    text: 'Me',
                    color: this.selectedTab == ProfileTabNavigator.id ? kColorBlue : kColorBluegrey,
                    onPressed: () => this.onTabPress(ProfileTabNavigator.id),
                  ),
                ),
              ],
            ),
            Positioned(
              top: -15.0,
              child: FloatingActionButton(
                key: Key('tab_search'),
                child: Icon(FontAwesomeIcons.magic),
                backgroundColor: kColorGreen,
                onPressed: () => this.onTabPress('recipe_search'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FlatButton _tabButton({Key key, Color color, IconData icon, String text, Function onPressed}) {
    return FlatButton(
      key: key,
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: TAB_ICON_SIZE,
            color: color,
          ),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}

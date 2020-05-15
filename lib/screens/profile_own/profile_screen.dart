import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/user/user_respository.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/screens/recipe_list/recipe_list_screen.dart';
import 'package:foodieapp/util/string_util.dart';
import 'account_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const id = 'profile';

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);

    final displayName =
        StringUtil.ifNullOrEmpty(appState.currentUser.displayName, kDefaultUsername);
    final photoUrl = StringUtil.ifNullOrEmpty(
      appState.currentUser.photoUrl,
      'https://api.adorable.io/avatars/200/${appState.currentUser.email}.png',
    );

    return Container(
      padding: EdgeInsets.only(top: kPaddingUnits),
      child: ListView(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: kColorBluegrey,
              backgroundImage: NetworkImage(photoUrl),
              radius: 50.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          _stats(appState, context),
          SizedBox(height: 20.0),
          Divider(height: 1.0),
          ListTile(
            onTap: () => Navigator.pushNamed(context, AccountScreen.id),
            title: Text('Account'),
            trailing: Container(
              width: 200.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    appState.currentUser.email,
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          Divider(height: 1.0),
          ListTile(
            onTap: () {},
            title: Text('Preferences'),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(height: 1.0),
          ListTile(
            onTap: () {},
            title: Text('About Foodie App'),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(height: 1.0),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.center,
            child: FlatButton(
              child: Text('Logout'),
              onPressed: () => userRepo.logout(),
            ),
          )
        ],
      ),
    );
  }

  Row _stats(AppState appState, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _infoTile(
          primaryText: appState.currentUser.favoriteRecipes.toString(),
          secondaryText: 'favorites',
          icon: Icon(Icons.favorite, color: Colors.red),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => RecipeListScreen(
                type: RecipeListType.favorites,
                userId: appState.currentUser.id,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        _infoTile(
          primaryText: appState.currentUser.playedRecipes.toString(),
          secondaryText: 'cooked',
          icon: Icon(Icons.check_circle, color: Colors.green),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => RecipeListScreen(
                type: RecipeListType.cooked,
                userId: appState.currentUser.id,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        _infoTile(
          primaryText: '0',
          secondaryText: 'viewed',
          icon: Icon(Icons.remove_red_eye, color: Colors.yellow.shade800),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => RecipeListScreen(
                type: RecipeListType.viewed,
                userId: appState.currentUser.id,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoTile({String primaryText, String secondaryText, Icon icon, Function onTap}) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100.0,
          padding: kPaddingAll,
          decoration: BoxDecoration(
            border: Border.all(color: kColorLightGrey),
            borderRadius: kContBorderRadiusLg,
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  icon,
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    primaryText,
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ],
              ),
              Text(secondaryText),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/user/user_respository.dart';
import 'package:foodieapp/screens/recipe_list/recipe_list_screen.dart';
import 'package:foodieapp/util/string_util.dart';
import 'package:foodieapp/data/user/user.dart';

import 'connection_list_screen.dart';

class UserProfileScreen extends StatefulWidget {
  static const id = 'user_profile';

  final String userId;
  final bool isCurrentUserFollowing;

  UserProfileScreen({
    @required this.userId,
    this.isCurrentUserFollowing,
  });

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Stream<User> userStream;
  User user;

  @override
  void initState() {
    super.initState();

    _getUserDetails();
  }

  void _getUserDetails() {
    final userRepo = Provider.of<UserRepository>(context, listen: false);
    this.userStream = userRepo.getUser(this.widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: kColorBluegrey,
        ),
      ),
      body: StreamBuilder<User>(
        stream: this.userStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('Loading...'));
          }

          this.user = snapshot.data;
          final displayName = StringUtil.ifNullOrEmpty(this.user.displayName, kDefaultUsername);
          final photoUrl = StringUtil.ifNullOrEmpty(
            this.user.photoUrl,
            'https://api.adorable.io/avatars/200/${this.user.email}.png',
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
                _followButton(),
                SizedBox(height: 10.0),
                _recipeStats(),
                SizedBox(height: 20.0),
                _networkStats(),
              ],
            ),
          );
        },
      ),
    );
  }

  FlatButton _followButton() {
    return FlatButton(
      color: kColorGreen,
      child: Text(
        (this.widget.isCurrentUserFollowing == false || this.widget.isCurrentUserFollowing == null)
            ? 'Follow'
            : 'Unfollow',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
      onPressed: () {},
    );
  }

  Row _recipeStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _infoTile(
          primaryText: this.user.favoriteRecipes.toString(),
          secondaryText: 'favorites',
          icon: Icon(Icons.favorite, color: Colors.red),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => RecipeListScreen(
                type: RecipeListType.favorites,
                userId: this.user.id,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        _infoTile(
          primaryText: this.user.playedRecipes.toString(),
          secondaryText: 'cooked',
          icon: Icon(Icons.check_circle, color: Colors.green),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => RecipeListScreen(
                type: RecipeListType.cooked,
                userId: this.user.id,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _networkStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _infoTile(
          primaryText: this.user.followers.toString(),
          secondaryText: 'followers',
          icon: Icon(Icons.group),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ConnectionListScreen(
                type: ConnectionListType.followers,
                userId: this.user.id,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        _infoTile(
          primaryText: this.user.following.toString(),
          secondaryText: 'following',
          icon: Icon(Icons.group_work),
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ConnectionListScreen(
                type: ConnectionListType.following,
                userId: this.user.id,
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
          width: 120.0,
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

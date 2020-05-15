import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/profile_user/user_profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/network/connection.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/status/status.dart';
import 'package:foodieapp/screens/recipe_overview/recipe_overview_screen.dart';
import 'package:foodieapp/util/string_util.dart';

class StatusCard extends StatelessWidget {
  final Status status;
  final Connection connection;

  StatusCard({
    @required this.status,
    @required this.connection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kPaddingAllSm,
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: kPaddingAllSm,
              child: _statusRow(context),
            ),
            _photo()
          ],
        ),
      ),
    );
  }

  Row _statusRow(BuildContext context) {
    final followeePhoto = StringUtil.ifNullOrEmpty(
      this.connection.followeePhotoUrl,
      'https://api.adorable.io/avatars/100/${connection.followeeName}.png',
    );
    var statusMessage = _createStatusText(context);

    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => UserProfileScreen(
                userId: this.status.userId,
                isCurrentUserFollowing: true,
              ),
            ),
          ),
          child: CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(followeePhoto),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  RichText(
                    softWrap: true,
                    text: statusMessage,
                  ),
                ],
              ),
              Text(
                timeago.format(this.status.createdAt),
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Container _photo() {
    return Container(
      height: 200.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(status.photoUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  TextSpan _createStatusText(BuildContext context) {
    var statusMessage = TextSpan(
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
      children: [
        TextSpan(
          text: '${this.connection.followeeName}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );

    switch (this.status.type) {
      case StatusType.recipe_played:
        statusMessage.children
          ..add(
            TextSpan(text: ' is cooking '),
          )
          ..add(
            TextSpan(
              text: this.status.recipeTitle,
              style: TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => RecipeOverviewScreen(
                          recipe: Recipe(id: this.status.recipeId),
                        ),
                      ),
                    ),
            ),
          );
        break;
      case StatusType.recipe_favorited:
        statusMessage.children
          ..add(
            TextSpan(text: ' favorited '),
          )
          ..add(
            TextSpan(
              text: this.status.recipeTitle,
              style: TextStyle(
                color: Colors.blue,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => RecipeOverviewScreen(
                          recipe: Recipe(id: this.status.recipeId),
                        ),
                      ),
                    ),
            ),
          );
        break;
      case StatusType.custom:
        statusMessage.children.add(
          TextSpan(text: ' ${this.status.message}'),
        );
        break;
    }

    return statusMessage;
  }
}

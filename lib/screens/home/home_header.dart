import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/util/string_util.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final userName = StringUtil.ifNullOrEmpty(appState.currentUser.displayName, kDefaultUsername);

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          height: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/mediterranean-cuisine-2378758_1280.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: <Widget>[
              Container(
                height: 150.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.white,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                    left: kPaddingUnits,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Howdy, $userName',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'What are you going to cook today?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

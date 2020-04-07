import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/screens/home/search_bar.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          height: 150.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/breakfast-1425702_1280.jpg'),
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
                child: Text(
                  'Hi ${appState.currentUser.firstName}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -25.0,
          child: SearchBar(),
        ),
      ],
    );
  }
}

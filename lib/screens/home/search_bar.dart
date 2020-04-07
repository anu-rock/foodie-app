import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: kContElevation,
      shadowColor: kContShadowColor,
      borderRadius: kContBorderRadiusSm,
      child: Container(
        height: 50.0,
        width: 300.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: kContBorderRadiusSm,
        ),
        child: Padding(
          padding: kPaddingHorizontalSm,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(Icons.search),
              ),
              Expanded(
                flex: 5,
                child: TextField(
                  key: Key('search_input'),
                  decoration: InputDecoration(
                    hintText: 'Search for recipes',
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: kContBorderRadiusSm,
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    color: kColorGreen,
                    child: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

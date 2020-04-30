import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

class SearchBar extends StatelessWidget {
  final Function onTextChange;

  SearchBar({this.onTextChange});

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
                child: Icon(
                  Icons.add,
                  color: kColorGreen,
                ),
              ),
              Expanded(
                flex: 5,
                child: TextField(
                  key: Key('search_input'),
                  onChanged: this.onTextChange,
                  decoration: InputDecoration(
                    hintText: 'Find ingredients to add',
                    hintStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    border: InputBorder.none,
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

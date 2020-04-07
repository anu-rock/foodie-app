import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

/// Represents a direction in recipe's direction list.
class RecipeDirection extends StatelessWidget {
  /// Step number (order) of direction in its list.
  final int step;

  /// The direction text.
  final String directionText;

  RecipeDirection({
    @required this.step,
    @required this.directionText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
            color: kColorLightGrey,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Center(
            child: Text(
              this.step.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(this.directionText,
              style: TextStyle(
                color: kColorBluegrey,
              )),
        ),
      ],
    );
  }
}

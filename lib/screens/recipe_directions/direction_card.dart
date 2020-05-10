import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

/// Represents a direction in recipe's direction list.
class DirectionCard extends StatelessWidget {
  /// Step number (order) of direction in its list.
  final int step;

  /// The direction text.
  final String directionText;

  DirectionCard({
    @required this.step,
    @required this.directionText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: kContElevation,
      child: Container(
        alignment: Alignment.center,
        padding: kPaddingAllSm,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _stepNum(),
            SizedBox(width: 10.0),
            Expanded(
              child: _directionText(),
            ),
          ],
        ),
      ),
    );
  }

  Text _directionText() {
    return Text(
      this.directionText,
      style: TextStyle(
        color: kColorBluegrey,
        fontSize: 18.0,
      ),
    );
  }

  Container _stepNum() {
    return Container(
      height: 30.0,
      width: 30.0,
      decoration: BoxDecoration(
        color: Colors.amber,
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
    );
  }
}

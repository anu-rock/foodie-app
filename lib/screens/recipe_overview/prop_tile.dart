import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

/// A container to display a key-value pair in a column layout.
class PropTile extends StatelessWidget {
  final String propName;
  final String propValue;

  PropTile({
    @required this.propName,
    @required this.propValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kPaddingAll,
      margin: kPaddingAllSm / 2,
      decoration: BoxDecoration(
        border: Border.all(
          color: kColorLightGrey,
          width: 1.0,
        ),
        borderRadius: kContBorderRadiusSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            this.propValue,
            style: TextStyle(
              color: kColorGreen,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Text(
            this.propName,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}

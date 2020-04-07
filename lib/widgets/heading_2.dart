import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

/// Styles given text as a second-level heading.
class Heading2 extends StatelessWidget {
  final String text;

  Heading2(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
        fontSize: 20.0,
        color: kColorBluegrey,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

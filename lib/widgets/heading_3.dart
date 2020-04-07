import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

/// Styles given text as a third-level heading.
class Heading3 extends StatelessWidget {
  final String text;

  Heading3(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(
        fontSize: 16.0,
        color: kColorBluegrey,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

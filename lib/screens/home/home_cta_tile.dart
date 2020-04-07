import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

/// The primary call-to-action widget on Home screen.
///
/// Pressing the widget opens device camera view to
/// capture photo of a food item.
class HomeCTATile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: kContElevation,
      shadowColor: kContShadowColor,
      borderRadius: kContBorderRadiusSm,
      child: Container(
        height: 300.0,
        decoration: BoxDecoration(
          borderRadius: kContBorderRadiusSm,
          image: DecorationImage(
            image: AssetImage('images/yummy-pot.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

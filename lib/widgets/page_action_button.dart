import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

/// A full-width (block) button to represent a screen-level action.
///
/// Ideally, there should be only one [PageActionButton] per screen.
class PageActionButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  PageActionButton({
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Material(
        elevation: kContElevation,
        borderRadius: kContBorderRadiusSm,
        child: Container(
          width: double.infinity,
          padding: kPaddingAll,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: kContBorderRadiusSm,
            color: kColorGreen,
          ),
          child: Text(
            this.text.toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

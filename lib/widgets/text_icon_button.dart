import 'package:flutter/material.dart';

/// A button with text and leading and/or trailing icons.
class TextIconButton extends StatelessWidget {
  final String text;
  final Icon leadingIcon;
  final Icon trailingIcon;
  final Function onPressed;

  TextIconButton({
    @required this.text,
    this.leadingIcon,
    this.trailingIcon,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed ?? () {},
      child: Row(
        children: <Widget>[
          this.leadingIcon ?? SizedBox(width: 0, height: 0),
          SizedBox(
            width: 5.0,
          ),
          Text(this.text),
          SizedBox(
            width: 5.0,
          ),
          this.trailingIcon ?? SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }
}

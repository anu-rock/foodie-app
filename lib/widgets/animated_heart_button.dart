import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedHeartButton extends StatefulWidget {
  final Color color;
  final Function onPressed;

  AnimatedHeartButton({@required this.onPressed, this.color});
  @override
  _AnimatedHeartButtonState createState() => new _AnimatedHeartButtonState();
}

class _AnimatedHeartButtonState extends State<AnimatedHeartButton>
    with SingleTickerProviderStateMixin {
  double _size = 30.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.fastOutSlowIn,
      child: new GestureDetector(
        onTap: () {
          this.setState(() => _size = 40.0);
          Timer(Duration(milliseconds: 200), () {
            this.setState(() => _size = 30.0);
          });
          this.widget.onPressed();
        },
        child: Icon(
          Icons.favorite,
          color: this.widget.color,
          size: _size,
        ),
      ),
      vsync: this,
      duration: Duration(milliseconds: 100),
      reverseDuration: Duration(milliseconds: 100),
    );
  }
}

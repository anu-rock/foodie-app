import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

class PropBadge extends StatelessWidget {
  final String propName;
  final String propValue;
  final IconData icon;
  final Color color;

  PropBadge({
    this.propName,
    this.propValue,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                this.propValue,
                style: TextStyle(
                  fontSize: 25.0,
                  color: this.color,
                ),
              ),
              Icon(
                this.icon,
                color: kColorBluegrey,
                size: 12.0,
              ),
            ],
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(
                  2.0,
                  2.0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          this.propName,
          style: TextStyle(
            color: kColorBluegrey,
          ),
        ),
      ],
    );
  }
}

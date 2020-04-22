import 'package:flutter/material.dart';

class IngredientsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '🥺',
          style: TextStyle(
            fontSize: 100.0,
          ),
        ),
        SizedBox(height: 20.0),
        Text('The fridge is empty!'),
      ],
    );
  }
}

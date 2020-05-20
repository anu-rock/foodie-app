import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IngredientsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(FontAwesomeIcons.shoppingBasket, size: 100.0),
          SizedBox(height: 20.0),
          Text('Your basket is empty!', style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 10.0),
          Text('Add ingredients and tap the magic button'),
          Text('to see what you can cook'),
        ],
      ),
    );
  }
}

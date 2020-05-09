import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/screens/recipe_directions/direction_card.dart';
import 'package:foodieapp/screens/recipe_directions/fancy_background.dart';

class RecipeDirectionsScreen extends StatelessWidget {
  static const id = 'recipe_directions';

  final Recipe recipe;

  RecipeDirectionsScreen({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FancyBackground(),
        Padding(
          padding: EdgeInsets.only(
            top: kPaddingUnits * 2,
            right: kPaddingUnits * 2,
            left: kPaddingUnits * 2,
          ),
          child: _directionList(recipe),
        ),
      ],
    );
  }

  ListView _directionList(Recipe recipe) {
    return ListView(
      children: recipe.instructions
          .asMap()
          .map((idx, direction) => MapEntry(
                idx,
                Container(
                  margin: EdgeInsets.only(bottom: kPaddingUnits),
                  child: DirectionCard(
                    step: idx + 1,
                    directionText: direction,
                  ),
                ),
              ))
          .values
          .toList(),
    );
  }
}

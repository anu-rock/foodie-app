import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodieapp/constants.dart';

import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/screens/recipe_directions/direction_card.dart';
import 'package:foodieapp/screens/recipe_directions/fancy_background.dart';

class RecipeDirectionsScreen extends StatefulWidget {
  static const id = 'recipe_directions';

  @override
  _RecipeDirectionsScreenState createState() => _RecipeDirectionsScreenState();
}

class _RecipeDirectionsScreenState extends State<RecipeDirectionsScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Recipe recipe = ModalRoute.of(context).settings.arguments;

    // A more elegant solution than programatically calculating body
    // would be to use the [Visibility] widget (with `replacement` prop).
    // It was tried at first.
    // Sadly, it seems to build both child and replacement widgets
    // despite its `visible` prop evaluating to false.
    // As a result all uses of `recipe.<prop>` result in null reference error
    // inside child's widget tree.
    var mainBody = recipe == null
        ? Center(
            child: Text('No valid Recipe instance received!'),
          )
        : Stack(
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

    return mainBody;
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

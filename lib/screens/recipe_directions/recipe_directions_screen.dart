import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/models/recipe.dart';
import 'package:foodieapp/screens/recipe_directions/recipe_direction.dart';
import 'package:foodieapp/widgets/heading_2.dart';

class RecipeDirectionsScreen extends StatelessWidget {
  static const id = 'recipe_directions';

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
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(recipe.pic),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: kPaddingUnits * 2,
                  right: kPaddingUnits,
                  left: kPaddingUnits,
                  bottom: kPaddingUnits,
                ),
                child: Material(
                  elevation: kContElevation,
                  borderRadius: kContBorderRadiusSm,
                  shadowColor: kContShadowColor,
                  child: Container(
                    padding: kPaddingAll,
                    decoration: BoxDecoration(
                      borderRadius: kContBorderRadiusSm,
                    ),
                    child: ListView(
                      children: <Widget>[
                        Heading2('Directions'),
                        SizedBox(
                          height: 20.0,
                        ),
                        ...recipe.directions
                            .asMap()
                            .map((idx, direction) => MapEntry(
                                  idx,
                                  Container(
                                    margin:
                                        EdgeInsets.only(bottom: kPaddingUnits),
                                    child: RecipeDirection(
                                      step: idx + 1,
                                      directionText: direction,
                                    ),
                                  ),
                                ))
                            .values
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: kColorBluegrey,
        ),
        title: Heading2(recipe != null ? recipe.name : 'Recipe Directions'),
      ),
      body: mainBody,
    );
  }
}

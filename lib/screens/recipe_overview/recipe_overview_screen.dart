import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/models/recipe.dart';
import 'package:foodieapp/screens/recipe_cook/recipe_cook_screen.dart';
import 'package:foodieapp/screens/recipe_overview/prop_tile.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:foodieapp/widgets/page_action_button.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';

class RecipeOverviewScreen extends StatelessWidget {
  static const id = 'recipe_overview';

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
        : ListView(
            children: <Widget>[
              Hero(
                tag: 'recipe_pic_${recipe.id}',
                child: Container(
                  height: 250.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(recipe.pic),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: kPaddingUnits,
                  right: kPaddingUnits,
                  bottom: kPaddingUnits,
                ),
                child: Material(
                  elevation: kContElevation,
                  shadowColor: kContShadowColor,
                  borderRadius: kContBorderRadiusSm,
                  child: Container(
                    padding: kPaddingAllSm,
                    decoration: BoxDecoration(
                      borderRadius: kContBorderRadiusSm,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: PropTile(
                                propName: 'Cooking Time',
                                propValue: '${recipe.cookingTime} mins',
                              ),
                            ),
                            Expanded(
                              child: PropTile(
                                propName: 'Difficulty',
                                propValue: '${recipe.difficulty}',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: PropTile(
                                propName: 'Ingredients',
                                propValue: recipe.ingredients.length.toString(),
                              ),
                            ),
                            Expanded(
                              child: PropTile(
                                propName: 'Per Serving',
                                propValue: '200 g',
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: kPaddingAllSm,
                          child: PageActionButton(
                            text: 'Cook',
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        kModalBorderRadiusUnits),
                                    topRight: Radius.circular(
                                        kModalBorderRadiusUnits),
                                  ),
                                ),
                                builder: (context) => RecipeCookScreen(
                                  recipe: recipe,
                                ),
                              );
                            },
                          ),
                        ),
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
        title: Heading2(recipe != null ? recipe.name : 'Recipe Overview'),
      ),
      body: mainBody,
      bottomNavigationBar: TabsBar(),
    );
  }
}

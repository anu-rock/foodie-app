import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/recipe_cook/serving_size_tile.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/screens/recipe_cook/recipe_cook_screen.dart';
import 'package:foodieapp/screens/recipe_overview/prop_tile.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:foodieapp/widgets/page_action_button.dart';
import 'package:foodieapp/data/recipe/user_recipe.dart';

class RecipeOverviewScreen extends StatefulWidget {
  static const id = 'recipe_overview';

  @override
  _RecipeOverviewScreenState createState() => _RecipeOverviewScreenState();
}

class _RecipeOverviewScreenState extends State<RecipeOverviewScreen> {
  Recipe recipeFromRoute;
  Recipe recipe;
  UserRecipe userRecipe;

  /// Returns recipe in cache-first fashion.
  ///
  /// This saves unnecessary API/storage calls that would otherwise occur
  /// because of rebuilds of this widget.
  Future<Recipe> _updateUserSpecificDetails(Recipe r) async {
    if (this.recipe != null) {
      return this.recipe;
    }

    final recipeRepo = Provider.of<RecipeRepository>(context);
    this.recipe = await recipeRepo.getRecipe(r.id);
    this.userRecipe = await recipeRepo.viewRecipe(this.recipe);

    if (this.recipe.id == null) {
      var recipeMap = this.recipe.toMap();
      recipeMap['id'] = this.userRecipe.recipeId;
      this.recipe = Recipe.fromMap(recipeMap);
    }

    return this.recipe;
  }

  @override
  Widget build(BuildContext context) {
    // A more elegant solution than programatically calculating body
    // would be to use the [Visibility] widget (with `replacement` prop).
    // It was tried at first.
    // Sadly, it seems to build both child and replacement widgets
    // despite its `visible` prop evaluating to false.
    // As a result all uses of `recipe.<prop>` result in null reference error
    // inside child's widget tree.
    this.recipeFromRoute = ModalRoute.of(context).settings.arguments;

    var mainBody = this.recipeFromRoute == null
        ? Center(
            child: Text('No valid Recipe instance received!'),
          )
        : FutureBuilder<Recipe>(
            future: this._updateUserSpecificDetails(this.recipeFromRoute),
            builder: (context, snapshot) {
              return ListView(
                children: <Widget>[
                  Hero(
                    tag: 'recipe_pic_${this.recipeFromRoute.id}',
                    child: Container(
                      height: 250.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(this.recipeFromRoute.photoUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  (!snapshot.hasData)
                      ? Padding(
                          padding: kPaddingAll,
                          child: CupertinoActivityIndicator(),
                        )
                      : Padding(
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
                                          propValue: recipe.difficulty == null
                                              ? 'unknown'
                                              : recipe.difficulty.toString(),
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
                                          propName: 'Servings',
                                          propValue: recipe.servings == null
                                              ? 'unknown'
                                              : recipe.servings.toString(),
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
                                              topLeft: Radius.circular(kModalBorderRadiusUnits),
                                              topRight: Radius.circular(kModalBorderRadiusUnits),
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
            });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: kColorBluegrey,
        ),
        title:
            Heading2(this.recipeFromRoute != null ? this.recipeFromRoute.title : 'Recipe Overview'),
      ),
      body: mainBody,
    );
  }
}

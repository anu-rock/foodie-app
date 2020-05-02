import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:foodieapp/widgets/recipe_card.dart';
import 'package:foodieapp/widgets/heading_3.dart';
import 'package:foodieapp/widgets/recipe_card_loader.dart';

class RecipeSearchScreen extends StatefulWidget {
  static const id = 'recipe_search';

  @override
  _RecipeSearchScreenState createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  List<Recipe> recipes;

  /// Returns recipes in cache-first fashion.
  Future<List<Recipe>> _getRecipes() async {
    if (this.recipes != null) {
      return this.recipes;
    }

    final ingredientsRepo = Provider.of<IngredientRepository>(context, listen: false);
    final recipeRepo = Provider.of<RecipeRepository>(context, listen: false);
    final ingredients = await ingredientsRepo.getIngredientsAsFuture();
    this.recipes = await recipeRepo.findRecipesByIngredients(
      ingredients.map((i) => i.name).toList(),
    );

    return this.recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: kColorBluegrey,
        ),
        title: Heading2('Recipe Suggestions'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _getRecipes(),
        builder: (context, recipesSnapshot) {
          Widget mainBody;
          if (!recipesSnapshot.hasData) {
            mainBody = _appShell();
          } else {
            if (recipesSnapshot.data.length > 0) {
              mainBody = _suggestionList(recipesSnapshot.data);
            } else {
              mainBody = _noResultsMessage();
            }
          }

          return Container(
            child: mainBody,
            color: kColorLightGrey,
            padding: EdgeInsets.only(
              top: kPaddingUnitsSm,
              left: kPaddingUnitsSm,
              right: kPaddingUnitsSm,
            ),
          );
        },
      ),
    );
  }

  ListView _appShell() {
    return ListView(
      children: <Widget>[
        RecipeCardLoader(),
        SizedBox(height: 20.0),
        RecipeCardLoader(),
        SizedBox(height: 20.0),
        RecipeCardLoader(),
      ],
    );
  }

  ListView _suggestionList(List<Recipe> recipes) {
    return ListView(
      children: recipes
          .map(
            (r) => Column(
              children: <Widget>[
                RecipeCard(recipe: r),
                SizedBox(height: 20.0),
              ],
            ),
          )
          .toList(),
    );
  }

  Container _noResultsMessage() {
    return Container(
      padding: kPaddingAll,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Heading3('Awww, shucks!'),
          SizedBox(height: 20.0),
          Text('We could not find recipes for your combination of ingredients.'),
        ],
      ),
    );
  }
}

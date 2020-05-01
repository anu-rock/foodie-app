import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/widgets/heading_3.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:foodieapp/widgets/recipe_cover_tile.dart';

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

    final ingredientsRepo = Provider.of<IngredientRepository>(context);
    final recipeRepo = Provider.of<RecipeRepository>(context);
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
        future: this._getRecipes(),
        builder: (context, recipesSnapshot) {
          if (!recipesSnapshot.hasData) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (recipesSnapshot.data.length > 0) {
            return this._buildSuggestionList(recipesSnapshot.data);
          } else {
            return this._buildNoResultsMessage();
          }
        },
      ),
    );
  }

  Widget _buildSuggestionList(List<Recipe> recipes) {
    return Container(
      color: kColorLightGrey,
      padding: EdgeInsets.only(
        top: kPaddingUnitsSm,
        left: kPaddingUnitsSm,
        right: kPaddingUnitsSm,
      ),
      child: ListView(
        children: recipes
            .map(
              (r) => Column(
                children: <Widget>[
                  RecipeCoverTile(recipe: r),
                  SizedBox(height: 20.0),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildNoResultsMessage() {
    return Padding(
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

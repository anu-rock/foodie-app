import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/ingredient/ingredient.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:foodieapp/widgets/recipe_cover_tile.dart';

class RecipeSearchScreen extends StatelessWidget {
  static const id = 'recipe_search';

  @override
  Widget build(BuildContext context) {
    var ingredientsRepo = Provider.of<IngredientRepository>(context);
    var recipeRepo = Provider.of<RecipeRepository>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: kColorBluegrey,
        ),
        title: Heading2('Recipe Suggestions'),
      ),
      body: StreamBuilder<List<Ingredient>>(
        stream: ingredientsRepo.getIngredients(),
        initialData: [],
        builder: (context, streamSnapshot) {
          var ingredients = streamSnapshot.data.map((i) => i.name).toList();
          return FutureBuilder<List<Recipe>>(
            future: recipeRepo.findRecipesByIngredients(ingredients),
            initialData: [],
            builder: (context, futureSnapshot) {
              if (!futureSnapshot.hasData) {
                return Center(
                  child: Text('Loading...'),
                );
              }
              return Container(
                padding: kPaddingAll,
                child: ListView(
                  children: futureSnapshot.data
                      .map((r) => Column(
                            children: <Widget>[
                              RecipeCoverTile(recipe: r),
                              SizedBox(height: 20.0),
                            ],
                          ))
                      .toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

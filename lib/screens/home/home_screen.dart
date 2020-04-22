import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/ingredient/ingredient.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:foodieapp/widgets/recipe_cover_tile.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';
import 'home_header.dart';
import 'ingredient_tile.dart';
import 'ingredients_placeholder.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home';

  @override
  Widget build(BuildContext context) {
    var ingredientRepo = Provider.of<IngredientRepository>(context);

    List<Widget> recipeTiles = [];
    [].forEach((recipe) {
      recipeTiles.add(RecipeCoverTile(recipe: recipe));
      recipeTiles.add(SizedBox(height: 20.0));
    });

    return ListView(
      children: <Widget>[
        HomeHeader(),
        SizedBox(height: 40.0),
        Padding(
          padding: kPaddingAll,
          child: Heading2('Your Ingredients'),
        ),
        Padding(
          padding: kPaddingHorizontal,
          child: StreamBuilder<List<Ingredient>>(
            stream: ingredientRepo.getIngredients(),
            initialData: [],
            builder: (context, snapshot) {
              var ingredients = snapshot.data;

              return (ingredients.length == 0)
                  ? IngredientsPlaceholder()
                  : Column(
                      children: ingredients.map((i) => IngredientTile(ingredient: i)).toList(),
                    );
            },
          ),
        ),
      ],
    );
  }
}

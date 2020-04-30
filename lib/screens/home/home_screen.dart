import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/ingredient_add/ingredient_add_screen.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/ingredient/ingredient.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';
import 'home_header.dart';
import 'ingredient_tile.dart';
import 'ingredients_placeholder.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home';

  @override
  Widget build(BuildContext context) {
    var ingredientRepo = Provider.of<IngredientRepository>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, IngredientAddScreen.id),
        child: Icon(Icons.add),
        backgroundColor: kColorYellow,
      ),
      body: ListView(
        children: <Widget>[
          HomeHeader(),
          SizedBox(height: 10.0),
          Padding(
            padding: kPaddingAll,
            child: Heading2('Your Ingredients'),
          ),
          Padding(
            padding: kPaddingHorizontal,
            child: StreamBuilder<List<Ingredient>>(
              stream: ingredientRepo.getIngredients(),
              initialData: null,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CupertinoActivityIndicator();
                }

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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/data/ingredient/ingredient.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;

  IngredientTile({@required this.ingredient});

  @override
  Widget build(BuildContext context) {
    var ingredientRepo = Provider.of<IngredientRepository>(context);

    return Container(
      padding: kPaddingHorizontalSm,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(this.ingredient.name),
          IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.red,
            ),
            onPressed: () {
              ingredientRepo.removeIngredient(this.ingredient.id);
            },
          ),
        ],
      ),
    );
  }
}

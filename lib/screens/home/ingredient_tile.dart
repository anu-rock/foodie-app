import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:foodieapp/data/ingredient/user_ingredient.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';

class IngredientTile extends StatelessWidget {
  final UserIngredient ingredient;

  IngredientTile({@required this.ingredient});

  @override
  Widget build(BuildContext context) {
    var ingredientRepo = Provider.of<IngredientRepository>(context);

    return Dismissible(
      key: Key(this.ingredient.id),
      child: Card(
        elevation: kContElevation,
        child: ListTile(
          title: Text(this.ingredient.name),
          subtitle: Text(
            'added ${timeago.format(this.ingredient.createdAt)}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      background: Container(
        child: Icon(Icons.done, color: Colors.white),
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: kPaddingUnits),
      ),
      secondaryBackground: Container(
        child: Icon(Icons.delete, color: Colors.white),
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: kPaddingUnits),
      ),
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await ingredientRepo.removeIngredient(this.ingredient.id);
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/ingredient/ingredient.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';
import 'package:foodieapp/screens/recipe_search/recipe_search_screen.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController _typeAheadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var ingredientRepo = Provider.of<IngredientRepository>(context);

    return Material(
      elevation: kContElevation,
      shadowColor: kContShadowColor,
      borderRadius: kContBorderRadiusSm,
      child: Container(
        height: 50.0,
        width: 300.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: kContBorderRadiusSm,
        ),
        child: Padding(
          padding: kPaddingHorizontalSm,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Icon(Icons.search),
              ),
              Expanded(
                flex: 5,
                child: TypeAheadField(
                  key: Key('search_input'),
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: this._typeAheadController,
                    decoration: InputDecoration(
                      hintText: 'Find ingredients to add',
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    offsetX: -(kPaddingUnitsSm * 2 + 24.0),
                    constraints: BoxConstraints(
                      minWidth: 300.0,
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await ingredientRepo.getSuggestionsByKeyword(pattern);
                  },
                  itemBuilder: (context, Ingredient suggestion) {
                    return ListTile(
                      leading: Icon(Icons.playlist_add),
                      title: Text(suggestion.name),
                    );
                  },
                  onSuggestionSelected: (Ingredient suggestion) async {
                    var addResult = await ingredientRepo.addIngredient(
                      ingredient: suggestion,
                      quantity: 0,
                    );
                    if (addResult != null) {
                      this._typeAheadController.clear();
                    }
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: kContBorderRadiusSm,
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    color: kColorGreen,
                    child: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, RecipeSearchScreen.id);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

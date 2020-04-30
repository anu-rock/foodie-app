import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/ingredient/ingredient.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';
import 'package:foodieapp/util/selectable_item.dart';
import 'ingredient_tag.dart';
import 'search_bar.dart';

class IngredientAddScreen extends StatefulWidget {
  static const id = 'ingredients_add';

  @override
  _IngredientAddScreenState createState() => _IngredientAddScreenState();
}

class _IngredientAddScreenState extends State<IngredientAddScreen> {
  String keyword = '';
  List<SelectableItem<String>> ingredients = [];
  List<SelectableItem<String>> searchResults = [];
  List<String> selectedIngredients = [];

  @override
  void initState() {
    super.initState();
    this.loadIngredients();
  }

  void loadIngredients() async {
    final ingredientsData =
        await DefaultAssetBundle.of(context).loadString('lib/data/ingredient/ingredients.json');
    final ingredientsJson = (await convert.jsonDecode(ingredientsData)) as List;
    this.setState(() {
      this.ingredients = ingredientsJson.map((i) {
        final ingredient = i as Map<String, dynamic>;
        return SelectableItem(
          item: ingredient['name'] as String,
          isSelected: false,
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: kPaddingAll,
        child: Column(
          children: <Widget>[
            _searchArea(),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: _selectedFirstSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchArea() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: SearchBar(
            onTextChange: _onSearchKeywordChange,
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          flex: 1,
          child: FlatButton(
            child: Text('Done'),
            onPressed: () {
              _addSelectedIngredients();
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  Widget _selectedFirstSearchResults() {
    return ListView(
      children: this
          .searchResults
          .map(
            (si) => IngredientTag(
              text: si.item,
              isSelected: si.isSelected,
              onTap: (String t) {
                _toggleSelection(t);
              },
            ),
          )
          .toList(),
    );
  }

  void _onSearchKeywordChange(String keyword) {
    this.setState(() {
      this.keyword = keyword;
      _updateSearchResults();
    });
  }

  void _updateSearchResults() {
    this.searchResults =
        this.ingredients.where((i) => (i.item as String).indexOf(this.keyword) != -1).toList();
  }

  void _toggleSelection(String ingredient) {
    this.setState(() {
      var item = this.ingredients.firstWhere((i) => i.item == ingredient);
      item.isSelected = !item.isSelected;
      this.ingredients.sort();
      _updateSearchResults();
    });
  }

  void _addSelectedIngredients() {
    final selectedIngredients =
        this.ingredients.where((i) => i.isSelected).map<String>((i) => i.item).toList();
    selectedIngredients.forEach((si) => _addIngredient(si));
  }

  void _addIngredient(String ingredient) {
    final ingredientRepo = Provider.of<IngredientRepository>(context, listen: false);
    ingredientRepo.addIngredient(
      ingredient: Ingredient(name: ingredient),
      quantity: 0.0,
    );
  }
}

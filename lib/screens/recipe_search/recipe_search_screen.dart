import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/ingredient/ingredient_repository.dart';
import 'package:foodieapp/data/ingredient/user_ingredient.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/widgets/recipe_card.dart';
import 'package:foodieapp/widgets/heading_3.dart';
import 'package:foodieapp/widgets/recipe_card_loader.dart';

class RecipeSearchScreen extends StatefulWidget {
  static const id = 'recipe_search';

  @override
  _RecipeSearchScreenState createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final _scrollController = ScrollController();

  List<UserIngredient> ingredients;
  List<Recipe> recipes = [];
  bool isLoading = false;
  bool allResultsFetched = false;

  /// Returns current user's ingredients in cache-first fashion.
  Future<List<UserIngredient>> _getIngredients() async {
    if (this.ingredients != null) {
      return this.ingredients;
    }

    final ingredientsRepo = Provider.of<IngredientRepository>(context, listen: false);
    this.ingredients = await ingredientsRepo.getIngredientsAsFuture();
    return this.ingredients;
  }

  /// Returns the next 10 recipes.
  Future<void> _getRecipes() async {
    this.setState(() => this.isLoading = true);

    final recipeRepo = Provider.of<RecipeRepository>(context, listen: false);
    final ingredients = await _getIngredients();
    final nextRecipes = await recipeRepo.findRecipesByIngredients(
      ingredients.map((i) => i.name).toList(),
      this.recipes.length,
    );

    // Check whether we've reached the end of search
    if (nextRecipes.last.id == '-1') {
      _scrollController.removeListener(_onListScrolled);
      nextRecipes.removeLast();
      this.allResultsFetched = true;
    }

    this.setState(() {
      this.recipes = [...this.recipes, ...nextRecipes];
      this.isLoading = false;
    });
  }

  void _onListScrolled() {
    final position = _scrollController.position;
    if (position.pixels == position.maxScrollExtent) {
      _getRecipes();
    }
  }

  @override
  void initState() {
    super.initState();

    _getRecipes();

    _scrollController.addListener(_onListScrolled);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Recipe Suggestions'),
      body: Container(
        child: this.recipes.length > 0 || this.isLoading ? _suggestionList() : _noResultsMessage(),
        padding: EdgeInsets.only(
          top: kPaddingUnitsSm,
          left: kPaddingUnitsSm,
          right: kPaddingUnitsSm,
        ),
      ),
    );
  }

  Column _appShell() {
    return Column(
      children: <Widget>[
        RecipeCardLoader(),
        SizedBox(height: 20.0),
        RecipeCardLoader(),
        SizedBox(height: 20.0),
        RecipeCardLoader(),
      ],
    );
  }

  ListView _suggestionList() {
    return ListView(controller: _scrollController, children: [
      ...this
          .recipes
          .map(
            (r) => Column(
              children: <Widget>[
                RecipeCard(recipe: r),
                SizedBox(height: 20.0),
              ],
            ),
          )
          .toList(),
      Visibility(
        visible: this.isLoading,
        child: _appShell(),
      ),
      Visibility(
        visible: this.allResultsFetched,
        child: Container(
          padding: kPaddingAll,
          alignment: Alignment.centerRight,
          child: Text('- The End'),
        ),
      )
    ]);
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

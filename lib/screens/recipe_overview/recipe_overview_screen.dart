import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/widgets/text_icon_button.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/screens/recipe_cook/recipe_cook_screen.dart';
import 'package:foodieapp/screens/recipe_overview/prop_tile.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:foodieapp/widgets/page_action_button.dart';
import 'package:foodieapp/data/recipe/user_recipe.dart';

class RecipeOverviewScreen extends StatefulWidget {
  static const id = 'recipe_overview';

  @override
  _RecipeOverviewScreenState createState() => _RecipeOverviewScreenState();
}

class _RecipeOverviewScreenState extends State<RecipeOverviewScreen> {
  Recipe recipeFromRoute;
  Recipe recipe;
  UserRecipe userRecipe;

  @override
  Widget build(BuildContext context) {
    // A more elegant solution than programatically calculating body
    // would be to use the [Visibility] widget (with `replacement` prop).
    // It was tried at first.
    // Sadly, it seems to build both child and replacement widgets
    // despite its `visible` prop evaluating to false.
    // As a result all uses of `recipe.<prop>` result in null reference error
    // inside child's widget tree.
    this.recipeFromRoute = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: kColorBluegrey,
        ),
        title:
            Heading2(this.recipeFromRoute != null ? this.recipeFromRoute.title : 'Recipe Overview'),
      ),
      body: this.recipeFromRoute == null
          ? Center(
              child: Text('No valid Recipe instance received!'),
            )
          : FutureBuilder<Recipe>(
              future: this._getStoredDetails(this.recipeFromRoute),
              builder: (context, snapshot) {
                return ListView(
                  children: <Widget>[
                    this._hero(),
                    (!snapshot.hasData)
                        ? Padding(
                            padding: kPaddingAll,
                            child: CupertinoActivityIndicator(),
                          )
                        : this._recipeDetails(),
                  ],
                );
              },
            ),
    );
  }

  /// Returns recipe in cache-first fashion.
  ///
  /// This saves unnecessary API/storage calls that would otherwise occur
  /// because of rebuilds of this widget.
  Future<Recipe> _getStoredDetails(Recipe r) async {
    if (this.recipe != null) {
      return this.recipe;
    }

    final recipeRepo = Provider.of<RecipeRepository>(context);

    if (r.id == r.sourceRecipeId) {
      // This will be true when coming here from search screen
      this.recipe = await recipeRepo.getRecipeBySourceRecipeId(r.id);
    } else {
      // This will be true in all other cases
      this.recipe = await recipeRepo.getRecipe(r.id);
    }
    this.recipe = this.recipe ?? r; // an unstored recipe will be null in both cases above
    this.userRecipe = await recipeRepo.viewRecipe(this.recipe);

    if (this.recipe.id == null) {
      var recipeMap = this.recipe.toMap();
      recipeMap['id'] = this.userRecipe.recipeId;
      this.recipe = Recipe.fromMap(recipeMap);
    }

    return this.recipe;
  }

  Widget _hero() {
    return Hero(
      tag: 'recipe_pic_${this.recipeFromRoute.id}',
      child: Stack(
        children: <Widget>[
          Container(
            height: 250.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(this.recipeFromRoute.photoUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          this.userRecipe == null
              ? SizedBox(width: 0, height: 0)
              : Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: kContBorderRadiusSm,
                    ),
                    child: TextIconButton(
                      text: this.recipe.favs.toString(),
                      leadingIcon: Icon(
                        Icons.favorite,
                        color: userRecipe.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: this._onFavoritePressed,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _recipeDetails() {
    return Padding(
      padding: EdgeInsets.only(
        left: kPaddingUnits,
        right: kPaddingUnits,
        bottom: kPaddingUnits,
      ),
      child: Material(
        elevation: kContElevation,
        shadowColor: kContShadowColor,
        borderRadius: kContBorderRadiusSm,
        child: Container(
          padding: kPaddingAllSm,
          decoration: BoxDecoration(
            borderRadius: kContBorderRadiusSm,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: PropTile(
                      propName: 'Cooking Time',
                      propValue: '${recipe.cookingTime} mins',
                    ),
                  ),
                  Expanded(
                    child: PropTile(
                      propName: 'Difficulty',
                      propValue:
                          recipe.difficulty == null ? 'unknown' : recipe.difficulty.toString(),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: PropTile(
                      propName: 'Ingredients',
                      propValue: recipe.ingredients.length.toString(),
                    ),
                  ),
                  Expanded(
                    child: PropTile(
                      propName: 'Servings',
                      propValue: recipe.servings == null ? 'unknown' : recipe.servings.toString(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: kPaddingAllSm,
                child: PageActionButton(
                  text: 'Cook',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(kModalBorderRadiusUnits),
                          topRight: Radius.circular(kModalBorderRadiusUnits),
                        ),
                      ),
                      builder: (context) => RecipeCookScreen(
                        recipe: recipe,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onFavoritePressed() async {
    final recipeRepo = Provider.of<RecipeRepository>(context, listen: false);
    final updatedUserRecipe = await recipeRepo.toggleFavorite(this.recipe.id);
    this.setState(() {
      this.userRecipe = updatedUserRecipe;
      var recipeMap = this.recipe.toMap();
      if (updatedUserRecipe.isFavorite) {
        recipeMap['favs'] = this.recipe.favs + 1;
      } else {
        recipeMap['favs'] = this.recipe.favs - 1;
      }
      this.recipe = Recipe.fromMap(recipeMap);
    });
  }
}

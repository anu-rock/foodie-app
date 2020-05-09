import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/screens/recipe_overview/recipe_overview_screen.dart';
import 'package:foodieapp/widgets/custom_app_bar.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/data/recipe/user_recipe.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:provider/provider.dart';

class RecipeListScreen extends StatefulWidget {
  final RecipeListType type;
  final String userId;

  RecipeListScreen({
    @required this.type,
    @required this.userId,
  });

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  Stream<List<UserRecipe>> recipeStream;
  RecipeRepository recipeRepo;

  @override
  void initState() {
    super.initState();

    this.recipeStream = _getRecipes();
  }

  Stream<List<UserRecipe>> _getRecipes() {
    print('_getRecipes called');
    this.recipeRepo = Provider.of<RecipeRepository>(context, listen: false);
    Stream<List<UserRecipe>> recipes;

    switch (this.widget.type) {
      case RecipeListType.favorites:
        recipes = recipeRepo.getFavoriteRecipes(this.widget.userId);
        break;
      case RecipeListType.cooked:
        recipes = recipeRepo.getPlayedRecipes(this.widget.userId);
        break;
      case RecipeListType.viewed:
        recipes = recipeRepo.getViewedRecipes();
        break;
    }

    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<UserRecipe>>(
        stream: this.recipeStream,
        builder: (context, snapshot) {
          final recipes = snapshot.data;

          return Scaffold(
            appBar: CustomAppBar(title: _getScreenTitle()),
            body: (!snapshot.hasData || recipes.isEmpty)
                ? _placeholder()
                : ListView.separated(
                    itemCount: recipes.length,
                    separatorBuilder: (context, index) => Divider(height: 1.0),
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      ListTile tile;

                      switch (this.widget.type) {
                        case RecipeListType.favorites:
                          tile = _favoriteRecipeTile(recipe);
                          break;
                        case RecipeListType.cooked:
                          tile = _cookedRecipeTile(recipe);
                          break;
                        case RecipeListType.viewed:
                          tile = _viewedRecipeTile(recipe);
                          break;
                      }

                      return tile;
                    },
                  ),
          );
        },
      ),
    );
  }

  ListTile _favoriteRecipeTile(UserRecipe recipe) {
    return ListTile(
      title: Text(recipe.recipeTitle),
      subtitle: Text('favorited ${timeago.format(recipe.favoritedAt)}'),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => RecipeOverviewScreen(
              recipe: Recipe(id: recipe.recipeId),
            ),
          ),
        );
      },
    );
  }

  ListTile _cookedRecipeTile(UserRecipe recipe) {
    return ListTile(
      title: Text(recipe.recipeTitle),
      subtitle: Text('cooked ${timeago.format(recipe.playedAt.last)}'),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => RecipeOverviewScreen(
              recipe: Recipe(id: recipe.recipeId),
            ),
          ),
        );
      },
    );
  }

  ListTile _viewedRecipeTile(UserRecipe recipe) {
    return ListTile(
      title: Text(recipe.recipeTitle),
      subtitle: Text(
        'viewed ${recipe.viewedAt.length.toString()} time${recipe.viewedAt.length > 1 ? 's' : ''}'
        ' - '
        'last viewed ${timeago.format(recipe.viewedAt.last)}',
      ),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => RecipeOverviewScreen(
              recipe: Recipe(id: recipe.recipeId),
            ),
          ),
        );
      },
    );
  }

  String _getScreenTitle() {
    String title = '';

    switch (this.widget.type) {
      case RecipeListType.favorites:
        title = 'Favorites';
        break;
      case RecipeListType.cooked:
        title = 'Cooked';
        break;
      case RecipeListType.viewed:
        title = 'Viewed';
        break;
    }
    return title;
  }

  Center _placeholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.speaker_notes_off,
            size: 60.0,
          ),
          Heading2('Nada. Nothing.'),
        ],
      ),
    );
  }
}

enum RecipeListType {
  favorites,
  cooked,
  viewed,
}

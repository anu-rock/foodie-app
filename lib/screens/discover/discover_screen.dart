import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/widgets/recipe_card.dart';

class DiscoverScreen extends StatefulWidget {
  static const id = 'discover';

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  Stream<List<Recipe>> recipesStream;

  @override
  void initState() {
    super.initState();

    _getPopularRecipes();
  }

  void _getPopularRecipes() {
    print('_getPopularRecipes called');
    final recipeRepo = Provider.of<RecipeRepository>(context, listen: false);
    this.recipesStream = recipeRepo.getPopularRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kPaddingAll,
      child: StreamBuilder<List<Recipe>>(
          stream: this.recipesStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CupertinoActivityIndicator());
            }

            final recipes = snapshot.data;

            return ListView(
              children: <Widget>[
                _popularBanner(),
                ..._popularList(recipes),
              ],
            );
          }),
    );
  }

  List<Column> _popularList(List<Recipe> recipes) {
    return recipes
        .asMap()
        .map(
          (i, r) => MapEntry(
            i,
            Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                Row(
                  children: <Widget>[
                    Text(
                      (i + 1).toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.grey,
                      ),
                    ),
                    Expanded(child: RecipeCard(recipe: r)),
                  ],
                ),
              ],
            ),
          ),
        )
        .values
        .toList();
  }

  Container _popularBanner() {
    return Container(
      alignment: Alignment.center,
      height: 60.0,
      decoration: BoxDecoration(
        borderRadius: kContBorderRadiusLg,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.blue, Colors.red],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Popular Recipes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'what others are cooking right now',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

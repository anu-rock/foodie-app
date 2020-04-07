import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/screens/home/home_cta_tile.dart';
import 'package:foodieapp/screens/home/home_header.dart';
import 'package:foodieapp/widgets/heading_2.dart';
import 'package:foodieapp/widgets/recipe_cover_tile.dart';
import 'package:foodieapp/widgets/tabs_bar.dart';
import 'package:foodieapp/data/popular_recipes.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home';

  @override
  Widget build(BuildContext context) {
    List<Widget> recipeTiles = [];
    popularRecipes.forEach((recipe) {
      recipeTiles.add(RecipeCoverTile(recipe: recipe));
      recipeTiles.add(SizedBox(height: 20.0));
    });

    return Scaffold(
      bottomNavigationBar: TabsBar(),
      body: ListView(
        children: <Widget>[
          HomeHeader(),
          SizedBox(height: 50.0),
          Padding(
            padding: kPaddingHorizontal,
            child: HomeCTATile(),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: kPaddingAllSm,
            child: Heading2('Popular Recipes'),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: kPaddingHorizontal,
            child: Column(
              children: recipeTiles,
            ),
          ),
        ],
      ),
    );
  }
}

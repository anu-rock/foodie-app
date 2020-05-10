import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/widgets/animated_heart_button.dart';
import 'package:provider/provider.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/data/recipe/user_recipe.dart';
import 'package:foodieapp/models/app_state.dart';
import 'package:foodieapp/util/string_util.dart';
import 'package:foodieapp/widgets/text_icon_button.dart';
import 'package:foodieapp/screens/recipe_directions/recipe_directions_screen.dart';
import 'prop_badge.dart';

class RecipeOverviewScreen extends StatefulWidget {
  static const id = 'recipe_overview';
  final Recipe recipe;

  RecipeOverviewScreen({@required this.recipe});

  @override
  _RecipeOverviewScreenState createState() => _RecipeOverviewScreenState();
}

class _RecipeOverviewScreenState extends State<RecipeOverviewScreen> {
  Stream<Recipe> recipeStream;
  Recipe recipe;
  UserRecipe userRecipe;
  AppState appState;
  bool recipeViewed = false;

  @override
  void initState() {
    super.initState();

    this.recipeStream = _getStoredDetails();

    // Delaying call to `appState.hideTabBar` gets rid of nasty
    // state/build related errors
    Future.delayed(Duration(milliseconds: 500), () {
      appState = Provider.of<AppState>(context, listen: false);
      appState.hideTabBar();
    });
  }

  @override
  void dispose() {
    // Delaying call to `appState.hideTabBar` gets rid of nasty
    // state/build related errors
    Future.delayed(Duration(milliseconds: 500), () {
      appState.showTabBar();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<Recipe>(
        stream: this.recipeStream,
        initialData: _getPlaceholderRecipe(this.widget.recipe),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            this.recipe = snapshot.data;
            // The following condition will ensure the recipe is marked as viewed
            // only once per screen opened
            if (!this.recipeViewed &&
                (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done)) {
              _viewRecipe();
            }
          } else {
            // When the stream returns no data, it means recipe is not stored yet;
            // so this is when we persistently store recipe
            _saveRecipe();
          }

          return Column(
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                alignment: Alignment.topCenter,
                children: <Widget>[
                  this._hero(),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: BackButton(
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: this.userRecipe == null ? CupertinoActivityIndicator() : _favButton(),
                  ),
                  Positioned(
                    top: 120.0,
                    left: kPaddingUnits,
                    child: _title(),
                  ),
                  Positioned(
                    top: 160.0,
                    child: _metaData(),
                  ),
                ],
              ),
              SizedBox(
                height: 90.0,
              ),
              Expanded(
                child: Padding(
                  padding: kPaddingHorizontal,
                  child: _description(),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _hero() {
    return Hero(
      tag: 'recipe_pic_${this.recipe.id}',
      child: Stack(
        children: <Widget>[
          Container(
            height: 250.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(this.recipe.photoUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 250.0,
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
        ],
      ),
    );
  }

  ListView _description() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: kPaddingUnits),
          child: Text(StringUtil.removeHtmlTags(this.recipe.desc)),
        ),
      ],
    );
  }

  Container _metaData() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: kPaddingUnitsSm,
        horizontal: kPaddingUnits,
      ),
      decoration: BoxDecoration(
        borderRadius: kContBorderRadiusSm,
        color: Color.fromRGBO(255, 255, 255, 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2.0,
            spreadRadius: 1.0,
            offset: Offset(
              2.0,
              2.0,
            ),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          _cookButton(),
          SizedBox(height: 10.0),
          _propBadges(),
        ],
      ),
    );
  }

  ButtonTheme _cookButton() {
    return ButtonTheme(
      minWidth: 250.0,
      child: FlatButton(
        color: kColorGreen,
        shape: RoundedRectangleBorder(
          borderRadius: kContBorderRadiusSm,
        ),
        padding: kPaddingHorizontal,
        child: Text('Cook', style: TextStyle(color: Colors.white)),
        onPressed: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => RecipeDirectionsScreen(
              recipe: this.recipe,
            ),
          ),
        ),
      ),
    );
  }

  Row _propBadges() {
    return Row(
      children: <Widget>[
        PropBadge(
          propName: 'time to cook',
          propValue: this.recipe.cookingTime.toString(),
          icon: Icons.timer,
          color: Colors.red,
        ),
        SizedBox(
          width: 15.0,
        ),
        PropBadge(
          propName: 'ingredients',
          propValue: this.recipe.ingredients.length.toString(),
          icon: Icons.format_list_numbered,
          color: Colors.amber,
        ),
        SizedBox(
          width: 15.0,
        ),
        PropBadge(
          propName: 'servings',
          propValue: this.recipe.servings.toString(),
          icon: Icons.people,
          color: Colors.blue,
        ),
      ],
    );
  }

  Text _title() {
    return Text(
      StringUtil.truncateString(str: this.recipe.title),
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Container _favButton() {
    return Container(
      width: 80.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: kContBorderRadiusSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedHeartButton(
            color: userRecipe.isFavorite ? Colors.red : Colors.grey,
            onPressed: this._onFavoritePressed,
          ),
          SizedBox(width: 5.0),
          Text(
            this.recipe.favs.toString(),
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }

  Future<void> _viewRecipe() async {
    print('_viewRecipe called');
    final recipeRepo = Provider.of<RecipeRepository>(context, listen: false);
    final result = await recipeRepo.viewRecipe(this.recipe);
    this.setState(() {
      this.recipeViewed = true;
      this.userRecipe = result;
    });
  }

  Future<Recipe> _saveRecipe() async {
    print('_saveRecipe called');
    final recipeRepo = Provider.of<RecipeRepository>(context, listen: false);
    return await recipeRepo.saveRecipe(this.recipe);
  }

  Stream<Recipe> _getStoredDetails() {
    print('_getStoredDetails called');

    final r = this.widget.recipe;
    final recipeRepo = Provider.of<RecipeRepository>(context, listen: false);
    Stream<Recipe> recipeStream;

    if (r.id == r.sourceRecipeId) {
      // This will be true when coming here from search screen
      recipeStream = recipeRepo.getRecipeBySourceRecipeId(r.id);
    } else {
      // This will be true in all other cases
      recipeStream = recipeRepo.getRecipe(r.id);
    }

    return recipeStream;
  }

  Recipe _getPlaceholderRecipe(Recipe r) {
    return Recipe(
      id: r.id,
      cookingTime: r.cookingTime ?? 0,
      desc: StringUtil.ifNullOrEmpty(r.desc, '<desc>'),
      favs: r.favs ?? 0,
      ingredients: r.ingredients ?? [],
      instructions: r.instructions ?? [],
      photoUrl: StringUtil.ifNullOrEmpty(
        r.photoUrl,
        'https://via.placeholder.com/640x360.png/?text=Photo%20not%20available',
      ),
      plays: r.plays ?? 0,
      servings: r.servings ?? 0,
      sourceName: r.sourceName ?? '',
      sourceRecipeId: r.sourceRecipeId ?? '0',
      sourceUrl: r.sourceUrl ?? '',
      title: StringUtil.ifNullOrEmpty(r.title, '<name>'),
      views: r.views ?? 0,
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

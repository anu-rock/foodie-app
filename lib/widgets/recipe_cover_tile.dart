import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/screens/recipe_overview/recipe_overview_screen.dart';
import 'package:foodieapp/util/string_util.dart';
import 'package:foodieapp/widgets/heading_3.dart';

class RecipeCoverTile extends StatelessWidget {
  /// The [Recipe] this tile represents.
  final Recipe recipe;

  RecipeCoverTile({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        RecipeOverviewScreen.id,
        arguments: this.recipe,
      ),
      child: Container(
        margin: kPaddingHorizontalSm,
        child: Material(
          elevation: kContElevation,
          shadowColor: kContShadowColor,
          borderRadius: kContBorderRadiusLg,
          child: Container(
            padding: kPaddingAllSm,
            decoration: BoxDecoration(
              borderRadius: kContBorderRadiusLg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _thumbnail(),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: _recipeDetails(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _recipeDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _title(),
        SizedBox(
          height: 10.0,
        ),
        _description(),
        SizedBox(
          height: 10.0,
        ),
        _cookingTime(),
      ],
    );
  }

  Row _cookingTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: kContBorderRadiusLg,
            color: Colors.blueGrey,
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.access_time,
                size: 12.0,
                color: Colors.white70,
              ),
              SizedBox(width: 5.0),
              Text(
                '${this.recipe.cookingTime.toString()} min',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Wrap _description() {
    return Wrap(
      children: <Widget>[
        Text(
          StringUtil.truncateString(
            str: this.recipe.desc.replaceAll(kRegexHtml, ''),
            maxLen: 45,
          ),
        ),
      ],
    );
  }

  Wrap _title() {
    return Wrap(
      children: <Widget>[
        Heading3(
          StringUtil.truncateString(
            str: this.recipe.title,
            maxLen: 18,
          ),
        ),
      ],
    );
  }

  Hero _thumbnail() {
    return Hero(
      tag: 'recipe_pic_${recipe.id}',
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: kContBorderRadiusLg,
        ),
        child: ClipRRect(
          borderRadius: kContBorderRadiusLg,
          child: FadeInImage.assetNetwork(
            placeholder: 'images/image-loading.gif',
            image: recipe.photoUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/screens/recipe_overview/recipe_overview_screen.dart';

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
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Material(
            elevation: kContElevation,
            shadowColor: kContShadowColor,
            borderRadius: kContBorderRadiusSm,
            child: Hero(
              tag: 'recipe_pic_${recipe.id}',
              child: ClipRRect(
                borderRadius: kContBorderRadiusSm,
                child: FadeInImage.assetNetwork(
                  placeholder: 'images/image-loading.gif',
                  image: recipe.photoUrl,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            left: -10.0,
            bottom: 20.0,
            child: Material(
              elevation: 5.0,
              shadowColor: kContShadowColor,
              borderRadius: kContBorderRadiusSm,
              child: Container(
                height: 90.0,
                width: 150.0,
                padding: kPaddingAllSm,
                decoration: BoxDecoration(borderRadius: kContBorderRadiusSm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(this.recipe.title),
                    SizedBox(height: 20.0),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.timer,
                            size: 10.0,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            '${this.recipe.cookingTime} mins',
                            style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

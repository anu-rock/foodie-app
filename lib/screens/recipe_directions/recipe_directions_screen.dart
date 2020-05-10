import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/screens/recipe_directions/direction_card.dart';
import 'package:foodieapp/screens/recipe_directions/fancy_background.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foodieapp/constants.dart';

class RecipeDirectionsScreen extends StatefulWidget {
  static const id = 'recipe_directions';

  final Recipe recipe;

  RecipeDirectionsScreen({@required this.recipe});

  @override
  _RecipeDirectionsScreenState createState() => _RecipeDirectionsScreenState();
}

class _RecipeDirectionsScreenState extends State<RecipeDirectionsScreen> {
  @override
  void initState() {
    super.initState();

    _playRecipe();
  }

  Future<void> _playRecipe() async {
    print('_playRecipe called');
    final recipeRepo = Provider.of<RecipeRepository>(context, listen: false);
    await recipeRepo.playRecipe(this.widget.recipe.id);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        FancyBackground(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _directionsCarousel(),
            SizedBox(height: 50.0),
            _shareButton(),
          ],
        ),
      ],
    );
  }

  FlatButton _shareButton() {
    return FlatButton(
      color: kColorYellow,
      child: Text(
        'Share with friends',
        style: TextStyle(fontSize: 18.0),
      ),
      onPressed: () {
        Share.share('I just cooked ${this.widget.recipe.title}.');
      },
    );
  }

  CarouselSlider _directionsCarousel() {
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
      ),
      itemCount: widget.recipe.instructions.length,
      itemBuilder: (BuildContext context, int idx) {
        return DirectionCard(
          step: idx + 1,
          directionText: widget.recipe.instructions[idx],
        );
      },
    );
  }
}

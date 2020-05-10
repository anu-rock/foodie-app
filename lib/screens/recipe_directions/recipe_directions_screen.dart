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
  CardLayout selectedLayout = CardLayout.carousel;

  @override
  void initState() {
    super.initState();

    _playRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        FancyBackground(),
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            _cardLayout(),
          ],
        ),
        Positioned(
          top: 30.0,
          child: _layoutSelector(),
        ),
        Positioned(
          top: 90.0,
          child: _shareButton(),
        ),
      ],
    );
  }

  Widget _cardLayout() {
    switch (this.selectedLayout) {
      case CardLayout.list:
        return _directionList();
      case CardLayout.carousel:
      default:
        return _directionsCarousel();
    }
  }

  Row _layoutSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.view_carousel,
            color: this.selectedLayout == CardLayout.carousel ? kColorGreen : Colors.white,
          ),
          onPressed: () => _switchLayout(CardLayout.carousel),
        ),
        IconButton(
          icon: Icon(
            Icons.list,
            color: this.selectedLayout == CardLayout.list ? kColorGreen : Colors.white,
          ),
          onPressed: () => _switchLayout(CardLayout.list),
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

  Container _directionList() {
    return Container(
      padding: EdgeInsets.only(
        left: kPaddingUnits,
        right: kPaddingUnits,
        top: 140.0,
      ),
      child: Column(
        children: this
            .widget
            .recipe
            .instructions
            .asMap()
            .map((idx, direction) => MapEntry(
                  idx,
                  Container(
                    margin: EdgeInsets.only(bottom: kPaddingUnits),
                    child: DirectionCard(
                      step: idx + 1,
                      directionText: direction,
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }

  Future<void> _playRecipe() async {
    print('_playRecipe called');
    final recipeRepo = Provider.of<RecipeRepository>(context, listen: false);
    await recipeRepo.playRecipe(this.widget.recipe.id);
  }

  void _switchLayout(CardLayout layout) {
    this.setState(() => this.selectedLayout = layout);
  }
}

enum CardLayout {
  carousel,
  list,
}

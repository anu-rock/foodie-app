import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

class RecipeCardLoader extends StatefulWidget {
  @override
  _RecipeCardLoaderState createState() => _RecipeCardLoaderState();
}

class _RecipeCardLoaderState extends State<RecipeCardLoader> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> animationOne;
  Animation<Color> animationTwo;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animationOne = ColorTween(
      begin: Colors.grey,
      end: Colors.grey.shade100,
    ).animate(_animationController);
    animationTwo = ColorTween(
      begin: Colors.grey.shade100,
      end: Colors.grey,
    ).animate(_animationController);

    _animationController.forward();

    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (_animationController.status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(colors: [this.animationOne.value, this.animationTwo.value])
                  .createShader(rect);
            },
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

  Container _thumbnail() {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: kContBorderRadiusLg,
        color: Colors.white,
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
      ],
    );
  }

  Wrap _description() {
    return Wrap(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 10.0,
          decoration: BoxDecoration(
            borderRadius: kContBorderRadiusSm,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Wrap _title() {
    return Wrap(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 20.0,
          decoration: BoxDecoration(
            borderRadius: kContBorderRadiusSm,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedGradientBackground extends StatelessWidget {
  final _tween = MultiTween<DefaultAnimationProperties>()
    ..add(
      DefaultAnimationProperties.color,
      ColorTween(begin: Color(0xffD38312), end: Colors.lightBlue.shade900),
    )
    ..add(
      DefaultAnimationProperties.color,
      ColorTween(begin: Color(0xffA83279), end: Colors.blue.shade600),
    );

  @override
  Widget build(BuildContext context) {
    return MirrorAnimation(
      tween: _tween,
      duration: Duration(seconds: 10),
      builder: (context, child, MultiTweenValues<DefaultAnimationProperties> tween) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                tween.get(DefaultAnimationProperties.color),
                tween.get(DefaultAnimationProperties.color),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

class IngredientTag extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function onTap;

  const IngredientTag({
    @required this.text,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => this.onTap(this.text),
      child: Container(
        padding: kPaddingAllSm,
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
          borderRadius: kContBorderRadiusLg,
          color: this.isSelected ? Colors.grey : kColorLightGrey,
        ),
        child: Row(
          children: <Widget>[
            Icon(this.isSelected ? Icons.done : Icons.add_circle),
            SizedBox(width: 5.0),
            Text(this.text),
          ],
        ),
      ),
    );
  }
}

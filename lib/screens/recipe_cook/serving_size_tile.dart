import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';

/// A selectable tile that represents a recipe's serving size.
class ServingSizeTile extends StatelessWidget {
  /// The serving size to display as tile's primary content,
  /// ideally equal to number of people to serve (eg. 1, 2, 3, etc.)
  final String size;

  /// Indicates whether the tile is selected.
  /// The tile is style accordingly.
  final bool isSelected;

  ServingSizeTile({
    @required this.size,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: this.isSelected ? kContElevation : 0.0,
      borderRadius: kContBorderRadiusSm,
      child: Container(
        padding: kPaddingAll,
        decoration: BoxDecoration(
          borderRadius: kContBorderRadiusSm,
          color: this.isSelected ? kColorGreen : Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Text(
              this.size,
              style: TextStyle(
                fontSize: this.isSelected ? 25.0 : 22.0,
                color: this.isSelected ? Colors.white : kColorBluegrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

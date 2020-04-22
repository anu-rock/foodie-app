import 'package:flutter/material.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/screens/recipe_cook/serving_size_tile.dart';
import 'package:foodieapp/screens/recipe_directions/recipe_directions_screen.dart';
import 'package:foodieapp/widgets/handle_line.dart';
import 'package:foodieapp/widgets/heading_3.dart';
import 'package:foodieapp/widgets/page_action_button.dart';

class RecipeCookScreen extends StatefulWidget {
  final Recipe recipe;
  final List<String> servingSizes = ['1', '2', '3', '4', '5'];

  RecipeCookScreen({@required this.recipe});

  @override
  _RecipeCookScreenState createState() => _RecipeCookScreenState();
}

class _RecipeCookScreenState extends State<RecipeCookScreen> {
  String selectedSize;

  @override
  void initState() {
    this.selectedSize = this.widget.servingSizes[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      padding: kPaddingAll,
      decoration: BoxDecoration(
        color: Color(0xfff9f9f9),
        borderRadius: BorderRadius.circular(kModalBorderRadiusUnits),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HandleLine(),
          SizedBox(height: 20.0),
          Row(
            children: <Widget>[
              Icon(
                Icons.photo_size_select_small,
                color: kColorGreen,
                size: 16.0,
              ),
              SizedBox(width: 10.0),
              Heading3('Select serving size'),
            ],
          ),
          SizedBox(height: 20.0),
          Container(
            height: 70.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: this
                  .widget
                  .servingSizes
                  .map((size) => Container(
                        margin: EdgeInsets.only(right: kPaddingUnits),
                        child: InkWell(
                          child: ServingSizeTile(
                            size: size,
                            isSelected: this.selectedSize == size,
                          ),
                          onTap: () => this.setState(() {
                            this.selectedSize = size;
                          }),
                        ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(height: 40.0),
          PageActionButton(
            text: 'Cook for ${this.selectedSize} Person(s)',
            onPressed: () => Navigator.pushNamed(
              context,
              RecipeDirectionsScreen.id,
              arguments: this.widget.recipe,
            ),
          ),
        ],
      ),
    );
  }
}

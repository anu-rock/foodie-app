import 'package:flutter/foundation.dart';
import 'package:foodieapp/models/ingredient.dart';

class Recipe {
  /// Unique identifier for recipe.
  final String id;

  /// Name of the food item the recipe corresponds to.
  final String name;

  /// Total cooking time in minutes.
  final int cookingTime;

  /// Number of times the recipe was liked.
  final int likes;

  /// URL of a picture for this recipe or food item.
  final String pic;

  /// List of ingredients used in recipe.
  final List<Ingredient> ingredients;

  /// Difficulty level of recipe.
  /// One of Easy, Medium, or Difficult.
  final String difficulty;

  /// Ordered list of steps or directions to create this recipe.
  final List<String> directions;

  Recipe({
    @required this.id,
    @required this.name,
    this.cookingTime,
    this.likes,
    this.pic,
    this.ingredients,
    this.difficulty,
    this.directions,
  });
}

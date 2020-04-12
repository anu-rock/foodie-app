import 'ingredient.dart';
import 'user_ingredient.dart';

/// A class that helps with ingredient-related data.
///
/// Defines an interface or contract for concrete ingredient repositories.
///
/// Today there's a Firebase-based user repository,
/// tomorrow there could be an API-based user repository,
/// or even a local storage based user repository (for caching),
/// and so on.
abstract class IngredientRepository {
  /// Returns a list of suggested [Ingredient]s based on `keyword`,
  /// which represents a partial or full ingredient name.
  ///
  /// Use this method to get typeahead search suggestions
  /// while adding ingredients for user.
  Future<List<Ingredient>> getSuggestionsByKeyword(String keyword);

  /// Adds the given ingredient to current user's collection.
  ///
  /// Returns the added ingredient database object if successful,
  /// and null otherwise.
  Future<UserIngredient> addIngredient(
      {Ingredient ingredient, double quantity});

  /// Updates the current user's ingredient as per given values.
  ///
  /// Note that only fields specified as named parameters may be updated.
  Future<bool> updateIngredient(
    String ingredientId, {
    double quantity,
    MeasuringUnit unitOfMeasure,
    DateTime removedAt,
  });

  /// Removes the given ingredient from current user's collection.
  ///
  /// Note that this is a soft removal,
  /// meaning that the ingredient is not physically removed from database
  /// but rather only gets its `removedAt` field set to current datetime.
  Future<bool> removeIngredient(String ingredientId);

  /// Returns all ingredients from current user's collection.
  Stream<List<UserIngredient>> getIngredients();
}

import 'recipe.dart';
import 'user_recipe.dart';

/// A class that helps with recipe-related data.
///
/// Defines an interface or contract for concrete recipe repositories.
///
/// Today there's a Firebase-based recipe repository,
/// tomorrow there could be an API-based recipe repository,
/// or even a local storage based recipe repository (for caching),
/// and so on.
abstract class RecipeRepository {
  /// Returns a list of [Recipe]s that contain specified ingredients
  /// in their own list of ingredients.
  ///
  /// `offset` is the number of results to skip, useful for pagination.
  Future<List<Recipe>> findRecipesByIngredients(List<String> ingredients, int offset);

  /// Returns a [Recipe] identified by given unique id.
  Stream<Recipe> getRecipe(String id);

  /// Returns a [Recipe] identified by given source recipe id.
  Stream<Recipe> getRecipeBySourceRecipeId(String id);

  /// Returns a [Recipe] found at `url`.
  Stream<Recipe> getRecipeBySourceUrl(String url);

  /// Saves given recipe to database or other persistent store.
  ///
  /// This is useful when temporarily or permanently caching
  /// a recipe from a third-party source.
  ///
  /// It will usually be triggered along with `RecipeRepository.viewRecipe()`.
  ///
  /// Returns the saved recipe's id if successful, null otherwise.
  Future<Recipe> saveRecipe(Recipe recipe);

  /// Mark given recipe as a favorite of current user,
  /// unmark if already a favorite.
  ///
  /// This updates the corresponding [UserRecipe]'s `isFavorite` and `favoritedAt` fields.
  ///
  /// Returns the updated [UserRecipe].
  Future<UserRecipe> toggleFavorite(String recipeId);

  /// Mark given recipe as viewed by current user.
  ///
  /// If a corresponding [UserRecipe] does not exist, one will be created.
  /// Otherwise the corresponding [UserRecipe]'s `viewedAt` field will be updated.
  ///
  /// Consequentially, presence of a corresponding [UserRecipe] indicates
  /// that given recipe has been viewed by current user.
  ///
  /// Note that this method expects the complete [Recipe] object rather than
  /// only a recipe id. This is to handle the case when a recipe is being viewed
  /// for the first time ever, and hence the need to save it before viewing.
  /// Saving will generate a new recipe id that can then be used to create
  /// a corresponding [UserRecipe].
  ///
  /// Also note that it is not the responsibility of this method to perform
  /// the save operation. This will be handled by `RecipeRepository.saveRecipe`.
  ///
  /// Returns the created or updated [UserRecipe].
  Future<UserRecipe> viewRecipe(Recipe recipe);

  /// Mark given recipe as played by current user.
  ///
  /// This updates the corresponding [UserRecipe]'s `isPlayed` and `playedAt` fields.
  ///
  /// Returns the updated [UserRecipe].
  Future<UserRecipe> playRecipe(String recipeId);

  /// Returns favorite recipes of given user.
  Stream<List<UserRecipe>> getFavoriteRecipes(String userId);

  /// Returns recipes played by given user.
  Stream<List<UserRecipe>> getPlayedRecipes(String userId);

  /// Returns recipes viewed by current user.
  ///
  /// Note that method does not accept a `userId` and works only for the current user,
  /// because we want to keep a user's views private.
  /// This is in contrast to favorite and played recipes,
  /// data that we want to publicly display on a user's profile screen.
  Stream<List<UserRecipe>> getViewedRecipes();

  /// Returns users associated with given recipe.
  Stream<List<UserRecipe>> getUsersForRecipe(String recipeId);
}

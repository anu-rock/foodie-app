import 'package:foodieapp/util/string_util.dart';

/// Represents a recipe.
///
/// This entity is to provide full details about a recipe,
/// and is so suited for recipe details screen.
///
/// It *does not* represent a recipe associated to a [User],
/// and so doesn't have user-specific fields.
/// See [UserRecipe] entity for a user-mapped recipe.
class Recipe {
  /// A unique id, usually assigned by database system
  final String id;

  /// Recipe's name or title
  final String title;

  /// A short summary.
  final String desc;

  /// URL for a photo or thumbnail of prepared dish.
  final String photoUrl;

  /// Complete list of all ingredients used.
  ///
  /// This may be helpful in later filtering stored recipes by ingredients.
  final List<String> ingredients;

  /// Time in minutes to prepare the dish.
  final int cookingTime;

  /// Difficulty level of recipe.
  final RecipeDifficulty difficulty;

  /// Recommended number of people served by one cook of recipe.
  /// In other words, the number of portions that may be served.
  final int servings;

  /// Unique identifier of recipe as designated by the source.
  final String sourceRecipeId;

  /// Name of the original source of recipe.
  ///
  /// Useful for giving credits.
  final String sourceName;

  /// URL from where recipe was picked.
  ///
  /// Useful for giving credits.
  final String sourceUrl;

  /// Number of times recipe was played.
  ///
  /// Multiple plays by the same user are counted.
  final int plays;

  /// Number of times recipe was favorited.
  final int favs;

  /// Number of times recipe was viewed.
  ///
  /// Multiple views by the same user are counted.
  final int views;

  /// Ordered list of steps to follow to create the dish.
  final List<String> instructions;

  Recipe({
    this.id,
    this.title,
    this.desc,
    this.photoUrl,
    this.ingredients = const [],
    this.cookingTime = 0,
    this.difficulty,
    this.servings,
    this.sourceRecipeId,
    this.sourceName,
    this.sourceUrl,
    this.plays = 0,
    this.favs = 0,
    this.views = 0,
    this.instructions = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Recipe &&
          runtimeType == other.runtimeType &&
          this.id == other.id &&
          this.title == other.title &&
          this.sourceName == other.sourceName;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ sourceName.hashCode;

  @override
  String toString() {
    return 'Recipe{id: $id, title: $title, sourceName: $sourceName}';
  }

  Map<String, Object> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'desc': this.desc,
      'photoUrl': this.photoUrl,
      'ingredients': this.ingredients,
      'cookingTime': this.cookingTime,
      'difficulty': StringUtil.toStringFromEnum(this.difficulty),
      'servings': this.servings,
      'sourceRecipeId': this.sourceRecipeId,
      'sourceName': this.sourceName,
      'sourceUrl': this.sourceUrl,
      'plays': this.plays,
      'favs': this.favs,
      'views': this.views,
      'instructions': this.instructions,
    };
  }

  static Recipe fromMap(Map<String, Object> map) {
    if (map == null) {
      return null;
    }

    return Recipe(
      id: map['id'] as String,
      title: map['title'] as String,
      desc: map['desc'] as String,
      photoUrl: map['photoUrl'] as String,
      ingredients: ((map['ingredients'] as List) ?? []).map((i) => i as String).toList(),
      cookingTime: map['cookingTime'] as int,
      difficulty: getRecipeDifficultyfromString(map['difficulty'].toString()),
      servings: map['servings'] as int,
      sourceRecipeId: map['sourceRecipeId'] as String,
      sourceName: map['sourceName'] as String,
      sourceUrl: map['sourceUrl'] as String,
      plays: map['plays'] as int,
      favs: map['favs'] as int,
      views: map['views'] as int,
      instructions: ((map['instructions'] as List) ?? []).map((i) => i as String).toList(),
    );
  }

  static RecipeDifficulty getRecipeDifficultyfromString(String difficulty) {
    for (var rd in RecipeDifficulty.values) {
      if (rd.toString() == difficulty) {
        return rd;
      }
    }
    return null;
  }
}

enum RecipeDifficulty { easy, medium, hard }

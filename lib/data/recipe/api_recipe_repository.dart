import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/data/recipe/user_recipe.dart';
import 'package:foodieapp/util/string_util.dart';
import 'package:foodieapp/constants.dart';

/// A concrete implementation of [RecipeRepository] based on external API calls.
///
/// This implementation only implements the `findRecipesByIngredients`
/// and `getRecipe` methods. For other methods, see other concrete
/// implementations of [RecipeRepository].
///
/// External APIs used are:
/// - Recipe Puppy
/// - Spoonaculous
class ApiRecipeRepository implements RecipeRepository {
  final http.Client _http;

  ApiRecipeRepository({
    http.Client httpClient,
  }) : this._http = httpClient ?? http.Client();

  @override
  Future<List<Recipe>> findRecipesByIngredients(List<String> ingredients, int offset) async {
    if (ingredients == null || ingredients.length == 0) {
      throw ArgumentError('ingredients cannot be null or empty');
    }

    var apiUrl = kUrlFindRecipesApi.format({
      'ingredients': ingredients.join(','),
      'offset': offset.toString(),
    });

    var response = await this._http.get(apiUrl);

    switch (response.statusCode) {
      case 200:
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        var searchResults = jsonResponse['results'] as List;
        final totalResults = jsonResponse['totalResults'] as int;

        // When we reach the last page of search results,
        // add a dummy recipe at the end as an indicator of end of results.
        if (totalResults > 0 && offset + searchResults.length >= totalResults) {
          searchResults.add({'id': -1});
        }

        return searchResults.map((r) => this._parseFromSpoonacular(r)).toList();
      case 402:
        throw QuotaExceededException('Daily API quota exhausted.');
      default:
        throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Stream<Recipe> getRecipe(String id) async* {
    if (StringUtil.isNullOrEmpty(id)) {
      throw ArgumentError('id cannot be null or empty');
    }

    var apiUrl = kUrlGetRecipeApi.format({'id': id});

    var response = await this._http.get(apiUrl);

    switch (response.statusCode) {
      case 200:
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        yield this._parseFromSpoonacular(jsonResponse);
        break;
      case 402:
        throw QuotaExceededException('Daily API quota exhausted.');
      default:
        throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Stream<Recipe> getRecipeBySourceUrl(String url) async* {
    if (StringUtil.isNullOrEmpty(url)) {
      throw ArgumentError('url cannot be null or empty');
    }

    var apiUrl = kUrlExtractRecipeApi.format({'url': url});

    var response = await this._http.get(apiUrl);

    switch (response.statusCode) {
      case 200:
        var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
        yield this._parseFromSpoonacular(jsonResponse);
        break;
      case 402:
        throw QuotaExceededException('Daily API quota exhausted.');
      default:
        throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Stream<Recipe> getRecipeBySourceRecipeId(String id) {
    throw UnsupportedError('This operation is not supported.');
  }

  @override
  Future<UserRecipe> toggleFavorite(String recipeId) {
    throw UnsupportedError('This operation is not supported.');
  }

  @override
  Stream<List<UserRecipe>> getFavoriteRecipes(String userId) {
    throw UnsupportedError('This operation is not supported.');
  }

  @override
  Stream<List<UserRecipe>> getPlayedRecipes(String userId) {
    throw UnsupportedError('This operation is not supported.');
  }

  @override
  Stream<List<UserRecipe>> getUsersForRecipe(String recipeId) {
    throw UnsupportedError('This operation is not supported.');
  }

  @override
  Stream<List<UserRecipe>> getViewedRecipes() {
    throw UnsupportedError('This operation is not supported.');
  }

  @override
  Future<UserRecipe> playRecipe(String recipeId) {
    throw UnsupportedError('This operation is not supported.');
  }

  @override
  Future<Recipe> saveRecipe(Recipe recipe) {
    throw UnsupportedError('This operation is not supported.');
  }

  @override
  Future<UserRecipe> viewRecipe(Recipe recipe) {
    throw UnsupportedError('This operation is not supported.');
  }

  Recipe _parseFromSpoonacular(Map<String, dynamic> json) {
    List<String> instructions = [];
    List<String> ingredients = [];
    final analyzedInstructions = json['analyzedInstructions'] as List;

    if (analyzedInstructions != null && analyzedInstructions.length > 0) {
      var firstAnalyzedInstructions = analyzedInstructions[0] as Map<String, dynamic>;
      var steps = firstAnalyzedInstructions['steps'] as List;
      steps.forEach((s) {
        final step = s as Map<String, dynamic>;
        instructions.add(step['step']);
        final stepIngredients = step['ingredients'] as List;
        ingredients = [
          ...ingredients,
          ...stepIngredients.map<String>((si) => si['name'] as String).toList(),
        ];
      });
    }

    return Recipe(
      id: (json['id'] as int).toString(), // to keep it consistent with other repos
      sourceRecipeId: (json['id'] as int).toString(),
      sourceName: json['sourceName'] as String,
      sourceUrl: json['sourceUrl'] as String,
      title: json['title'] as String,
      photoUrl: json['image'] as String,
      cookingTime: json['readyInMinutes'] as int,
      desc: json['summary'] as String,
      servings: json['servings'] as int,
      instructions: instructions,
      ingredients: ingredients,
    );
  }
}

class QuotaExceededException implements Exception {
  final String message;

  QuotaExceededException([this.message = '']);

  String toString() => 'QuotaExceededException: $message';
}

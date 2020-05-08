import 'package:http/http.dart' as http;

import 'recipe_repository.dart';
import 'api_recipe_repository.dart';
import 'firebase_recipe_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/data/recipe/user_recipe.dart';

/// A concrete implementation of [RecipeRepository] based on Firestore and external APIs.
///
/// This implementation marries the other two concrete implementations together -
/// [ApiRecipeRepository] and [FirebaseRecipeRepository] - by taking the best of both.
class HybridRecipeRepository implements RecipeRepository {
  final http.Client _http;
  final Firestore _store;
  final FirebaseAuth _auth;

  ApiRecipeRepository _apiRepo;
  FirebaseRecipeRepository _fbRepo;

  HybridRecipeRepository({
    http.Client httpClient,
    Firestore storeInstance,
    FirebaseAuth authInstance,
  })  : this._http = httpClient ?? http.Client(),
        this._store = storeInstance ?? Firestore.instance,
        this._auth = authInstance ?? FirebaseAuth.instance {
    this._apiRepo = ApiRecipeRepository(httpClient: this._http);
    this._fbRepo = FirebaseRecipeRepository(authInstance: this._auth, storeInstance: this._store);
  }

  @override
  Stream<Recipe> getRecipe(String id) async* {
    // Attempt to get recipe from Firestore
    Stream<Recipe> recipeStream = this._fbRepo.getRecipe(id);
    Recipe recipe = await recipeStream.first;

    if (recipe != null) {
      yield recipe;
      return;
    }

    // If not found by id, try searching by source recipe id
    recipeStream = this._fbRepo.getRecipeBySourceRecipeId(id);
    recipe = await recipeStream.first;

    if (recipe != null) {
      yield recipe;
      return;
    }

    // If nothing works, get it from API
    recipeStream = this._apiRepo.getRecipe(id);
    recipe = await recipeStream.first;

    yield recipe;
  }

  @override
  Future<UserRecipe> viewRecipe(Recipe recipe) async {
    if (recipe == null) {
      throw ArgumentError('recipe cannot be null or empty.');
    }

    return await this._fbRepo.viewRecipe(recipe);
  }

  @override
  Future<List<Recipe>> findRecipesByIngredients(List<String> ingredients, int offset) {
    return this._apiRepo.findRecipesByIngredients(ingredients, offset);
  }

  @override
  Stream<List<UserRecipe>> getFavoriteRecipes(String userId) {
    return this._fbRepo.getFavoriteRecipes(userId);
  }

  @override
  Stream<List<UserRecipe>> getPlayedRecipes(String userId) {
    return this._fbRepo.getPlayedRecipes(userId);
  }

  @override
  Stream<Recipe> getRecipeBySourceRecipeId(String id) {
    return this._fbRepo.getRecipeBySourceRecipeId(id);
  }

  @override
  Stream<Recipe> getRecipeBySourceUrl(String url) {
    return this._fbRepo.getRecipeBySourceUrl(url);
  }

  @override
  Stream<List<UserRecipe>> getUsersForRecipe(String recipeId) {
    return this._fbRepo.getUsersForRecipe(recipeId);
  }

  @override
  Stream<List<UserRecipe>> getViewedRecipes() {
    return this._fbRepo.getViewedRecipes();
  }

  @override
  Future<UserRecipe> playRecipe(String recipeId) {
    return this._fbRepo.playRecipe(recipeId);
  }

  @override
  Future<Recipe> saveRecipe(Recipe recipe) {
    return this._fbRepo.saveRecipe(recipe);
  }

  @override
  Future<UserRecipe> toggleFavorite(String recipeId) {
    return this._fbRepo.toggleFavorite(recipeId);
  }
}

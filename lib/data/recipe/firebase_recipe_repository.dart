import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/recipe/user_recipe.dart';
import 'package:foodieapp/util/date_util.dart';
import 'recipe_repository.dart';
import 'recipe.dart';

/// A concrete implementation of [RecipeRepository] based on [Firestore].
///
/// [Firestore] package internally takes care of caching data,
/// so a separate implementation of [RecipeRepository] for caching
/// is not required.
class FirebaseRecipeRepository implements RecipeRepository {
  final Firestore _store;
  final FirebaseAuth _auth;
  CollectionReference _recipesCollection;
  CollectionReference _userRecipesCollection;

  // Getting this from outside makes this class testable
  FirebaseRecipeRepository({
    Firestore storeInstance,
    FirebaseAuth authInstance,
  })  : this._store = storeInstance ?? Firestore.instance,
        this._auth = authInstance ?? FirebaseAuth.instance {
    this._recipesCollection = _store.collection(kFirestoreRecipes);
    this._userRecipesCollection = _store.collection(kFirestoreUserRecipes);
  }

  @override
  Future<Recipe> getRecipe(String id) async {
    if (id == null || id.isEmpty) {
      throw ArgumentError('id cannot be null or empty');
    }

    var snapshot = await this._recipesCollection.document(id).get();
    if (snapshot.data == null) {
      return null;
    }
    snapshot.data['id'] = snapshot.documentID;
    return Recipe.fromMap(snapshot.data);
  }

  @override
  Future<Recipe> getRecipeBySourceUrl(String url) async {
    if (url == null || url.isEmpty) {
      throw ArgumentError('url cannot be null or empty');
    } else if (!kRegexUrl.hasMatch(url)) {
      throw ArgumentError('Input is not a valid URL');
    }

    var snapshot = await this._recipesCollection.where('sourceUrl', isEqualTo: url).getDocuments();
    if (snapshot.documents.length == 0) {
      return null;
    }
    snapshot.documents[0].data['id'] = snapshot.documents[0].documentID;
    return Recipe.fromMap(snapshot.documents[0].data);
  }

  @override
  Future<Recipe> getRecipeBySourceRecipeId(String id) async {
    if (id == null || id.isEmpty) {
      throw ArgumentError('id cannot be null or empty');
    }

    var snapshot =
        await this._recipesCollection.where('sourceRecipeId', isEqualTo: id).getDocuments();
    if (snapshot.documents.length == 0) {
      return null;
    }
    snapshot.documents[0].data['id'] = snapshot.documents[0].documentID;
    return Recipe.fromMap(snapshot.documents[0].data);
  }

  @override
  Future<List<Recipe>> findRecipesByIngredients(List<String> ingredients) async {
    if (ingredients == null || ingredients.length == 0) {
      throw ArgumentError('ingredients cannot be null or empty');
    } else if (ingredients.length > 10) {
      // See this for Firebase's array membership limit:
      // https://firebase.google.com/docs/firestore/query-data/queries#in_and_array-contains-any
      throw ArgumentError('Input list cannot contain more than 10 ingredients.');
    }

    var snapshot = await this
        ._recipesCollection
        .where('ingredients', arrayContainsAny: ingredients)
        .getDocuments();

    return snapshot.documents.map((doc) {
      doc.data['id'] = doc.documentID;
      return Recipe.fromMap(doc.data);
    }).toList();
  }

  @override
  Future<List<UserRecipe>> getFavoriteRecipes(String userId) async {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError('userId cannot be null or empty.');
    }

    var snapshot = await this
        ._userRecipesCollection
        .where('userId', isEqualTo: userId)
        .where('isFavorite', isEqualTo: true)
        .getDocuments();

    return snapshot.documents.map((doc) => UserRecipe.fromMap(doc.data)).toList();
  }

  @override
  Future<List<UserRecipe>> getPlayedRecipes(String userId) async {
    if (userId == null || userId.isEmpty) {
      throw ArgumentError('userId cannot be null or empty.');
    }

    var snapshot = await this
        ._userRecipesCollection
        .where('userId', isEqualTo: userId)
        .where('isPlayed', isEqualTo: true)
        .getDocuments();

    return snapshot.documents.map((doc) => UserRecipe.fromMap(doc.data)).toList();
  }

  @override
  Future<List<UserRecipe>> getViewedRecipes() async {
    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    var snapshot = await this
        ._userRecipesCollection
        .where('userId', isEqualTo: currentUser.uid)
        .getDocuments();

    return snapshot.documents.map((doc) => UserRecipe.fromMap(doc.data)).toList();
  }

  @override
  Future<List<UserRecipe>> getUsersForRecipe(String recipeId) async {
    if (recipeId == null || recipeId.isEmpty) {
      throw ArgumentError('recipeId cannot be null or empty.');
    }

    var snapshot =
        await this._userRecipesCollection.where('recipeId', isEqualTo: recipeId).getDocuments();

    return snapshot.documents.map((doc) => UserRecipe.fromMap(doc.data)).toList();
  }

  @override
  Future<UserRecipe> toggleFavorite(String recipeId) async {
    if (recipeId == null || recipeId.isEmpty) {
      throw ArgumentError('recipeId cannot be null or empty.');
    }

    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    var docs = await this
        ._userRecipesCollection
        .where('recipeId', isEqualTo: recipeId)
        .where('userId', isEqualTo: currentUser.uid)
        .getDocuments();

    if (docs.documents.isEmpty) {
      return null;
    }

    var userRecipeRef = this._userRecipesCollection.document(docs.documents.first.documentID);

    var result = await this._store.runTransaction((tx) async {
      var snapshot = await tx.get(userRecipeRef);
      var data = snapshot.data;

      var isFavorite = data['isFavorite'] as bool;

      if (!isFavorite) {
        data['isFavorite'] = true;
        data['favoritedAt'] = DateUtil.dateToUtcIsoString(DateTime.now());
        await tx.set(userRecipeRef, data);
      } else {
        data['isFavorite'] = false;
        data['favoritedAt'] = '';
        await tx.set(userRecipeRef, data);
      }

      return data;
    });

    return UserRecipe.fromMap(result);
  }

  @override
  Future<UserRecipe> playRecipe(String recipeId) async {
    if (recipeId == null || recipeId.isEmpty) {
      throw ArgumentError('recipeId cannot be null or empty.');
    }

    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    var docs = await this
        ._userRecipesCollection
        .where('recipeId', isEqualTo: recipeId)
        .where('userId', isEqualTo: currentUser.uid)
        .getDocuments();

    if (docs.documents.isEmpty) {
      return null;
    }

    var userRecipeRef = this._userRecipesCollection.document(docs.documents.first.documentID);

    await userRecipeRef.updateData({
      'isPlayed': true,
      'playedAt': FieldValue.arrayUnion([DateUtil.dateToUtcIsoString(DateTime.now())]),
    });

    var updatedUserRecipe = (await userRecipeRef.get()).data;
    return UserRecipe.fromMap(updatedUserRecipe);
  }

  @override
  Future<UserRecipe> viewRecipe(Recipe recipe) async {
    if (recipe == null) {
      throw ArgumentError('recipe cannot be null or empty.');
    } else if (recipe.id == null || recipe.id.isEmpty) {
      throw ArgumentError('recipe does not exist in store.');
    }

    var storedRecipe = await this._recipesCollection.document(recipe.id).get();
    if (!storedRecipe.exists) {
      throw ArgumentError('recipe does not exist in store.');
    }

    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    var docs = await this
        ._userRecipesCollection
        .where('recipeId', isEqualTo: recipe.id)
        .where('userId', isEqualTo: currentUser.uid)
        .getDocuments();

    // Create corresponding UserRecipe when it doesn't already exist
    if (docs.documents.isEmpty) {
      var newUserRecipe = UserRecipe(
        recipeId: recipe.id,
        recipeTitle: storedRecipe.data['title'] as String,
        userId: currentUser.uid,
        userName: currentUser.displayName,
        viewedAt: [DateTime.now()],
      );
      await this._userRecipesCollection.add(newUserRecipe.toMap());
      return newUserRecipe;
    }

    // Otherwise, continue to update the existing corresponding UserRecipe
    var userRecipeRef = this._userRecipesCollection.document(docs.documents.first.documentID);
    await userRecipeRef.updateData({
      'isViewed': true,
      'viewedAt': FieldValue.arrayUnion([DateUtil.dateToUtcIsoString(DateTime.now())]),
    });
    var updatedUserRecipe = (await userRecipeRef.get()).data;
    return UserRecipe.fromMap(updatedUserRecipe);
  }

  @override
  Future<Recipe> saveRecipe(Recipe recipe) async {
    if (recipe == null) {
      throw ArgumentError('recipe cannot be null.');
    }

    var newRecipeRef = await this._recipesCollection.add(recipe.toMap());
    var newRecipe = (await newRecipeRef.get()).data;
    newRecipe['id'] = newRecipeRef.documentID;
    return Recipe.fromMap(newRecipe);
  }
}

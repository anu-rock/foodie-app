import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/recipe/user_recipe.dart';
import 'package:foodieapp/util/date_util.dart';
import 'package:foodieapp/util/string_util.dart';
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
  Stream<Recipe> getRecipe(String id) async* {
    if (StringUtil.isNullOrEmpty(id)) {
      throw ArgumentError('id cannot be null or empty');
    }

    var snapshots = this._recipesCollection.document(id).snapshots();

    yield* snapshots.map<Recipe>((snap) {
      if (!snap.exists) return null;
      var data = snap.data;
      data['id'] = snap.documentID;
      return Recipe.fromMap(data);
    });
  }

  @override
  Stream<Recipe> getRecipeBySourceUrl(String url) async* {
    if (StringUtil.isNullOrEmpty(url)) {
      throw ArgumentError('url cannot be null or empty');
    } else if (!kRegexUrl.hasMatch(url)) {
      throw ArgumentError('Input is not a valid URL');
    }

    var querySnapshots = this._recipesCollection.where('sourceUrl', isEqualTo: url).snapshots();

    yield* querySnapshots.map<Recipe>((qSnap) {
      if (qSnap.documents.isEmpty) return null;
      final snap = qSnap.documents.first;
      var data = snap.data;
      data['id'] = snap.documentID;
      return Recipe.fromMap(data);
    });
  }

  @override
  Stream<Recipe> getRecipeBySourceRecipeId(String id) async* {
    if (StringUtil.isNullOrEmpty(id)) {
      throw ArgumentError('id cannot be null or empty');
    }

    var querySnapshots = this._recipesCollection.where('sourceRecipeId', isEqualTo: id).snapshots();

    yield* querySnapshots.map<Recipe>((qSnap) {
      if (qSnap.documents.isEmpty) return null;
      final snap = qSnap.documents.first;
      var data = snap.data;
      data['id'] = snap.documentID;
      return Recipe.fromMap(data);
    });
  }

  @override
  Future<List<Recipe>> findRecipesByIngredients(List<String> ingredients, int offset) async {
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
      var data = doc.data;
      data['id'] = doc.documentID;
      return Recipe.fromMap(data);
    }).toList();
  }

  @override
  Stream<List<UserRecipe>> getFavoriteRecipes(String userId) async* {
    if (StringUtil.isNullOrEmpty(userId)) {
      throw ArgumentError('userId cannot be null or empty.');
    }

    var qSnapshots = this
        ._userRecipesCollection
        .where('userId', isEqualTo: userId)
        .where('isFavorite', isEqualTo: true)
        .snapshots();

    yield* qSnapshots.map((qSnap) {
      return qSnap.documents.map<UserRecipe>((snap) {
        return UserRecipe.fromMap(snap.data);
      }).toList();
    });
  }

  @override
  Stream<List<UserRecipe>> getPlayedRecipes(String userId) async* {
    if (StringUtil.isNullOrEmpty(userId)) {
      throw ArgumentError('userId cannot be null or empty.');
    }

    var qSnapshots = this
        ._userRecipesCollection
        .where('userId', isEqualTo: userId)
        .where('isPlayed', isEqualTo: true)
        .snapshots();

    yield* qSnapshots.map((qSnap) {
      return qSnap.documents.map<UserRecipe>((snap) {
        return UserRecipe.fromMap(snap.data);
      }).toList();
    });
  }

  @override
  Stream<List<UserRecipe>> getViewedRecipes() async* {
    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    var qSnapshots =
        this._userRecipesCollection.where('userId', isEqualTo: currentUser.uid).snapshots();

    yield* qSnapshots.map((qSnap) {
      return qSnap.documents.map<UserRecipe>((snap) {
        return UserRecipe.fromMap(snap.data);
      }).toList();
    });
  }

  @override
  Stream<List<UserRecipe>> getUsersForRecipe(String recipeId) async* {
    if (StringUtil.isNullOrEmpty(recipeId)) {
      throw ArgumentError('recipeId cannot be null or empty.');
    }

    var qSnapshots = this._userRecipesCollection.where('recipeId', isEqualTo: recipeId).snapshots();

    yield* qSnapshots.map((qSnap) {
      return qSnap.documents.map<UserRecipe>((snap) {
        return UserRecipe.fromMap(snap.data);
      }).toList();
    });
  }

  @override
  Future<UserRecipe> toggleFavorite(String recipeId) async {
    if (StringUtil.isNullOrEmpty(recipeId)) {
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
    } else if (StringUtil.isNullOrEmpty(recipe.id)) {
      throw ArgumentError('recipe does not exist in store.');
    }

    final storedRecipeStream = this.getRecipe(recipe.id);
    final storedRecipe = await storedRecipeStream.first;
    if (storedRecipe == null) {
      throw ArgumentError('recipe does not exist in store.');
    }

    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    final docs = this
        ._userRecipesCollection
        .where('recipeId', isEqualTo: recipe.id)
        .where('userId', isEqualTo: currentUser.uid)
        .snapshots();

    final snap = (await docs.first).documents;
    final notExists = snap.isEmpty;
    final userRecipe = notExists ? null : snap.first;

    // Create corresponding UserRecipe when it doesn't already exist
    if (notExists) {
      final newUserRecipe = UserRecipe(
        recipeId: recipe.id,
        recipeTitle: storedRecipe.title,
        userId: currentUser.uid,
        userName: currentUser.displayName,
        viewedAt: [DateTime.now()],
      );
      await this._userRecipesCollection.add(newUserRecipe.toMap());
      return newUserRecipe;
    }

    // Otherwise, continue to update the existing corresponding UserRecipe
    final userRecipeId = userRecipe.documentID;
    var userRecipeRef = this._userRecipesCollection.document(userRecipeId);
    await userRecipeRef.updateData({
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

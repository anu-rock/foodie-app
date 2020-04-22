import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/constants.dart';

import 'ingredient_repository.dart';
import 'ingredient.dart';
import 'user_ingredient.dart';

/// A concrete implementation of [IngredientRepository] based on [Firestore].
///
/// [Firestore] package internally takes care of caching data,
/// so a separate implementation of [IngredientRepository] for caching
/// is not required.
class FirebaseIngredientRepository implements IngredientRepository {
  final Firestore _store;
  final FirebaseAuth _auth;
  CollectionReference _ingredientsCollection;
  CollectionReference _userIngredientsCollection;

  // Getting this from outside makes this class testable
  FirebaseIngredientRepository({
    Firestore storeInstance,
    FirebaseAuth authInstance,
  })  : this._store = storeInstance ?? Firestore.instance,
        this._auth = authInstance ?? FirebaseAuth.instance {
    this._ingredientsCollection = _store.collection(kFirestoreIngredients);
    this._userIngredientsCollection = _store.collection(kFirestoreUserIngredients);
  }

  @override
  Future<List<Ingredient>> getSuggestionsByKeyword(String keyword) async {
    if (keyword == null || keyword.isEmpty) {
      throw ArgumentError('keyword cannot be null or empty');
    }

    var docs = await this
        ._ingredientsCollection
        .orderBy('name') // may become a performance bottleneck later
        .startAt([keyword]).endAt([keyword + "\uf8ff"]).getDocuments();

    return docs.documents.map((snapshot) => Ingredient.fromMap(snapshot.data)).toList();
  }

  @override
  Future<UserIngredient> addIngredient({Ingredient ingredient, double quantity}) async {
    if (ingredient == null) {
      throw ArgumentError('ingredient cannot be null');
    }
    if (quantity < 0) {
      throw ArgumentError('quantity cannot be negative');
    }

    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    var result = await this._userIngredientsCollection.add(UserIngredient(
          name: ingredient.name,
          unitOfMeasure: ingredient.unitOfMeasure,
          quantity: quantity,
          userId: currentUser.uid,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ).toMap());

    if (result.documentID == null) {
      return null;
    }

    var data = (await result.get()).data;
    data['id'] = result.documentID;
    return UserIngredient.fromMap(data);
  }

  @override
  Stream<List<UserIngredient>> getIngredients() async* {
    // The use of async generator is to allow us to
    // await `FirebaseAuth.currentUser()`.
    // The use of regular async will expect this method to return
    // a Future rather than a Stream.
    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    yield* _userIngredientsCollection
        .where('userId', isEqualTo: currentUser.uid)
        .where('removedAt', isEqualTo: '')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.documents.map(
            (doc) {
              var data = doc.data;
              data['id'] = doc.documentID;
              return UserIngredient.fromMap(data);
            },
          ).toList(),
        );
  }

  @override
  Future<bool> updateIngredient(
    String ingredientId, {
    double quantity,
    MeasuringUnit unitOfMeasure,
    DateTime removedAt,
  }) async {
    if (ingredientId == null || ingredientId.isEmpty) {
      throw ArgumentError('ingredientId cannot be null or empty');
    }

    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    var dataToUpdate = Map<String, dynamic>();
    dataToUpdate['updatedAt'] = DateTime.now().toUtc().toIso8601String();
    if (quantity != null) dataToUpdate['quantity'] = quantity;
    if (unitOfMeasure != null) dataToUpdate['unitOfMeasure'] = unitOfMeasure.toString();
    if (removedAt != null) dataToUpdate['removedAt'] = removedAt.toUtc().toIso8601String();

    await _userIngredientsCollection
        .document(ingredientId)
        .updateData(dataToUpdate); // safer than setData()

    // This method will always return true because apparently
    // Firestore doesn't provide a feedback for update data action
    return true;
  }

  @override
  Future<bool> removeIngredient(String ingredientId) async {
    return this.updateIngredient(ingredientId, removedAt: DateTime.now());
  }
}

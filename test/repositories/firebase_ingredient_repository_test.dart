import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/data/ingredient/user_ingredient.dart';
import 'package:test/test.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:foodieapp/constants.dart';

import 'package:foodieapp/data/ingredient/firebase_ingredient_repository.dart';
import 'package:foodieapp/data/ingredient/ingredient.dart';

void main() {
  MockFirestoreInstance _store;
  MockFirebaseAuth _auth;
  FirebaseIngredientRepository _repo;

  setUp(() async {
    _store = MockFirestoreInstance();
    _auth = MockFirebaseAuth(signedIn: true);
    _repo = FirebaseIngredientRepository(
      storeInstance: _store,
      authInstance: _auth,
    );
  });

  group('FirebaseIngredientRepository', () {
    group('getSuggestionsByKeyword()', () {
      test('should return suggestions correctly', () async {
        await _store
            .collection(kFirestoreIngredients)
            .add(IngredientMockData.existingIngredient.toMap());
        var suggestions = await _repo.getSuggestionsByKeyword('milk');
        expect(suggestions.length, 1);
        expect(suggestions[0], isA<Ingredient>());
      });

      test('should return 0 suggestions for unknown keyword', () async {
        await _store
            .collection(kFirestoreIngredients)
            .add(IngredientMockData.existingIngredient.toMap());
        var suggestions = await _repo.getSuggestionsByKeyword('butter');
        expect(suggestions.length, 0);
      });

      test('should throw exception when null is given', () {
        var callback = () async {
          await _repo.getSuggestionsByKeyword(null);
        };
        expect(callback, throwsFormatException);
      });
    });

    group('addIngredient()', () {
      test('should add ingredient successfully', () async {
        var result = await _repo.addIngredient(
          ingredient: IngredientMockData.newIngredient,
          quantity: 1.0,
        );
        expect(result, TypeMatcher<UserIngredient>());
      });

      test('should throw exception when null is given', () {
        var callback = () async {
          await _repo.addIngredient(
            ingredient: null,
            quantity: 1.0,
          );
        };
        expect(callback, throwsFormatException);
      });

      test('should throw exception when negative quantity is given', () {
        var callback = () async {
          await _repo.addIngredient(
            ingredient: IngredientMockData.newIngredient,
            quantity: -1.0,
          );
        };
        expect(callback, throwsFormatException);
      });

      test('should throw exception when user is not logged in', () {
        final _authSignedOut = MockFirebaseAuth(signedIn: false);
        final _repoWihoutUser = FirebaseIngredientRepository(
          storeInstance: _store,
          authInstance: _authSignedOut,
        );

        var callback = () async {
          await _repoWihoutUser.addIngredient(
            ingredient: IngredientMockData.newIngredient,
            quantity: 1.0,
          );
        };

        expect(callback, throwsA(predicate((e) => e is AuthException)));
      });
    });

    group('getIngredients()', () {
      test('should return a stream of list of ingredients', () async {
        var ingredients = _repo.getIngredients();

        expect(ingredients, emits(TypeMatcher<List<UserIngredient>>()));
      });

      test(
          'should contain 0 ingredients in returned list when no ingredient exists for current user',
          () {
        var ingredients = _repo.getIngredients();

        expect(ingredients, emits(hasLength(0)));
      });

      test('should correctly return ingredients for current user', () async {
        await _repo.addIngredient(
          ingredient: IngredientMockData.newIngredient,
          quantity: 1.0,
        );

        var ingredients = _repo.getIngredients();

        expect(ingredients, emits(hasLength(1)));
      });

      test('should return ingredients with their id field set', () async {
        await _repo.addIngredient(
          ingredient: IngredientMockData.newIngredient,
          quantity: 1.0,
        );

        var ingredients = _repo.getIngredients();

        var first = await ingredients.first;

        expect(first[0].id, isNotNull);
      });

      // test('should throw exception when user is not logged in', () {
      //   final _authSignedOut = MockFirebaseAuth(signedIn: false);
      //   final _repoWihoutUser = FirebaseIngredientRepository(
      //     storeInstance: _store,
      //     authInstance: _authSignedOut,
      //   );

      //   var ingredients = _repoWihoutUser.getIngredients();

      //   expect(ingredients, emitsError(AuthException));
      // });
    });

    group('updateIngredient()', () {
      test('should update the given ingredient', () async {
        var addedIngredient = await _repo.addIngredient(
          ingredient: IngredientMockData.newIngredient,
          quantity: 1.0,
        );

        var ingredientId = addedIngredient.id;
        var newQuantity = 10.0;

        await _repo.updateIngredient(ingredientId, quantity: newQuantity);

        var ingredient = await _store
            .collection(kFirestoreUserIngredients)
            .document(ingredientId)
            .get();

        // quantity got updated successfully
        expect(ingredient.data['quantity'] as double, newQuantity);
        // createdAt remains unchanged
        expect(ingredient.data['createdAt'],
            addedIngredient.createdAt.toUtc().toIso8601String());
        // updatedAt got revised
        expect(ingredient['updatedAt'],
            isNot(addedIngredient.updatedAt.toUtc().toIso8601String()));
      });

      test('should throw exception when null is given', () {
        var callback = () async {
          await _repo.updateIngredient(null);
        };
        expect(callback, throwsFormatException);
      });

      test('should throw exception when user is not logged in', () {
        final _authSignedOut = MockFirebaseAuth(signedIn: false);
        final _repoWihoutUser = FirebaseIngredientRepository(
          storeInstance: _store,
          authInstance: _authSignedOut,
        );

        var callback = () async {
          await _repoWihoutUser.updateIngredient('xyz');
        };

        expect(callback, throwsA(predicate((e) => e is AuthException)));
      });
    });

    group('removeIngredient()', () {
      test('should soft delete the given ingredient', () async {
        var addedIngredient = await _repo.addIngredient(
          ingredient: IngredientMockData.newIngredient,
          quantity: 1.0,
        );

        var ingredientId = addedIngredient.id;

        await _repo.removeIngredient(ingredientId);

        var ingredient = await _store
            .collection(kFirestoreUserIngredients)
            .document(ingredientId)
            .get();

        expect(ingredient.data['removedAt'], isNotNull);
        expect(ingredient.data['removedAt'], TypeMatcher<String>());
      });
    });
  });
}

class IngredientMockData {
  static final existingIngredient = Ingredient(
    name: 'milk',
    unitOfMeasure: MeasuringUnit.ml,
  );

  static final newIngredient = Ingredient(
    name: 'egg',
    unitOfMeasure: MeasuringUnit.nos,
  );
}

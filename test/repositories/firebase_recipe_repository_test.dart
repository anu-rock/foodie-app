import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/recipe/user_recipe.dart';
import 'package:test/test.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:foodieapp/data/recipe/firebase_recipe_repository.dart';
import 'package:foodieapp/data/recipe/recipe.dart';

MockFirestoreInstance store;
MockFirebaseAuth auth;
FirebaseRecipeRepository repo;
FirebaseUser currentUser;

void init() async {
  store = MockFirestoreInstance();
  auth = MockFirebaseAuth(signedIn: true);
  repo = FirebaseRecipeRepository(
    storeInstance: store,
    authInstance: auth,
  );
  currentUser = await auth.currentUser();
}

void main() {
  setUp(init);

  group('FirebaseRecipeRepository', () {
    group('getRecipe()', () {
      // Seed data
      setUp(() async {
        await store
            .collection(kFirestoreRecipes)
            .document(RecipeMockData.existingRecipeId)
            .setData(RecipeMockData.existingRecipe.toMap());
      });

      test('should return recipe when valid id is given', () {
        repo.getRecipe(RecipeMockData.existingRecipeId).listen((recipe) {
          expect(recipe, isA<Recipe>());
          expect(recipe.id, RecipeMockData.existingRecipeId);
        });
      });

      test('should return null when non-existent id is given', () {
        final recipe = repo.getRecipe(RecipeMockData.nonExistentRecipeId);

        expect(recipe, emits(isNull));
      });

      test('should throw exception when empty id is given', () {
        final recipe = repo.getRecipe(null);

        expect(recipe, emitsError(isArgumentError));
      });
    });

    group('getRecipeBySourceRecipeId()', () {
      setUp(() async {
        // Seed data
        await store
            .collection(kFirestoreRecipes)
            .document(RecipeMockData.existingRecipeId)
            .setData(RecipeMockData.existingRecipe.toMap());
      });

      test('should return recipe when valid id is given', () {
        repo.getRecipeBySourceRecipeId(RecipeMockData.existingRecipe.sourceRecipeId).listen(
          (recipe) {
            expect(recipe, isA<Recipe>());
            expect(recipe.id, RecipeMockData.existingRecipeId);
          },
        );
      });

      test('should return null when non-existent id is given', () {
        final recipe = repo.getRecipeBySourceRecipeId(RecipeMockData.nonExistentSourceRecipeId);

        expect(recipe, emits(isNull));
      });

      test('should throw exception when empty id is given', () {
        final recipe = repo.getRecipeBySourceRecipeId(null);

        expect(recipe, emitsError(isArgumentError));
      });
    });

    group('getRecipeBySourceUrl()', () {
      setUp(() async {
        // Seed data
        await store
            .collection(kFirestoreRecipes)
            .document(RecipeMockData.existingRecipeId)
            .setData(RecipeMockData.existingRecipe.toMap());
      });

      test('should return recipe when valid url is given', () {
        repo.getRecipeBySourceUrl(RecipeMockData.existingRecipe.sourceUrl).listen((recipe) {
          expect(recipe, isA<Recipe>());
          expect(recipe.id, RecipeMockData.existingRecipeId);
        });
      });

      test('should return null when non-existent url is given', () {
        final recipe = repo.getRecipeBySourceUrl(RecipeMockData.validSourceUrl);

        expect(recipe, emits(isNull));
      });

      test('should throw exception when empty url is given', () {
        final recipe = repo.getRecipeBySourceUrl(null);

        expect(recipe, emitsError(isArgumentError));
      });

      test('should throw exception when invalid url is given', () {
        final recipe = repo.getRecipeBySourceUrl(RecipeMockData.invalidSourceUrl);

        expect(recipe, emitsError(isArgumentError));
      });
    });

    group('getFavoriteRecipes()', () {
      setUp(() async {
        // Seed data
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .setData(RecipeMockData.existingUserRecipe.toMap());
      });

      test('should return favorite recipes when user id is given', () {
        repo.getFavoriteRecipes(currentUser.uid).listen((recipes) {
          expect(recipes, isA<List>());
          expect(recipes, isNotEmpty);
          expect(recipes[0], isA<UserRecipe>());
          expect(recipes[0].favoritedAt, isA<DateTime>());
        });
      });

      test('should return empty list when given user id has no favorites', () async {
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .updateData({'isFavorite': false, 'favoritedAt': ''});

        repo.getFavoriteRecipes(currentUser.uid).listen((recipes) {
          expect(recipes, isA<List>());
          expect(recipes, isEmpty);
        });
      });

      test('should return empty list when non-existent user id is given', () {
        repo.getFavoriteRecipes(RecipeMockData.nonExistentUserId).listen((recipes) {
          expect(recipes, isA<List>());
          expect(recipes, isEmpty);
        });
      });

      test('should throw exception when empty user id is given', () {
        final recipes = repo.getFavoriteRecipes(null);

        expect(recipes, emitsError(isArgumentError));
      });
    });

    group('getPlayedRecipes()', () {
      setUp(() async {
        // Seed data
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .setData(RecipeMockData.existingUserRecipe.toMap());
      });

      test('should return played recipes when user id is given', () {
        repo.getPlayedRecipes(currentUser.uid).listen((recipes) {
          expect(recipes, isA<List>());
          expect(recipes, isNotEmpty);
          expect(recipes[0], isA<UserRecipe>());
          expect(recipes[0].playedAt, isNotEmpty);
        });
      });

      test('should return empty list when given user id has no plays', () async {
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .updateData({'isPlayed': false, 'playedAt': []});

        repo.getPlayedRecipes(currentUser.uid).listen((recipes) {
          expect(recipes, isA<List>());
          expect(recipes, isEmpty);
        });
      });

      test('should return empty list when non-existent user id is given', () {
        repo.getPlayedRecipes(RecipeMockData.nonExistentUserId).listen((recipes) {
          expect(recipes, isA<List>());
          expect(recipes, isEmpty);
        });
      });

      test('should throw exception when empty user id is given', () {
        final recipes = repo.getPlayedRecipes(null);

        expect(recipes, emitsError(isArgumentError));
      });
    });

    group('getViewedRecipes()', () {
      setUp(() async {
        // Seed data
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .setData(RecipeMockData.existingUserRecipe.toMap());
      });

      test('should return viewed recipes when user id is given', () {
        repo.getViewedRecipes().listen((recipes) {
          expect(recipes, isA<List>());
          expect(recipes, isNotEmpty);
          expect(recipes[0], isA<UserRecipe>());
          expect(recipes[0].viewedAt, isNotEmpty);
        });
      });

      test('should return empty list when given user id has no views', () async {
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .delete();

        repo.getViewedRecipes().listen((recipes) {
          expect(recipes, isA<List>());
          expect(recipes, isEmpty);
        });
      });

      test('should throw exception when user is not logged in', () {
        final authSignedOut = MockFirebaseAuth(signedIn: false);
        final repoWihoutUser = FirebaseRecipeRepository(
          storeInstance: store,
          authInstance: authSignedOut,
        );

        final recipes = repoWihoutUser.getViewedRecipes();

        expect(recipes, emitsError(isA<AuthException>()));
      });
    });

    group('getUsersForRecipe()', () {
      setUp(() async {
        // Seed data
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .setData(RecipeMockData.existingUserRecipe.toMap());
      });

      test('should return users when recipe id is given', () {
        repo.getUsersForRecipe(RecipeMockData.existingRecipeId).listen((users) {
          expect(users, isA<List>());
          expect(users, isNotEmpty);
          expect(users[0], isA<UserRecipe>());
        });
      });

      test('should return empty list when non-existent recipe id is given', () {
        repo.getUsersForRecipe(RecipeMockData.nonExistentRecipeId).listen((users) {
          expect(users, isA<List>());
          expect(users, isEmpty);
        });
      });

      test('should throw exception when empty recipe id is given', () {
        final users = repo.getUsersForRecipe(null);

        expect(users, emitsError(isArgumentError));
      });
    });

    group('toggleFavorite()', () {
      setUp(() async {
        // Seed data
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .setData(RecipeMockData.existingUserRecipe.toMap());
      });

      test('should unfavorite a recipe when favorite recipe id is given', () async {
        var recipe = await repo.toggleFavorite(RecipeMockData.existingRecipeId);

        expect(recipe, isA<UserRecipe>());
        expect(recipe.isFavorite, false);
        expect(recipe.favoritedAt, isNull);
      });

      test('should favorite a recipe when non-favorite recipe id is given', () async {
        // Simulate unfavoriting of previously favorited recipe
        await repo.toggleFavorite(RecipeMockData.existingRecipeId);

        // Now hopefully favorite a non-favorite recipe
        var recipe = await repo.toggleFavorite(RecipeMockData.existingRecipeId);

        expect(recipe, isA<UserRecipe>());
        expect(recipe.isFavorite, true);
        expect(recipe.favoritedAt, isA<DateTime>());
      });

      test('should return null when non-existent recipe id is given', () async {
        var recipe = await repo.toggleFavorite(RecipeMockData.nonExistentRecipeId);

        expect(recipe, isNull);
      });

      test('should throw exception when empty recipe id is given', () async {
        var callback = () async {
          await repo.toggleFavorite(null);
        };

        expect(callback, throwsArgumentError);
      });

      test('should throw exception when user is not logged in', () {
        final authSignedOut = MockFirebaseAuth(signedIn: false);
        final repoWihoutUser = FirebaseRecipeRepository(
          storeInstance: store,
          authInstance: authSignedOut,
        );

        var callback = () async {
          await repoWihoutUser.toggleFavorite(RecipeMockData.existingRecipeId);
        };

        expect(callback, throwsA(predicate((e) => e is AuthException)));
      });
    });

    group('playRecipe()', () {
      setUp(() async {
        // Seed data
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .setData(RecipeMockData.existingUserRecipe.toMap());
      });

      test('should mark recipe played when previously played recipe id is given', () async {
        var recipe = await repo.playRecipe(RecipeMockData.existingRecipeId);

        expect(recipe, isA<UserRecipe>());
        expect(recipe.isPlayed, true);
        expect(recipe.playedAt, isA<List>());
        expect(recipe.playedAt, hasLength(2));
      });

      test('should mark recipe played when unplayed recipe id is given', () async {
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .updateData({'isPlayed': false, 'playedAt': []});

        var recipe = await repo.playRecipe(RecipeMockData.existingRecipeId);

        expect(recipe, isA<UserRecipe>());
        expect(recipe.isPlayed, true);
        expect(recipe.playedAt, isA<List>());
        expect(recipe.playedAt, isNotEmpty);
      });

      test('should return null when non-existent recipe id is given', () async {
        var recipe = await repo.playRecipe(RecipeMockData.nonExistentRecipeId);

        expect(recipe, isNull);
      });

      test('should throw exception when empty recipe id is given', () async {
        var callback = () async {
          await repo.playRecipe(null);
        };

        expect(callback, throwsArgumentError);
      });

      test('should throw exception when user is not logged in', () {
        final authSignedOut = MockFirebaseAuth(signedIn: false);
        final repoWihoutUser = FirebaseRecipeRepository(
          storeInstance: store,
          authInstance: authSignedOut,
        );

        var callback = () async {
          await repoWihoutUser.playRecipe(RecipeMockData.existingRecipeId);
        };

        expect(callback, throwsA(predicate((e) => e is AuthException)));
      });
    });

    group('viewRecipe()', () {
      setUp(() async {
        // Seed data
        await store
            .collection(kFirestoreRecipes)
            .document(RecipeMockData.existingRecipeId)
            .setData(RecipeMockData.existingRecipe.toMap());
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .setData(RecipeMockData.existingUserRecipe.toMap());
      });

      test('should mark recipe viewed when previously viewed recipe id is given', () async {
        var recipe = Recipe(
          id: RecipeMockData.existingRecipeId,
          title: RecipeMockData.existingRecipe.title,
          ingredients: RecipeMockData.existingRecipe.ingredients,
          sourceUrl: RecipeMockData.existingRecipe.sourceUrl,
        );

        var userRecipe = await repo.viewRecipe(recipe);

        expect(userRecipe, isA<UserRecipe>());
        expect(userRecipe.viewedAt, isA<List>());
        expect(userRecipe.viewedAt, hasLength(2));
      });

      test('should mark recipe viewed when unviewed recipe id is given', () async {
        await store
            .collection(kFirestoreUserRecipes)
            .document(RecipeMockData.existingUserRecipeId)
            .delete();

        var recipe = Recipe(
          id: RecipeMockData.existingRecipeId,
          title: RecipeMockData.existingRecipe.title,
          ingredients: RecipeMockData.existingRecipe.ingredients,
          sourceUrl: RecipeMockData.existingRecipe.sourceUrl,
        );

        var userRecipe = await repo.viewRecipe(recipe);

        expect(userRecipe, isA<UserRecipe>());
        expect(userRecipe.viewedAt, isA<List>());
        expect(userRecipe.viewedAt, isNotEmpty);

        userRecipe = await repo.viewRecipe(recipe);

        expect(userRecipe, isA<UserRecipe>());
        expect(userRecipe.viewedAt, isA<List>());
        expect(userRecipe.viewedAt, hasLength(2));
      });

      test('should throw exception when non-existent recipe id is given', () async {
        var callback = () async {
          await repo.viewRecipe(Recipe(id: RecipeMockData.nonExistentRecipeId));
        };

        expect(callback, throwsArgumentError);
      });

      test('should throw exception when recipe without id is given', () async {
        var callback = () async {
          await repo.viewRecipe(RecipeMockData.existingRecipe);
        };

        expect(callback, throwsArgumentError);
      });

      test('should throw exception when empty recipe id is given', () async {
        var callback = () async {
          await repo.viewRecipe(null);
        };

        expect(callback, throwsArgumentError);
      });

      test('should throw exception when user is not logged in', () {
        final authSignedOut = MockFirebaseAuth(signedIn: false);
        final repoWihoutUser = FirebaseRecipeRepository(
          storeInstance: store,
          authInstance: authSignedOut,
        );
        var recipe = Recipe(
          id: RecipeMockData.existingRecipeId,
          title: RecipeMockData.existingRecipe.title,
          ingredients: RecipeMockData.existingRecipe.ingredients,
          sourceUrl: RecipeMockData.existingRecipe.sourceUrl,
        );

        var callback = () async {
          await repoWihoutUser.viewRecipe(recipe);
        };

        expect(callback, throwsA(predicate((e) => e is AuthException)));
      });
    });

    group('saveRecipe()', () {
      test('should save given recipe', () async {
        var recipe = await repo.saveRecipe(RecipeMockData.existingRecipe);

        expect(recipe, isA<Recipe>());
        expect(recipe.id, isNotEmpty);
        expect(recipe.id, isNotNull);
      });

      test('should throw exception when empty recipe is given', () async {
        var callback = () async {
          await repo.saveRecipe(null);
        };

        expect(callback, throwsArgumentError);
      });
    });
  });
}

class RecipeMockData {
  static final existingRecipeId = '1';
  static final nonExistentRecipeId = '999';
  static final existingSourceRecipeId = '111111';
  static final nonExistentSourceRecipeId = '999999';
  static final existingRecipe = Recipe(
    title: 'Rajma Masala',
    ingredients: ['rajma', 'spices', 'love'],
    sourceRecipeId: existingSourceRecipeId,
    sourceUrl: 'https://foodienetwork.com/recipes/rajma-masala',
  );
  static final validSourceUrl = 'https://allrecipes.com/recipes/blueberry-cheesecake';
  static final invalidSourceUrl = 'abc';
  static final existingUserId = currentUser.uid;
  static final nonExistentUserId = 'xyz';
  static final existingUserRecipeId = '1';
  static final existingUserRecipe = UserRecipe(
    recipeId: existingRecipeId,
    recipeTitle: existingRecipe.title,
    userId: existingUserId,
    userName: currentUser.displayName,
    isFavorite: true,
    favoritedAt: DateTime.now(),
    isPlayed: true,
    playedAt: [DateTime.now()],
    viewedAt: [DateTime.now()],
  );
}

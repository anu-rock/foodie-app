import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'dart:convert' as convert;

import 'package:foodieapp/data/recipe/recipe_repository.dart';
import 'package:foodieapp/data/recipe/api_recipe_repository.dart';
import 'package:foodieapp/data/recipe/recipe.dart';
import 'package:foodieapp/constants.dart';

class MockHttpClient extends Mock implements http.Client {}

http.Client mockHttpClient;
RecipeRepository repo;

void main() {
  setUp(() {
    mockHttpClient = MockHttpClient();
    repo = ApiRecipeRepository(httpClient: mockHttpClient);

    defineStubs();
  });

  tearDown(() {
    clearInteractions(mockHttpClient);
    reset(mockHttpClient);
  });

  group('ApiRecipeRepository', () {
    group('findRecipesByIngredients', () {
      test('should return recipes when valid ingredients are given', () async {
        var foundRecipes = await repo.findRecipesByIngredients(RecipeMockData.validIngredients);

        var expectedSearchResults = RecipeMockData.searchResults['results'] as List;
        expect(foundRecipes.length, expectedSearchResults.length);
        expect(foundRecipes[0], isA<Recipe>());
        expect(foundRecipes[0].id, isNotEmpty);
      });

      test('should return an empty list when invalid ingredients are given', () async {
        var foundRecipes = await repo.findRecipesByIngredients(RecipeMockData.invalidIngredients);

        expect(foundRecipes.length, 0);
      });

      test('should throw exception when no ingredients are given', () async {
        var callback = () async {
          await repo.findRecipesByIngredients([]);
        };

        expect(callback, throwsArgumentError);
      });
    });

    group('getRecipe', () {
      test('should return recipe when valid id is given', () async {
        var recipe = await repo.getRecipe(RecipeMockData.validSourceId);

        expect(recipe, isA<Recipe>());
      });

      test('should throw exception when invalid id is given', () async {
        var callback = () async {
          await repo.getRecipe(RecipeMockData.invalidSourceId);
        };

        expect(callback, throwsException);
      });

      test('should throw exception when empty id is given', () async {
        var callback = () async {
          await repo.getRecipe(null);
        };

        expect(callback, throwsArgumentError);
      });

      test('should throw exception when API quota has expired', () async {
        when(mockHttpClient.get(any)).thenAnswer((_) => Future.value(
              http.Response(
                convert.jsonEncode(RecipeMockData.quotaExpiredResponse),
                402,
              ),
            ));

        var callback = () async {
          await repo.getRecipe(RecipeMockData.validSourceId);
        };

        expect(callback, throwsA(isA<QuotaExceededException>()));
      });
    });

    group('getRecipeBySourceUrl', () {
      test('should return recipe when valid url is given', () async {
        var recipe = await repo.getRecipeBySourceUrl(RecipeMockData.validSourceUrl);

        expect(recipe, isA<Recipe>());
      });

      test('should throw exception when invalid url is given', () async {
        var callback = () async {
          await repo.getRecipeBySourceUrl(RecipeMockData.invalidSourceUrl);
        };

        expect(callback, throwsException);
      });

      test('should throw exception when empty url is given', () async {
        var callback = () async {
          await repo.getRecipeBySourceUrl(null);
        };

        expect(callback, throwsArgumentError);
      });

      test('should throw exception when API quota has expired', () async {
        when(mockHttpClient.get(any)).thenAnswer((_) => Future.value(
              http.Response(
                convert.jsonEncode(RecipeMockData.quotaExpiredResponse),
                402,
              ),
            ));

        var callback = () async {
          await repo.getRecipeBySourceUrl(RecipeMockData.validSourceUrl);
        };

        expect(callback, throwsA(isA<QuotaExceededException>()));
      });
    });
  });
}

defineStubs() {
  when(mockHttpClient.get(
          kUrlFindRecipesApi.format({'ingredients': RecipeMockData.validIngredients.join(',')})))
      .thenAnswer((_) => Future.value(
            http.Response(
              convert.jsonEncode(RecipeMockData.searchResults),
              200,
            ),
          ));

  when(mockHttpClient.get(
          kUrlFindRecipesApi.format({'ingredients': RecipeMockData.invalidIngredients.join(',')})))
      .thenAnswer((_) => Future.value(
            http.Response(
              convert.jsonEncode(RecipeMockData.emptySearchResults),
              200,
            ),
          ));

  when(mockHttpClient.get(kUrlGetRecipeApi.format({'id': RecipeMockData.validSourceId})))
      .thenAnswer((_) => Future.value(
            http.Response(
              convert.jsonEncode(RecipeMockData.getRecipeSuccessResponse),
              200,
            ),
          ));

  when(mockHttpClient.get(kUrlGetRecipeApi.format({'id': RecipeMockData.invalidSourceId})))
      .thenAnswer((_) => Future.value(
            http.Response(
              convert.jsonEncode(RecipeMockData.getRecipeNotFoundResponse),
              404,
            ),
          ));

  when(mockHttpClient.get(kUrlExtractRecipeApi.format({'url': RecipeMockData.validSourceUrl})))
      .thenAnswer((_) => Future.value(
            http.Response(
              convert.jsonEncode(RecipeMockData.extractRecipeSuccessResponse),
              200,
            ),
          ));

  when(mockHttpClient.get(kUrlExtractRecipeApi.format({'url': RecipeMockData.invalidSourceUrl})))
      .thenAnswer((_) => Future.value(
            http.Response(
              convert.jsonEncode(RecipeMockData.extractRecipeFailureResponse),
              400,
            ),
          ));
}

class RecipeMockData {
  static final validIngredients = ['milk', 'eggs'];
  static final invalidIngredients = ['mil'];
  static final validSourceId = '1';
  static final invalidSourceId = '99999999';
  static final getRecipeSuccessResponse = {
    "vegetarian": false,
    "vegan": false,
    "glutenFree": false,
    "dairyFree": false,
    "veryHealthy": false,
    "cheap": false,
    "veryPopular": true,
    "sustainable": false,
    "weightWatcherSmartPoints": 12,
    "gaps": "no",
    "lowFodmap": false,
    "preparationMinutes": 10,
    "cookingMinutes": 15,
    "sourceUrl": "http://DAMNDELICIOUS.NET/2014/03/29/spaghetti-carbonara/",
    "spoonacularSourceUrl": "https://spoonacular.com/spaghetti-carbonara-535835",
    "aggregateLikes": 242705,
    "spoonacularScore": 70,
    "healthScore": 8,
    "pricePerServing": 110.05,
    "extendedIngredients": [],
    "id": 535835,
    "title": "Spaghetti Carbonara",
    "readyInMinutes": 25,
    "servings": 4,
    "image": "https://spoonacular.com/recipeImages/535835-556x370.jpg",
    "imageType": "jpg",
    "summary":
        "Spaghetti Carbonara might be just the <b>Mediterranean</b> recipe you are searching for. For <b>\$1.07 per serving</b>, you get a main course that serves 4. One serving contains <b>412 calories</b>, <b>20g of protein</b>, and <b>17g of fat</b>. Plenty of people made this recipe, and 242704 would say it hit the spot. Head to the store and pick up kosher salt and pepper, garlic, spaghetti, and a few other things to make it today. To use up the kosher salt you could follow this main course with the <a href=\"https://spoonacular.com/recipes/low-fat-crumbs-cake-kosher-dairy-130933\">Low Fat Crumbs Cake (Kosher-Dairy)</a> as a dessert. From preparation to the plate, this recipe takes approximately <b>25 minutes</b>. All things considered, we decided this recipe <b>deserves a spoonacular score of 73%</b>. This score is pretty good. Try <a href=\"https://spoonacular.com/recipes/spaghetti-carbonara-147723\">Spaghetti Carbonara</a>, <a href=\"https://spoonacular.com/recipes/spaghetti-carbonara-138801\">Spaghetti Carbonara</a>, and <a href=\"https://spoonacular.com/recipes/spaghetti-carbonara-568138\">Spaghetti Carbonara</a> for similar recipes.",
    "cuisines": ["Mediterranean", "Italian", "Eastern European", "European", "Greek"],
    "dishTypes": ["lunch", "main course", "main dish", "dinner"],
    "diets": [],
    "occasions": [],
    "winePairing": {
      "pairedWines": ["trebbiano", "verdicchio", "chianti"],
      "pairingText":
          "Italian works really well with Trebbiano, Verdicchio, and Chianti. Italians know food and they know wine. Trebbiano and Verdicchio are Italian white wines that pair well with fish and white meat, while Chianti is a great Italian red for heavier, bolder dishes. The Bucci Verdicchio Classico dei Castelli di Jesi with a 3.7 out of 5 star rating seems like a good match. It costs about 18 dollars per bottle.",
      "productMatches": [
        {
          "id": 441488,
          "title": "Bucci Verdicchio Classico dei Castelli di Jesi",
          "description":
              "Deep straw yellow in color. The wine has a pleasingly fruity and persistent bouquet, with notes of Golden Delicious apples and almonds. There is good body on the palate and the wine is well balanced and elegant, with a silky texture and distinct finesse.",
          "price": "\$17.99",
          "imageUrl": "https://spoonacular.com/productImages/441488-312x231.jpg",
          "averageRating": 0.74,
          "ratingCount": 12,
          "score": 0.712972972972973,
          "link":
              "https://click.linksynergy.com/deeplink?id=*QCiIS6t4gA&mid=2025&murl=https%3A%2F%2Fwww.wine.com%2Fproduct%2Fbucci-verdicchio-classico-dei-castelli-di-jesi-2011%2F124033"
        }
      ]
    },
    "instructions":
        "In a large pot of boiling salted water, cook pasta according to package instructions; reserve 1/2 cup water and drain well. In a small bowl, whisk together eggs and Parmesan; set aside. Heat a large skillet over medium high heat. Add bacon and cook until brown and crispy, about 6-8 minutes; reserve excess fat. Stir in garlic until fragrant, about 1 minute. Stir in pasta and egg mixture, and gently toss to combine; season with salt and pepper, to taste. Add reserved pasta water, one tablespoon at a time, until desired consistency is reached. Serve immediately, garnished with parsley, if desired.",
    "analyzedInstructions": [
      {
        "name": "",
        "steps": [
          {
            "number": 1,
            "step":
                "In a large pot of boiling salted water, cook pasta according to package instructions; reserve 1/2 cup water and drain well. In a small bowl, whisk together eggs and Parmesan; set aside.",
            "ingredients": [
              {"id": 1033, "name": "parmesan", "image": "parmesan.jpg"},
              {"id": 20420, "name": "pasta", "image": "fusilli.jpg"},
              {"id": 1123, "name": "egg", "image": "egg.png"}
            ],
            "equipment": [
              {"id": 404661, "name": "whisk", "image": "whisk.png"},
              {"id": 404783, "name": "bowl", "image": "bowl.jpg"},
              {"id": 404752, "name": "pot", "image": "stock-pot.jpg"}
            ]
          },
          {
            "number": 2,
            "step": "Heat a large skillet over medium high heat.",
            "ingredients": [],
            "equipment": [
              {"id": 404645, "name": "frying pan", "image": "pan.png"}
            ]
          },
          {
            "number": 3,
            "step":
                "Add bacon and cook until brown and crispy, about 6-8 minutes; reserve excess fat. Stir in garlic until fragrant, about 1 minute. Stir in pasta and egg mixture, and gently toss to combine; season with salt and pepper, to taste.",
            "ingredients": [
              {"id": 1102047, "name": "salt and pepper", "image": "salt-and-pepper.jpg"},
              {"id": 11215, "name": "garlic", "image": "garlic.png"},
              {"id": 10123, "name": "bacon", "image": "raw-bacon.png"},
              {"id": 20420, "name": "pasta", "image": "fusilli.jpg"},
              {"id": 1123, "name": "egg", "image": "egg.png"}
            ],
            "equipment": [],
            "length": {"number": 9, "unit": "minutes"}
          },
          {
            "number": 4,
            "step":
                "Add reserved pasta water, one tablespoon at a time, until desired consistency is reached.",
            "ingredients": [],
            "equipment": []
          },
          {
            "number": 5,
            "step": "Serve immediately, garnished with parsley, if desired.",
            "ingredients": [
              {"id": 11297, "name": "parsley", "image": "parsley.jpg"}
            ],
            "equipment": []
          }
        ]
      }
    ],
    "sourceName": null,
    "creditsText": null,
    "originalId": null
  };
  static final getRecipeNotFoundResponse = {
    "status": "failure",
    "code": 404,
    "message": "A recipe with the id 99999999 does not exist."
  };
  static final validSourceUrl = 'http://DAMNDELICIOUS.NET/2014/03/29/spaghetti-carbonara/';
  static final invalidSourceUrl =
      'http://www.kraftfoods.com/kf/recipes/roasted-garlic-grilling-sauce-56344.aspx';
  static final extractRecipeSuccessResponse = getRecipeSuccessResponse;
  static final extractRecipeFailureResponse = {
    "status": "failure",
    "code": 400,
    "message": "The recipe could not be extracted."
  };
  static final searchResults = {
    "results": [
      {
        "id": 209715,
        "usedIngredientCount": 1,
        "missedIngredientCount": 4,
        "likes": 0,
        "title": "Mango, pear & ginger crumble",
        "image": "https://spoonacular.com/recipeImages/209715-312x231.jpg",
        "imageType": "jpg"
      },
      {
        "id": 210509,
        "usedIngredientCount": 1,
        "missedIngredientCount": 4,
        "likes": 0,
        "title": "Clotted cream & stem ginger ice cream",
        "image": "https://spoonacular.com/recipeImages/210509-312x231.jpg",
        "imageType": "jpg"
      },
      {
        "id": 215178,
        "usedIngredientCount": 1,
        "missedIngredientCount": 4,
        "likes": 0,
        "title": "Mini chocolate & ginger brownies",
        "image": "https://spoonacular.com/recipeImages/215178-312x231.jpg",
        "imageType": "jpg"
      },
    ],
    "offset": 0,
    "number": 10,
    "totalResults": 45
  };
  static final emptySearchResults = {
    "title": "Recipe Puppy",
    "version": 0.1,
    "href": "http://www.recipepuppy.com/",
    "results": []
  };
  static final quotaExpiredResponse = {
    "status": "failure",
    "code": 402,
    "message": "Your daily quota is over."
  };
}

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
        expect(foundRecipes[0].id, isNotNull);
        expect(foundRecipes[0].sourceRecipeId, isNotNull);
        expect(foundRecipes[0].instructions, isA<List>());
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
        "vegetarian": false,
        "vegan": false,
        "glutenFree": true,
        "dairyFree": false,
        "veryHealthy": false,
        "cheap": false,
        "veryPopular": false,
        "sustainable": false,
        "weightWatcherSmartPoints": 20,
        "gaps": "no",
        "lowFodmap": false,
        "preparationMinutes": 10,
        "cookingMinutes": 20,
        "aggregateLikes": 1,
        "spoonacularScore": 81.0,
        "healthScore": 49.0,
        "creditsText": "Casaveneracion",
        "sourceName": "Casaveneracion",
        "pricePerServing": 233.75,
        "id": 522119,
        "title": "Swiss rösti salad",
        "readyInMinutes": 30,
        "servings": 1,
        "sourceUrl": "http://casaveneracion.com/swiss-rosti-salad-2/",
        "image": "https://spoonacular.com/recipeImages/522119-312x231.jpg",
        "imageType": "jpg",
        "summary":
            "Swiss rösti salad might be just the main course you are searching for. One serving contains <b>538 calories</b>, <b>18g of protein</b>, and <b>34g of fat</b>. This recipe serves 1 and costs \$2.47 per serving. 1 person has made this recipe and would make it again. From preparation to the plate, this recipe takes around <b>30 minutes</b>. It is a good option if you're following a <b>gluten free</b> diet. Head to the store and pick up tomatoes, cheese, milk, and a few other things to make it today. To use up the cheese you could follow this main course with the <a href=\"https://spoonacular.com/recipes/the-bianca-dessert-grilled-cheese-586550\">The Bianca Dessert Grilled Cheese</a> as a dessert. All things considered, we decided this recipe <b>deserves a spoonacular score of 78%</b>. This score is solid. Try <a href=\"https://spoonacular.com/recipes/ham-swiss-rosti-697040\">Ham & Swiss Rosti</a>, <a href=\"https://spoonacular.com/recipes/rsti-with-papaya-salad-658827\">Rösti With Papaya Salad</a>, and <a href=\"https://spoonacular.com/recipes/rosti-753840\">Rosti</a> for similar recipes.",
        "cuisines": [],
        "dishTypes": ["salad"],
        "diets": ["gluten free"],
        "occasions": [],
        "winePairing": {},
        "analyzedInstructions": [
          {
            "name": "",
            "steps": [
              {
                "number": 1,
                "step":
                    "Cook the whole and unpeeled potato in boiling water for about 10 minutes. Scoop out and dump in a bowl of iced water until cool. Peel and grate coarsely. Toss with salt, pepper and a bit of chili.",
                "ingredients": [
                  {"id": 2047, "name": "salt", "image": "salt.jpg"}
                ],
                "equipment": [
                  {"id": 404783, "name": "bowl", "image": "bowl.jpg"}
                ],
                "length": {"number": 10, "unit": "minutes"}
              },
              {
                "number": 2,
                "step": "Heat the butter in a frying pan.",
                "ingredients": [
                  {"id": 1001, "name": "butter", "image": "butter-sliced.jpg"}
                ],
                "equipment": [
                  {"id": 404645, "name": "frying pan", "image": "pan.png"}
                ]
              },
              {
                "number": 3,
                "step":
                    "Spread the grated potato at the bottom of the pan, pushing down lightly to make the shreds stick together. Fry over medium heat for three to four minutes per side or until golden and crisp outside.",
                "ingredients": [],
                "equipment": [
                  {"id": 404645, "name": "frying pan", "image": "pan.png"}
                ],
                "length": {"number": 3, "unit": "minutes"}
              },
              {
                "number": 4,
                "step":
                    "Place the cheese and milk in a microwaveable cup. Microwave on HIGH for a minute until the cheese is very soft. Stir to melt it completely. Season with salt, pepper and some chili.Arrange the lettuce, cucumber slices and tomato slices on a plate.",
                "ingredients": [
                  {"id": 10511529, "name": "tomato slices", "image": "sliced-tomato.jpg"},
                  {"id": 11206, "name": "cucumber", "image": "cucumber.jpg"},
                  {"id": 11252, "name": "lettuce", "image": "iceberg-lettuce.jpg"},
                  {"id": 1041009, "name": "cheese", "image": "cheddar-cheese.png"},
                  {"id": 1077, "name": "milk", "image": "milk.png"},
                  {"id": 2047, "name": "salt", "image": "salt.jpg"}
                ],
                "equipment": [
                  {"id": 404762, "name": "microwave", "image": "microwave.jpg"}
                ]
              },
              {
                "number": 5,
                "step": "Place the rösti at the center.",
                "ingredients": [],
                "equipment": []
              },
              {
                "number": 6,
                "step": "Pour the milk-cheese dressing over. Sprinkle with parsley and serve.",
                "ingredients": [
                  {"id": 11297, "name": "parsley", "image": "parsley.jpg"},
                  {"id": 1041009, "name": "cheese", "image": "cheddar-cheese.png"},
                  {"id": 1077, "name": "milk", "image": "milk.png"}
                ],
                "equipment": []
              }
            ]
          }
        ],
        "usedIngredientCount": 2,
        "missedIngredientCount": 6,
        "likes": 0
      },
      {
        "vegetarian": false,
        "vegan": false,
        "glutenFree": false,
        "dairyFree": false,
        "veryHealthy": false,
        "cheap": false,
        "veryPopular": false,
        "sustainable": false,
        "weightWatcherSmartPoints": 13,
        "gaps": "no",
        "lowFodmap": false,
        "preparationMinutes": 5,
        "cookingMinutes": 15,
        "aggregateLikes": 304,
        "spoonacularScore": 90.0,
        "healthScore": 24.0,
        "creditsText": "Veg Recipes of India",
        "sourceName": "Veg Recipes of India",
        "pricePerServing": 103.24,
        "id": 488463,
        "title": "bread tartlets , quick bread tartlets with potato cheese",
        "readyInMinutes": 20,
        "servings": 2,
        "sourceUrl": "http://www.vegrecipesofindia.com/bread-tartlets-quick-bread-tartlets/",
        "image": "https://spoonacular.com/recipeImages/488463-312x231.jpg",
        "imageType": "jpg",
        "summary":
            "Bread tartlets , quick bread tartlets with potato cheese is a <b>vegan</b> morn meal. One serving contains <b>465 calories</b>, <b>13g of protein</b>, and <b>19g of fat</b>. This recipe serves 2 and costs \$1.07 per serving. 304 people have made this recipe and would make it again. If you have chili powder, potato, onion, and a few other ingredients on hand, you can make it. From preparation to the plate, this recipe takes about <b>20 minutes</b>. All things considered, we decided this recipe <b>deserves a spoonacular score of 92%</b>. This score is awesome. Try <a href=\"https://spoonacular.com/recipes/sweet-potato-tartlets-404046\">Sweet Potato Tartlets</a>, <a href=\"https://spoonacular.com/recipes/potato-gruyre-tartlets-706232\">Potato-Gruyère Tartlets</a>, and <a href=\"https://spoonacular.com/recipes/potato-gruyre-tartlets-72562\">Potato & Gruyère Tartlets</a> for similar recipes.",
        "cuisines": [],
        "dishTypes": [],
        "diets": [],
        "occasions": [],
        "winePairing": {"pairedWines": [], "pairingText": "", "productMatches": []},
        "analyzedInstructions": [
          {
            "name": "",
            "steps": [
              {
                "number": 1,
                "step":
                    "trim the edges of the bread.flatten each piece with a rolling pinplace the bread in a muffin tinbrush with some oil or melted buttersecure a piece of crumpled foil on each breadbake in a preheated oven at 190 degrees C for 10-12 mins till the breads are crisp and browned.chop the potato, onion and tomatoes.remove the muffin tin from the oven and throw away the foil.arrange the potatoes, tomatoes and onions on the bread.sprinkle the dry herbs and the chili powder along with some salt.top up with the grated cheese.bake again in the oven at 190 degrees C for 3-5 mins till the cheese gets browned.garnish with fresh sprigs of cilantro or parsley and serve quick bread tartlets.",
                "ingredients": [
                  {"id": 2009, "name": "chili powder", "image": "chili-powder.jpg"},
                  {"id": 11529, "name": "tomato", "image": "tomato.png"},
                  {"id": 1041009, "name": "cheese", "image": "cheddar-cheese.png"},
                  {"id": 11282, "name": "onion", "image": "brown-onion.png"},
                  {"id": 18064, "name": "bread", "image": "white-bread.jpg"},
                  {"id": 1002044, "name": "herbs", "image": "mixed-fresh-herbs.jpg"},
                  {"id": 2047, "name": "salt", "image": "salt.jpg"}
                ],
                "equipment": [
                  {"id": 404671, "name": "muffin tray", "image": "muffin-tray.jpg"},
                  {"id": 404765, "name": "aluminum foil", "image": "aluminum-foil.png"},
                  {
                    "id": 404784,
                    "name": "oven",
                    "image": "oven.jpg",
                    "temperature": {"number": 190.0, "unit": "Celsius"}
                  }
                ],
                "length": {"number": 17, "unit": "minutes"}
              }
            ]
          }
        ],
        "usedIngredientCount": 2,
        "missedIngredientCount": 7,
        "likes": 0
      },
    ],
    "offset": 0,
    "number": 3,
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

import 'package:test/test.dart';

import 'package:foodieapp/data/recipe/recipe.dart';

void main() {
  group('Recipe', () {
    group('toMap()', () {
      test('should work with default instance', () {
        var recipe = Recipe();
        var map = recipe.toMap();

        expect(map, isA<Map>());
        expect(map['difficulty'], null);
        expect(map['ingredients'], isA<List>());
        expect(map['instructions'], isA<List>());
      });

      test('should work with instance with title only', () {
        var recipe = Recipe(title: 'Blueberry Cheesecake');
        var map = recipe.toMap();

        expect(map, isA<Map>());
        expect(map['title'], 'Blueberry Cheesecake');
      });
    });

    group('fromMap()', () {
      test('should work with empty map', () {
        var map = Map<String, Object>();
        var recipe = Recipe.fromMap(map);

        expect(recipe, isA<Recipe>());
        expect(recipe.difficulty, null);
        expect(recipe.ingredients, isA<List>());
        expect(recipe.instructions, isA<List>());
      });

      test('should work with map with title only', () {
        var map = {'title': 'Blueberry Cheesecake'};
        var recipe = Recipe.fromMap(map);

        expect(recipe, isA<Recipe>());
        expect(recipe.title, 'Blueberry Cheesecake');
      });
    });
  });
}

import 'package:test/test.dart';

import 'package:foodieapp/data/ingredient/ingredient.dart';

void main() {
  group('Ingredient', () {
    group('toMap()', () {
      test('should work with default instance', () {
        var ing = Ingredient();
        var map = ing.toMap();

        expect(map, isA<Map>());
      });

      test('should work with instance with name only', () {
        var ing = Ingredient(name: 'milk');
        var map = ing.toMap();

        expect(map, isA<Map>());
        expect(map['name'], 'milk');
      });
    });

    group('fromMap()', () {
      test('should work with empty map', () {
        var map = Map<String, Object>();
        var ing = Ingredient.fromMap(map);

        expect(ing, isA<Ingredient>());
      });

      test('should work with map with name only', () {
        var map = {'name': 'milk'};
        var ing = Ingredient.fromMap(map);

        expect(ing, isA<Ingredient>());
        expect(ing.name, 'milk');
      });
    });
  });
}

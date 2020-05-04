import 'package:test/test.dart';

import 'package:foodieapp/data/ingredient/user_ingredient.dart';

void main() {
  group('UserIngredient', () {
    group('toMap()', () {
      test('should work with default instance', () {
        var ingredient = UserIngredient();
        var map = ingredient.toMap();

        expect(map, isA<Map>());
        expect(map['unitOfMeasure'], isNull);
        expect(map['createdAt'], isEmpty);
        expect(map['quantity'], isNull);
      });

      test('should work with instance with name only', () {
        var ingredient = UserIngredient(name: 'milk');
        var map = ingredient.toMap();

        expect(map, isA<Map>());
        expect(map['name'], 'milk');
      });
    });

    group('fromMap()', () {
      test('should work with empty map', () {
        var map = Map<String, Object>();
        var ingredient = UserIngredient.fromMap(map);

        expect(ingredient, isA<UserIngredient>());
        expect(ingredient.unitOfMeasure, isNull);
        expect(ingredient.createdAt, isNull);
        expect(ingredient.quantity, isNull);
      });

      test('should work with map with name only', () {
        var map = {'name': 'milk'};
        var ingredient = UserIngredient.fromMap(map);

        expect(ingredient, isA<UserIngredient>());
        expect(ingredient.name, 'milk');
      });
    });
  });
}

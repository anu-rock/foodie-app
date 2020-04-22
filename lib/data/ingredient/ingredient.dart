/// Represents an ingredient in ingredients master collection.
///
/// This entity is meant to be read-only,
/// coming from a static collection of all ingredient supported by system.
///
/// It *does not* represent an ingredient associated to a [User],
/// and so doesn't have user-specific fields.
/// See [UserIngredient] entity for a user-mapped ingredient.
class Ingredient {
  /// A unique id, usually assigned by database system
  final String id;

  /// Ingredient's name
  final String name;

  /// Unit associated with ingredient's quantity.
  final MeasuringUnit unitOfMeasure;

  Ingredient({
    this.id,
    this.name,
    this.unitOfMeasure,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient &&
          runtimeType == other.runtimeType &&
          this.id == other.id &&
          this.name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() {
    return 'Ingredient{id: $id, displayName: $name}';
  }

  Map<String, Object> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'unitOfMeasure': this.unitOfMeasure.toString(),
    };
  }

  static Ingredient fromMap(Map<String, Object> map) {
    if (map.isEmpty) {
      return Ingredient();
    }

    return Ingredient(
      id: map['id'] as String,
      name: map['name'] as String,
      unitOfMeasure: getMeasuringUnitfromString(map['unitOfMeasure'].toString()),
    );
  }

  static MeasuringUnit getMeasuringUnitfromString(String unit) {
    for (var mu in MeasuringUnit.values) {
      if (mu.toString() == unit) {
        return mu;
      }
    }
    return null;
  }
}

enum MeasuringUnit { nos, g, kg, ml, l, lbs, oz, fl_oz }

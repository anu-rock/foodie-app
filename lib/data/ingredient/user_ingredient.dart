import 'package:foodieapp/util/date_util.dart';
import 'package:foodieapp/util/string_util.dart';

import 'ingredient.dart';

/// Represents an [Ingredient] mapped to a [User].
class UserIngredient extends Ingredient {
  /// The `id` of associated [User].
  final String userId;

  /// Quantity or count of ingredient.
  final double quantity;

  /// Record creation timestamp.
  final DateTime createdAt;

  /// Record updation timestamp.
  final DateTime updatedAt;

  /// Record soft deletion timestamp.
  ///
  /// Note that a [UserIngredient] record is never physically deleted
  /// from database. It's just 'soft' removed by setting this field.
  ///
  /// If this field has a non-empty or non-null value,
  /// it means it's no longer associated with its [User].
  final DateTime removedAt;

  UserIngredient({
    String id,
    String name,
    MeasuringUnit unitOfMeasure,
    this.userId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.removedAt,
  }) : super(
          id: id,
          name: name,
          unitOfMeasure: unitOfMeasure,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserIngredient &&
          runtimeType == other.runtimeType &&
          this.id == other.id &&
          this.name == other.name &&
          this.userId == other.userId;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ userId.hashCode;

  @override
  String toString() {
    return 'UserIngredient{id: $id, displayName: $name, userId: $userId}';
  }

  Map<String, Object> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'unitOfMeasure': StringUtil.toStringFromEnum(this.unitOfMeasure),
      'userId': this.userId,
      'quantity': this.quantity,
      'createdAt': DateUtil.dateToUtcIsoString(this.createdAt),
      'updatedAt': DateUtil.dateToUtcIsoString(this.updatedAt),
      'removedAt': DateUtil.dateToUtcIsoString(this.removedAt),
    };
  }

  static UserIngredient fromMap(Map<String, Object> map) {
    return UserIngredient(
      id: map['id'] as String,
      name: map['name'] as String,
      unitOfMeasure: Ingredient.getMeasuringUnitfromString(map['unitOfMeasure'].toString()),
      userId: map['userId'] as String,
      quantity: map['quantity'] as double,
      createdAt: DateUtil.dateFromUtcIsoString(map['createdAt'] as String),
      updatedAt: DateUtil.dateFromUtcIsoString(map['updatedAt'] as String),
      removedAt: DateUtil.dateFromUtcIsoString(map['removedAt'] as String),
    );
  }
}

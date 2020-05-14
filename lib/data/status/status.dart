import 'package:foodieapp/util/date_util.dart';

/// Represents a status update.
class Status {
  /// Unique id of this status update.
  final String id;

  /// Id of user linked with this status.
  ///
  /// We are deliberately not storing user's displayName,
  /// photoUrl, etc. These are supposed to come from current user's followees list.
  final String userId;

  /// The type of status update.
  final StatusType type;

  /// Message text for status update.
  ///
  /// This field is set only when [Status].type is `StatusType.custom`.
  /// For all other types, `message` will be null or empty.
  /// This gives us the flexibility to generate status text for non-custom types
  /// depending on linked recipe and/or user's language.
  final String message;

  /// Url of photo linked with this status.
  ///
  /// It will be a recipe's photoUrl for recipe-related statuses.
  final String photoUrl;

  /// Id of recipe linked with this status.
  ///
  /// This field is set only when [Status].type is `StatusType.recipe_cooked`,
  /// `StatusType.recipe_favorited`, etc.
  final String recipeId;

  /// Title of recipe linked with this status.
  ///
  /// This field is set only when [Status].type is `StatusType.recipe_cooked`,
  /// `StatusType.recipe_favorited`, etc.
  final String recipeTitle;

  /// Date and time when this status was added.
  final DateTime createdAt;

  Status({
    this.id,
    this.userId,
    this.type,
    this.message,
    this.photoUrl,
    this.recipeId,
    this.recipeTitle,
    this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Status &&
          runtimeType == other.runtimeType &&
          this.id == other.id &&
          this.userId == other.userId &&
          this.createdAt == other.createdAt;

  @override
  int get hashCode => id.hashCode ^ userId.hashCode ^ createdAt.hashCode;

  @override
  String toString() {
    return 'Status{id: $id, userId: $userId, type: ${type.toString()}, createdAt: ${createdAt.toIso8601String()}}';
  }

  Map<String, Object> toMap() {
    return {
      'userId': this.userId,
      'type': this.type.toString(),
      'message': this.message,
      'photoUrl': this.photoUrl,
      'recipeId': this.recipeId,
      'recipeTitle': this.recipeTitle,
      'createdAt': DateUtil.dateToUtcIsoString(this.createdAt),
    };
  }

  static Status fromMap(Map<String, Object> map) {
    if (map == null) {
      return null;
    }

    return Status(
      id: map['id'] as String,
      userId: map['userId'] as String,
      type: getStatusTypefromString(map['type'].toString()),
      message: map['message'] as String,
      photoUrl: map['photoUrl'] as String,
      recipeId: map['folrecipeIdloweeName'] as String,
      recipeTitle: map['recipeTitle'] as String,
      createdAt: DateUtil.dateFromUtcIsoString(map['createdAt'] as String),
    );
  }

  static StatusType getStatusTypefromString(String type) {
    for (var t in StatusType.values) {
      if (t.toString() == type) {
        return t;
      }
    }
    return null;
  }
}

enum StatusType {
  recipe_played,
  recipe_favorited,
  custom,
}

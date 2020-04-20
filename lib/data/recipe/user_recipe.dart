import 'package:flutter/foundation.dart';
import 'package:foodieapp/util/date_util.dart';

/// Represents a [Recipe] linked to a [User] through an action.
///
/// Viewing, playing or favoriting a recipe are such actions.
class UserRecipe {
  /// Id of recipe. Copied from [Recipe].id
  final String recipeId;

  /// The recipe title. Copied from [Recipe].title;
  final String recipeTitle;

  /// Whether the recipe is a favorite of user.
  final bool isFavorite;

  /// Whether the recipe has been played at least once by user.
  final bool isPlayed;

  /// Datetime when the recipe was favorited by user.
  final DateTime favoritedAt;

  /// All Datetimes when the recipe was played by user.
  final List<DateTime> playedAt;

  /// All Datetimes when the recipe was viewed by user.
  final List<DateTime> viewedAt;

  /// Id of user linked to the recipe. Copied from [User].id.
  final String userId;

  /// Display name of user linked to the recipe. Copied from [User].displayName.
  final String userName;

  /// Photo URL of user linked to the recipe. Copied from [User].photoUrl.
  final String userPhotoUrl;

  UserRecipe({
    @required this.recipeId,
    @required this.recipeTitle,
    this.isFavorite = false,
    this.isPlayed = false,
    this.favoritedAt,
    this.playedAt,
    this.viewedAt,
    @required this.userId,
    @required this.userName,
    this.userPhotoUrl = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRecipe &&
          runtimeType == other.runtimeType &&
          this.recipeId == other.recipeId &&
          this.userId == other.userId;

  @override
  int get hashCode => recipeId.hashCode ^ userId.hashCode;

  @override
  String toString() {
    return 'UserRecipe{recipeId: $recipeId, recipeTitle: $recipeTitle, ' +
        'userId: $userId, userName: $userName,}';
  }

  Map<String, Object> toMap() {
    return {
      'recipeId': this.recipeId,
      'recipeTitle': this.recipeTitle,
      'isFavorite': this.isFavorite,
      'isPlayed': this.isPlayed,
      'favoritedAt': DateUtil.dateToUtcIsoString(this.favoritedAt),
      'playedAt': DateUtil.datesToUtcIsoStrings(this.playedAt),
      'viewedAt': DateUtil.datesToUtcIsoStrings(this.viewedAt),
      'userId': this.userId,
      'userName': this.userName,
      'userPhotoUrl': this.userPhotoUrl,
    };
  }

  static UserRecipe fromMap(Map<String, Object> map) {
    if (map == null) {
      return null;
    }

    return UserRecipe(
      recipeId: map['recipeId'] as String,
      recipeTitle: map['recipeTitle'] as String,
      isFavorite: map['isFavorite'] as bool,
      isPlayed: map['isPlayed'] as bool,
      favoritedAt: DateUtil.dateFromUtcIsoString(map['favoritedAt'] as String),
      playedAt: DateUtil.datesFromUtcIsoStrings(
          (map['playedAt'] as List).map((d) => d as String).toList()),
      viewedAt: DateUtil.datesFromUtcIsoStrings(
          (map['viewedAt'] as List).map((d) => d as String).toList()),
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      userPhotoUrl: map['userPhotoUrl'] as String,
    );
  }
}

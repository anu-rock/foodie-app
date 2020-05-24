class User {
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;
  final int playedRecipes;
  final int favoriteRecipes;
  final int followers;
  final int following;
  final PrivateUserData privateUserData;

  User({
    this.id,
    this.displayName,
    this.email,
    this.photoUrl,
    this.playedRecipes = 0,
    this.favoriteRecipes = 0,
    this.followers = 0,
    this.following = 0,
    this.privateUserData,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          this.id == other.id &&
          this.displayName == other.displayName &&
          this.email == other.email;

  @override
  int get hashCode => id.hashCode ^ displayName.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'User{id: $id, displayName: $displayName, email: $email}';
  }

  Map<String, Object> toMap() {
    return {
      'id': this.id,
      'displayName': this.displayName,
      'email': this.email,
      'photoUrl': this.photoUrl,
      'playedRecipes': this.playedRecipes,
      'favoriteRecipes': this.favoriteRecipes,
      'followers': this.followers,
      'following': this.following,
      'privateUserData': this.privateUserData == null ? null : this.privateUserData.toMap(),
    };
  }

  static User fromMap(Map<String, Object> map) {
    if (map == null) {
      return null;
    }

    return User(
      id: map['id'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String,
      playedRecipes: map['playedRecipes'] as int,
      favoriteRecipes: map['favoriteRecipes'] as int,
      followers: map['followers'] as int,
      following: map['following'] as int,
      privateUserData: PrivateUserData.fromMap(map['privateUserData']),
    );
  }
}

class PrivateUserData {
  final String phoneNumber;
  final bool isEmailVerified;
  final int viewedRecipes;
  final List<String> fcmTokens;

  PrivateUserData({
    this.phoneNumber,
    this.isEmailVerified = false,
    this.viewedRecipes = 0,
    this.fcmTokens = const [],
  });

  Map<String, Object> toMap() {
    return {
      'phoneNumber': this.phoneNumber,
      'isEmailVerified': this.isEmailVerified,
      'viewedRecipes': this.viewedRecipes,
      'fcmTokens': this.fcmTokens
    };
  }

  static PrivateUserData fromMap(Map<String, Object> map) {
    if (map == null) {
      return null;
    }

    return PrivateUserData(
      phoneNumber: map['phoneNumber'] as String,
      isEmailVerified: map['isEmailVerified'] as bool,
      viewedRecipes: map['viewedRecipes'] as int,
      fcmTokens: (map['fcmTokens'] as List).map((t) => t as String).toList(),
    );
  }
}

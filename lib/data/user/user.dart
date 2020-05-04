class User {
  final String id;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  final bool isEmailVerified;
  final int playedRecipes;
  final int favoriteRecipes;

  User({
    this.id,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    this.isEmailVerified = false,
    this.playedRecipes = 0,
    this.favoriteRecipes = 0,
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
      'phoneNumber': this.phoneNumber,
      'photoUrl': this.photoUrl,
      'isEmailVerified': this.isEmailVerified,
      'playedRecipes': this.playedRecipes,
      'favoriteRecipes': this.favoriteRecipes
    };
  }

  static User fromMap(Map<String, Object> map) {
    return User(
      id: map['id'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      photoUrl: map['photoUrl'] as String,
      isEmailVerified: (map['isEmailVerified'] as bool) ?? false,
      playedRecipes: map['playedRecipes'] as int,
      favoriteRecipes: map['favoriteRecipes'] as int,
    );
  }
}

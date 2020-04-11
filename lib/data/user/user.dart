class User {
  final String id;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String photoUrl;
  final bool isEmailVerified;

  User({
    this.id,
    this.displayName,
    this.email,
    this.phoneNumber,
    this.photoUrl,
    this.isEmailVerified,
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

  Map<String, Object> toJson() {
    return {
      'id': this.id,
      'displayName': this.displayName,
      'email': this.email,
      'phoneNumber': this.phoneNumber,
      'photoUrl': this.photoUrl,
      'isEmailVerified': this.isEmailVerified,
    };
  }

  static User fromJson(Map<String, Object> json) {
    return User(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      photoUrl: json['photoUrl'] as String,
      isEmailVerified: json['isEmailVerified'] as bool,
    );
  }
}

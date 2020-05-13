import 'package:foodieapp/util/date_util.dart';

/// Represents a network connection.
///
/// Based on follower-following relationships.
///
/// If User A follows User B:
/// - A is said to be the "follower" of B
/// - B becomes a "followee" of A
class Connection {
  /// Id of user who is following.
  final String followerId;

  /// Display name of user who is following.
  final String followerName;

  /// Photo URL of user who is following.
  final String followerPhotoUrl;

  /// Id of user being followed.
  final String followeeId;

  /// Display name of user being followed.
  final String followeeName;

  /// Photo URL of user being followed.
  final String followeePhotoUrl;

  /// Date and time when this connection was added.
  final DateTime followedAt;

  Connection({
    this.followerId,
    this.followerName,
    this.followerPhotoUrl,
    this.followeeId,
    this.followeeName,
    this.followeePhotoUrl,
    this.followedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Connection &&
          runtimeType == other.runtimeType &&
          this.followerId == other.followerId &&
          this.followeeId == other.followeeId;

  @override
  int get hashCode => followerId.hashCode ^ followeeId.hashCode;

  @override
  String toString() {
    return 'Connection{followerId: $followerId, followingId: $followeeId}';
  }

  Map<String, Object> toMap() {
    return {
      'followerId': this.followerId,
      'followerName': this.followerName,
      'followerPhotoUrl': this.followerPhotoUrl,
      'followeeId': this.followeeId,
      'followeeName': this.followeeName,
      'followeePhotoUrl': this.followeePhotoUrl,
      'followedAt': DateUtil.dateToUtcIsoString(this.followedAt),
    };
  }

  static Connection fromMap(Map<String, Object> map) {
    if (map == null) {
      return null;
    }

    return Connection(
      followerId: map['followerId'] as String,
      followerName: map['followerName'] as String,
      followerPhotoUrl: map['followerPhotoUrl'] as String,
      followeeId: map['followeeId'] as String,
      followeeName: map['followeeName'] as String,
      followeePhotoUrl: map['followeePhotoUrl'] as String,
      followedAt: DateUtil.dateFromUtcIsoString(map['followedAt'] as String),
    );
  }
}

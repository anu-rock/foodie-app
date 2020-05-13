import 'package:foodieapp/data/network/connection.dart';
import 'package:foodieapp/data/user/user.dart';

/// A class for network-related data and actions, and managing [Connection]s.
///
/// Defines an interface or contract for concrete network repositories.
///
/// Today there's a Firebase-based network repository,
/// tomorrow there could be an API-based network repository,
/// or even a local storage based network repository (for caching),
/// and so on.
abstract class NetworkRepository {
  /// Adds the current user as a follower of given user.
  Future<void> followUser(User followee);

  /// Removes the current user from followers of given user.
  Future<void> unfollowUser(User followee);

  /// Returns all followers of given user.
  Stream<List<Connection>> getFollowers(String userId);

  /// Returns all users followed by given user.
  Stream<List<Connection>> getFollowees(String userId);
}

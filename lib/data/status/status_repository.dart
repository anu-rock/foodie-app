import 'status.dart';

/// A class for status-related data and actions.
///
/// Defines an interface or contract for concrete status repositories.
///
/// Today there's a Firebase-based status repository,
/// tomorrow there could be an API-based status repository,
/// or even a local storage based status repository (for caching),
/// and so on.
abstract class StatusRepository {
  /// Adds a new status update for current user,
  /// and returns the added document as [Status].
  Future<Status> addUpdate(
    StatusType type, {
    String message,
    String photoUrl,
    String recipeId,
    String recipeTitle,
  });

  /// Deletes the given status update of current user.
  Future<void> deleteUpdate(String statusId);

  /// Returns recent status updates for all followees of current user.
  Stream<List<Status>> getNetworkUpdates();
}

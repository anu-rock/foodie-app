import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/network/firebase_network_repository.dart';
import 'package:foodieapp/util/string_util.dart';

import 'status_repository.dart';
import 'status.dart';

/// A concrete implementation of [StausRepository] based on [Firestore].
///
/// [Firestore] package internally takes care of caching data,
/// so a separate implementation of [StausRepository] for caching is not required.
class FirebaseStatusRepository implements StatusRepository {
  final Firestore _store;
  final FirebaseAuth _auth;
  CollectionReference _statusCollection;

  // Getting this from outside makes this class testable
  FirebaseStatusRepository({
    Firestore storeInstance,
    FirebaseAuth authInstance,
  })  : this._store = storeInstance ?? Firestore.instance,
        this._auth = authInstance ?? FirebaseAuth.instance {
    this._statusCollection = _store.collection(kFirestoreStatuses);
  }

  @override
  Future<Status> addUpdate(
    StatusType type, {
    String message,
    String photoUrl,
    String recipeId,
    String recipeTitle,
  }) async {
    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    if (type == StatusType.custom && StringUtil.isNullOrEmpty(message)) {
      throw ArgumentError('message cannot be null or empty.');
    }

    final status = Status(
      userId: currentUser.uid,
      type: type,
      message: type == StatusType.custom ? message : '',
      photoUrl: photoUrl,
      recipeId: recipeId,
      recipeTitle: recipeTitle,
      createdAt: DateTime.now(),
    );

    final doc = await this._statusCollection.add(status.toMap());
    final docData = (await doc.get()).data;
    docData['id'] = doc.documentID;
    return Status.fromMap(docData);
  }

  @override
  Future<void> deleteUpdate(String statusId) async {
    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    await this._statusCollection.document(statusId).delete();
  }

  @override
  Stream<List<Status>> getNetworkUpdates() async* {
    var currentUser = await this._auth.currentUser();
    if (currentUser == null) {
      throw AuthException(
          'not_logged_in', 'No current user found probably because user is not logged in.');
    }

    final networkRepo = FirebaseNetworkRepository(
      authInstance: _auth,
      storeInstance: _store,
    );

    final followees = await networkRepo.getFollowees(currentUser.uid).first;
    final followeeIds = followees.map((f) => f.followeeId).toList();

    if (followeeIds.isEmpty) {
      yield [];
      return;
    }

    yield* this
        ._statusCollection
        .where('userId', whereIn: followeeIds)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.documents
              .map<Status>(
                (doc) => Status.fromMap(doc.data),
              )
              .toList(),
        );
  }
}

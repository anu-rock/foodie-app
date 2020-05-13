import 'package:test/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/network/firebase_network_repository.dart';
import 'package:foodieapp/data/network/connection.dart';
import 'package:foodieapp/data/user/user.dart';

MockFirestoreInstance store;
MockFirebaseAuth auth;
FirebaseNetworkRepository repo;
FirebaseUser currentUser;

void init() async {
  store = MockFirestoreInstance();
  auth = MockFirebaseAuth(signedIn: true);
  repo = FirebaseNetworkRepository(
    storeInstance: store,
    authInstance: auth,
  );
  currentUser = await auth.currentUser();
  await seedData();
}

Future<void> seedData() async {
  final connection1 = Connection(
    followerId: currentUser.uid,
    followerName: currentUser.displayName,
    followerPhotoUrl: currentUser.photoUrl,
    followeeId: NetworkMockData.dummyUser1.id,
    followeeName: NetworkMockData.dummyUser1.displayName,
    followeePhotoUrl: NetworkMockData.dummyUser1.photoUrl,
    followedAt: DateTime.now(),
  );
  final connection2 = Connection(
    followerId: NetworkMockData.dummyUser1.id,
    followerName: NetworkMockData.dummyUser1.displayName,
    followerPhotoUrl: NetworkMockData.dummyUser1.photoUrl,
    followeeId: currentUser.uid,
    followeeName: currentUser.displayName,
    followeePhotoUrl: currentUser.photoUrl,
    followedAt: DateTime.now(),
  );
  await store
      .collection(kFirestoreNetwork)
      .document(repo.createDocId(connection1.followerId, connection1.followeeId))
      .setData(connection1.toMap());
  await store
      .collection(kFirestoreNetwork)
      .document(repo.createDocId(connection2.followerId, connection2.followeeId))
      .setData(connection2.toMap());
}

void main() {
  setUp(init);

  group('FirebaseNetworkRepository', () {
    group('followUser()', () {
      test('should add current user as follower of given user', () async {
        final follower = currentUser;
        final followee = NetworkMockData.dummyUser2;

        await repo.followUser(followee);

        final dbDoc = await store
            .collection(kFirestoreNetwork)
            .document(repo.createDocId(follower.uid, followee.id))
            .get();

        expect(dbDoc.exists, true);
        expect(dbDoc.data['followerId'], follower.uid);
        expect(dbDoc.data['followeeId'], followee.id);
      });

      test('should be idempotent when again adding current as follower of given user', () async {
        final follower = currentUser;
        final followee = NetworkMockData.dummyUser1;

        await repo.followUser(followee);

        final dbDoc = await store
            .collection(kFirestoreNetwork)
            .document(repo.createDocId(follower.uid, followee.id))
            .get();

        expect(dbDoc.exists, true);
        expect(dbDoc.data['followerId'], follower.uid);
        expect(dbDoc.data['followeeId'], followee.id);
      });

      test('should throw exception when user is not logged in', () {
        final authSignedOut = MockFirebaseAuth(signedIn: false);
        final repoWihoutUser = FirebaseNetworkRepository(
          storeInstance: store,
          authInstance: authSignedOut,
        );

        var callback = () async {
          await repoWihoutUser.followUser(NetworkMockData.dummyUser2);
        };

        expect(callback, throwsA(predicate((e) => e is AuthException)));
      });
    });

    group('unfollowUser()', () {
      test('should remove current user from followers of given user', () async {
        final follower = currentUser;
        final followee = NetworkMockData.dummyUser1;

        await repo.unfollowUser(followee);

        final dbDoc = await store
            .collection(kFirestoreNetwork)
            .document(repo.createDocId(follower.uid, followee.id))
            .get();

        expect(dbDoc.exists, false);
      });

      test('should execute silently when current is not a follower of given user', () async {
        final followee = NetworkMockData.dummyUser2;

        await repo.unfollowUser(followee);

        expect(true, true);
      });

      test('should throw exception when user is not logged in', () {
        final authSignedOut = MockFirebaseAuth(signedIn: false);
        final repoWihoutUser = FirebaseNetworkRepository(
          storeInstance: store,
          authInstance: authSignedOut,
        );

        var callback = () async {
          await repoWihoutUser.unfollowUser(NetworkMockData.dummyUser2);
        };

        expect(callback, throwsA(predicate((e) => e is AuthException)));
      });
    });

    group('getFollowers()', () {
      test('should correctly return followers of given user', () {
        final followee = NetworkMockData.dummyUser1;

        repo.getFollowers(followee.id).listen((followers) {
          expect(followers, isA<List>());
          expect(followers, isNotEmpty);
          expect(followers.first, isA<Connection>());
          expect(followers.first.followeeId, followee.id);
          expect(followers.first.followerId, currentUser.uid);
        });
      });

      test('should work when given user has no followers', () {
        final followee = NetworkMockData.dummyUser2;

        repo.getFollowers(followee.id).listen((followers) {
          expect(followers, isA<List>());
          expect(followers, isEmpty);
        });
      });
    });

    group('getFollowees()', () {
      test('should correctly return followees of given user', () {
        final follower = NetworkMockData.dummyUser1;

        repo.getFollowees(follower.id).listen((followees) {
          expect(followees, isA<List>());
          expect(followees, isNotEmpty);
          expect(followees.first, isA<Connection>());
          expect(followees.first.followerId, follower.id);
          expect(followees.first.followeeId, currentUser.uid);
        });
      });

      test('should work when given user has no followees', () {
        final follower = NetworkMockData.dummyUser2;

        repo.getFollowees(follower.id).listen((followees) {
          expect(followees, isA<List>());
          expect(followees, isEmpty);
        });
      });
    });
  });
}

class NetworkMockData {
  static final dummyUser1 = User(
    id: 'abcdefg',
    displayName: 'Mr. Test',
    email: 'mr@test.com',
    photoUrl: 'https://www.gravatar.com/avatar/4ad3999fab448dd381807d28f94f3967',
  );
  static final dummyUser2 = User(
    id: 'uvwxyz',
    displayName: 'Test Singh',
    email: 'test@singh.com',
    photoUrl: 'https://www.gravatar.com/avatar/d74ef5439e3d76e39a3086ea9ef1d02a',
  );
}

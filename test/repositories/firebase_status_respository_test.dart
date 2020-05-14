import 'package:test/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/status/firebase_status_repository.dart';
import 'package:foodieapp/data/network/firebase_network_repository.dart';
import 'package:foodieapp/data/status/status.dart';
import 'package:foodieapp/data/network/connection.dart';
import 'package:foodieapp/data/user/user.dart';

MockFirestoreInstance store;
MockFirebaseAuth auth;
FirebaseStatusRepository repo;
FirebaseNetworkRepository networkRepo;
FirebaseUser currentUser;

void init() async {
  store = MockFirestoreInstance();
  auth = MockFirebaseAuth(signedIn: true);
  repo = FirebaseStatusRepository(
    storeInstance: store,
    authInstance: auth,
  );
  networkRepo = FirebaseNetworkRepository(
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
    followeeId: MockData.dummyUser1.id,
    followeeName: MockData.dummyUser1.displayName,
    followeePhotoUrl: MockData.dummyUser1.photoUrl,
    followedAt: DateTime.now(),
  );
  final connection2 = Connection(
    followerId: MockData.dummyUser1.id,
    followerName: MockData.dummyUser1.displayName,
    followerPhotoUrl: MockData.dummyUser1.photoUrl,
    followeeId: currentUser.uid,
    followeeName: currentUser.displayName,
    followeePhotoUrl: currentUser.photoUrl,
    followedAt: DateTime.now(),
  );
  final status = Status(
    type: StatusType.custom,
    message: 'Enjoying Paneer Tikka Masala at home!!!',
    photoUrl: 'http://example.com/paneer-tikka.jpg',
    userId: MockData.dummyUser1.id,
    createdAt: DateTime.now(),
  );
  await store
      .collection(kFirestoreNetwork)
      .document(networkRepo.createDocId(connection1.followerId, connection1.followeeId))
      .setData(connection1.toMap());
  await store
      .collection(kFirestoreNetwork)
      .document(networkRepo.createDocId(connection2.followerId, connection2.followeeId))
      .setData(connection2.toMap());
  await store
      .collection(kFirestoreStatuses)
      .document(MockData.existingStatusId)
      .setData(status.toMap());
}

void main() {
  setUp(init);

  group('FirebaseStatusRepository', () {
    group('addUpdate()', () {
      test('should add a valid custom status correctly', () async {
        final update = await repo.addUpdate(
          StatusType.custom,
          message: 'Chicken Tikka all the way!!!',
        );

        expect(update, isA<Status>());
        expect(update.userId, currentUser.uid);
      });

      test('should add a valid non-custom status correctly', () async {
        final update = await repo.addUpdate(
          StatusType.recipe_played,
          recipeId: '111111',
          recipeTitle: 'Paneer Tikka',
        );

        expect(update, isA<Status>());
        expect(update.userId, currentUser.uid);
      });

      test('should throw exception when invalid custom status is given', () {
        var callback = () async {
          await repo.addUpdate(StatusType.custom);
        };

        expect(callback, throwsArgumentError);
      });

      test('should throw exception when user is not logged in', () {
        final authSignedOut = MockFirebaseAuth(signedIn: false);
        final repoWihoutUser = FirebaseStatusRepository(
          storeInstance: store,
          authInstance: authSignedOut,
        );

        var callback = () async {
          await repoWihoutUser.addUpdate(StatusType.custom, message: 'Haha');
        };

        expect(callback, throwsA(predicate((e) => e is AuthException)));
      });
    });

    group('deleteUpdate()', () {
      test('should delete given status', () async {
        await repo.deleteUpdate(MockData.existingStatusId);

        final dbDoc =
            await store.collection(kFirestoreStatuses).document(MockData.existingStatusId).get();

        expect(dbDoc.exists, false);
      });

      test('should silently exit when given status does not exist', () async {
        await repo.deleteUpdate('blablabla');

        expect(true, true);
      });

      test('should throw exception when user is not logged in', () {
        final authSignedOut = MockFirebaseAuth(signedIn: false);
        final repoWihoutUser = FirebaseStatusRepository(
          storeInstance: store,
          authInstance: authSignedOut,
        );

        var callback = () async {
          await repoWihoutUser.deleteUpdate(MockData.existingStatusId);
        };

        expect(callback, throwsA(predicate((e) => e is AuthException)));
      });
    });

    group('getNetworkUpdates()', () {
      // TODO:
      // This test is commented out until cloud_firestore_mocks package
      // adds support for whereIn in Query.where.
      //
      // test('should return updates from current user\'s followees', () async {
      //   repo.getNetworkUpdates().listen((statuses) {
      //     expect(statuses, isA<List>());
      //     expect(statuses, isNotEmpty);
      //     expect(statuses.first, isA<Status>());
      //     expect(statuses.first.userId, MockData.dummyUser1.id);
      //   });
      // });

      test('should throw exception when user is not logged in', () {
        final authSignedOut = MockFirebaseAuth(signedIn: false);
        final repoWihoutUser = FirebaseStatusRepository(
          storeInstance: store,
          authInstance: authSignedOut,
        );

        final updates = repoWihoutUser.getNetworkUpdates();

        expect(updates, emitsError(isA<AuthException>()));
      });
    });
  });
}

class MockData {
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

  static final existingStatusId = '1234567';
}

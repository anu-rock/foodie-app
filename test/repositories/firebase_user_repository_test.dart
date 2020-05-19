import 'package:flutter/services.dart';
import 'package:foodieapp/constants.dart';
import 'package:foodieapp/data/user/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:foodieapp/data/user/user_respository.dart';
import 'package:foodieapp/data/user/firebase_user_repository.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockAuthResult extends Mock implements AuthResult {}

MockFirestoreInstance store;
MockFirebaseAuth auth;
UserRepository repo;
BehaviorSubject<MockFirebaseUser> user;

void init() async {
  store = MockFirestoreInstance();
  auth = MockFirebaseAuth();
  repo = FirebaseUserRepository(
    storeInstance: store,
    authInstance: auth,
  );
  user = BehaviorSubject<MockFirebaseUser>();

  defineStubs();
}

void defineStubs() {
  when(auth.signInWithEmailAndPassword(email: MockData.existingEmail, password: MockData.password))
      .thenAnswer((_) async {
    user.add(MockFirebaseUser());
    return MockAuthResult();
  });

  when(auth.signInWithEmailAndPassword(email: MockData.invalidEmail, password: MockData.password))
      .thenThrow(PlatformException(code: 'ERROR_INVALID_EMAIL'));

  when(auth.signInWithEmailAndPassword(email: MockData.validEmail, password: MockData.password))
      .thenThrow(PlatformException(code: 'ERROR_USER_NOT_FOUND'));

  when(auth.createUserWithEmailAndPassword(email: MockData.validEmail, password: MockData.password))
      .thenAnswer((_) async {
    user.add(MockFirebaseUser());
    return MockAuthResult();
  });

  when(auth.createUserWithEmailAndPassword(
          email: MockData.existingEmail, password: MockData.password))
      .thenThrow(PlatformException(code: 'ERROR_EMAIL_ALREADY_IN_USE'));

  when(auth.currentUser()).thenAnswer((_) async {
    return MockFirebaseUser();
  });
}

void main() {
  setUp(init);

  tearDown(() {
    user.close();
  });

  group('FirebaseUserRepository', () {
    group('loginWithEmail()', () {
      test('returns appropriate failure response when invalid email is given', () async {
        var result = await repo.loginWithEmail(MockData.invalidEmail, MockData.password);
        expect(result.isSuccessful, false);
        expect(repo.authStatus, AuthStatus.Unauthenticated);
      });

      test('returns appropriate failure response when valid but non-existent email is given',
          () async {
        var result = await repo.loginWithEmail(MockData.validEmail, MockData.password);
        expect(result.isSuccessful, false);
        expect(repo.authStatus, AuthStatus.Unauthenticated);
      });

      test('returns appropriate success response when valid credentials are given', () async {
        var result = await repo.loginWithEmail(MockData.existingEmail, MockData.password);
        expect(result.isSuccessful, true);
        expect(repo.authStatus, AuthStatus.Authenticated);
      });
    });

    group('logout()', () {
      test('successfully logs the user out', () async {
        await repo.logout();
        expect(repo.authStatus, AuthStatus.Unauthenticated);
      });
    });

    group('signupWithEmail()', () {
      test('returns failure response when password and confirmPassword do not match', () async {
        var result = await repo.signupWithEmail(
            MockData.existingEmail, MockData.displayName, MockData.password, 'somethingelse');
        expect(result.isSuccessful, false);
      });

      test('returns failure response when existing email is given', () async {
        var result = await repo.signupWithEmail(
            MockData.existingEmail, MockData.displayName, MockData.password, MockData.password);
        expect(result.isSuccessful, false);
      });

      test('returns success response when valid credentials are given', () async {
        var result = await repo.signupWithEmail(
            MockData.validEmail, MockData.displayName, MockData.password, MockData.password);
        expect(result.isSuccessful, true);
      });
    });

    group('getUser()', () {
      setUp(() async {
        final user = MockData.existingUser;
        await store.collection(kFirestoreUsers).document(user.id).setData(user.toMap());
      });

      test('returns a user for existing id', () async {
        repo.getUser(MockData.existingUser.id).listen((user) {
          expect(user, isA<User>());
          expect(user.email, MockData.existingEmail);
        });
      });

      test('returns null for non-existent id', () async {
        repo.getUser('222222').listen((user) {
          expect(user, null);
        });
      });

      test('throws error for empty email', () async {
        final user = repo.getUser(null);

        expect(user, emitsError(isArgumentError));
      });
    });

    group('getUserByEmail()', () {
      setUp(() async {
        final user = MockData.existingUser;
        await store.collection(kFirestoreUsers).document(user.id).setData(user.toMap());
      });

      test('returns a user for existing email', () async {
        repo.getUserByEmail(MockData.existingEmail).listen((user) {
          expect(user, isA<User>());
          expect(user.email, MockData.existingEmail);
        });
      });

      test('returns null for non-existent email', () async {
        repo.getUserByEmail(MockData.validEmail).listen((user) {
          expect(user, null);
        });
      });

      test('throws error for empty email', () async {
        final user = repo.getUserByEmail(null);

        expect(user, emitsError(isArgumentError));
      });
    });
  });
}

class MockData {
  static String invalidEmail = 'xyz';
  static String validEmail = 'xyz@email.com';
  static String existingEmail = 'abc@email.com';
  static String password = '12345';
  static String displayName = 'Mr. XYZ';
  static User existingUser = User(
    id: '111111',
    displayName: displayName,
    email: existingEmail,
  );
}

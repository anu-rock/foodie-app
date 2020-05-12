import 'package:flutter/services.dart';
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

const invalidEmail = 'xyz';
const validEmail = 'xyz@email.com';
const existingEmail = 'abc@email.com';
const password = '12345';
const displayName = 'Mr. XYZ';

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
  when(auth.signInWithEmailAndPassword(email: existingEmail, password: password))
      .thenAnswer((_) async {
    user.add(MockFirebaseUser());
    return MockAuthResult();
  });

  when(auth.signInWithEmailAndPassword(email: invalidEmail, password: password))
      .thenThrow(PlatformException(code: 'ERROR_INVALID_EMAIL'));

  when(auth.signInWithEmailAndPassword(email: validEmail, password: password))
      .thenThrow(PlatformException(code: 'ERROR_USER_NOT_FOUND'));

  when(auth.createUserWithEmailAndPassword(email: validEmail, password: password))
      .thenAnswer((_) async {
    user.add(MockFirebaseUser());
    return MockAuthResult();
  });

  when(auth.createUserWithEmailAndPassword(email: existingEmail, password: password))
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
        var result = await repo.loginWithEmail(invalidEmail, password);
        expect(result.isSuccessful, false);
        expect(repo.authStatus, AuthStatus.Unauthenticated);
      });

      test('returns appropriate failure response when valid but non-existent email is given',
          () async {
        var result = await repo.loginWithEmail(validEmail, password);
        expect(result.isSuccessful, false);
        expect(repo.authStatus, AuthStatus.Unauthenticated);
      });

      test('returns appropriate success response when valid credentials are given', () async {
        var result = await repo.loginWithEmail(existingEmail, password);
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
        var result =
            await repo.signupWithEmail(existingEmail, displayName, password, 'somethingelse');
        expect(result.isSuccessful, false);
      });

      test('returns failure response when existing email is given', () async {
        var result = await repo.signupWithEmail(existingEmail, displayName, password, password);
        expect(result.isSuccessful, false);
      });

      test('returns success response when valid credentials are given', () async {
        var result = await repo.signupWithEmail(validEmail, displayName, password, password);
        expect(result.isSuccessful, true);
      });
    });
  });
}

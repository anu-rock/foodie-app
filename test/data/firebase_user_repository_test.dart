import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodieapp/data/user/user_respository.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'package:foodieapp/data/user/firebase_user_repository.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockAuthResult extends Mock implements AuthResult {}

const invalidEmail = 'xyz';
const validEmail = 'xyz@email.com';
const existingEmail = 'abc@email.com';
const password = '12345';

void main() {
  MockFirebaseAuth _auth = MockFirebaseAuth();
  BehaviorSubject<MockFirebaseUser> _user = BehaviorSubject<MockFirebaseUser>();
  UserRepository _repo = FirebaseUserRepository(authInstance: _auth);

  tearDownAll(() {
    _user.close();
  });

  group('FirebaseUserRepository', () {
    // Configure mock responses
    when(_auth.signInWithEmailAndPassword(
            email: existingEmail, password: password))
        .thenAnswer((_) async {
      _user.add(MockFirebaseUser());
      return MockAuthResult();
    });
    when(_auth.signInWithEmailAndPassword(
            email: invalidEmail, password: password))
        .thenThrow(PlatformException(code: 'ERROR_INVALID_EMAIL'));
    when(_auth.signInWithEmailAndPassword(
            email: validEmail, password: password))
        .thenThrow(PlatformException(code: 'ERROR_USER_NOT_FOUND'));

    group('loginWithEmail()', () {
      test('returns appropriate failure response when invalid email is given',
          () async {
        var result = await _repo.loginWithEmail(invalidEmail, password);
        expect(result.isSuccessful, false);
        expect(_repo.authStatus, AuthStatus.Unauthenticated);
      });

      test(
          'returns appropriate failure response when valid but non-existent email is given',
          () async {
        var result = await _repo.loginWithEmail(validEmail, password);
        expect(result.isSuccessful, false);
        expect(_repo.authStatus, AuthStatus.Unauthenticated);
      });

      test(
          'returns appropriate success response when valid credentials are given',
          () async {
        var result = await _repo.loginWithEmail(existingEmail, password);
        expect(result.isSuccessful, true);
        expect(_repo.authStatus, AuthStatus.Authenticated);
      });
    });

    group('logout()', () {
      test('successfully logs the user out', () async {
        await _repo.logout();
        expect(_repo.authStatus, AuthStatus.Unauthenticated);
      });
    });
  });
}

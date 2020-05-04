import 'package:test/test.dart';

import 'package:foodieapp/data/user/user.dart';

void main() {
  group('User', () {
    group('toMap()', () {
      test('should work with default instance', () {
        var user = User();
        var map = user.toMap();

        expect(map, isA<Map>());
      });

      test('should work with instance with email only', () {
        var user = User(email: 'xyz@email.com');
        var map = user.toMap();

        expect(map, isA<Map>());
        expect(map['email'], 'xyz@email.com');
      });
    });

    group('fromMap()', () {
      test('should work with empty map', () {
        var map = Map<String, Object>();
        var user = User.fromMap(map);

        expect(user, isA<User>());
        expect(user.isEmailVerified, false);
      });

      test('should work with map with email only', () {
        var map = {'email': 'xyz@email.com'};
        var user = User.fromMap(map);

        expect(user, isA<User>());
        expect(user.email, 'xyz@email.com');
      });
    });
  });
}

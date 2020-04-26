import 'package:test/test.dart';

import 'package:foodieapp/util/string_util.dart';

void main() {
  group('StringUtil', () {
    group('isNullOrEmpty()', () {
      test('should return true when null is given', () {
        final result = StringUtil.isNullOrEmpty(null);

        expect(result, true);
      });

      test('should return true when empty string is given', () {
        final result = StringUtil.isNullOrEmpty('');

        expect(result, true);
      });

      test('should return false when non-empty string is given', () {
        final result = StringUtil.isNullOrEmpty('abc');

        expect(result, false);
      });
    });

    group('ifNullOrEmpty()', () {
      test('should return replacement when null is given', () {
        final replacement = 'abc';
        final result = StringUtil.ifNullOrEmpty(null, replacement);

        expect(result, replacement);
      });

      test('should return replacement when empty string is given', () {
        final replacement = 'abc';
        final result = StringUtil.ifNullOrEmpty('', replacement);

        expect(result, replacement);
      });

      test('should return original string when non-empty string is given', () {
        final origString = 'xyz';
        final replacement = 'abc';
        final result = StringUtil.ifNullOrEmpty(origString, replacement);

        expect(result, origString);
      });
    });
  });
}

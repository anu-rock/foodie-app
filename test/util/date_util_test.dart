import 'package:test/test.dart';

import 'package:foodieapp/util/date_util.dart';

void main() {
  group('DateUtil', () {
    group('dateToUtcIsoString()', () {
      test('should return proper string when valid date is given', () {
        var date = DateTime.now();
        var result = DateUtil.dateToUtcIsoString(date);

        expect(result, date.toUtc().toIso8601String());
      });

      test('should return empty string when empty date is given', () {
        var result = DateUtil.dateToUtcIsoString(null);

        expect(result, isEmpty);
      });
    });

    group('dateFromUtcIsoString()', () {
      test('should return date when valid string is given', () {
        var result = DateUtil.dateFromUtcIsoString('2020-04-22T02:45:32.804Z');

        expect(result, isA<DateTime>());
        expect(result.year, 2020);
        expect(result.month, 4);
        expect(result.day, 22);
      });

      test('should return null when empty string is given', () {
        var result = DateUtil.dateFromUtcIsoString('');

        expect(result, isNull);
      });

      test('should return null when invalid string is given', () {
        var result = DateUtil.dateFromUtcIsoString('abc');

        expect(result, isNull);
      });
    });

    group('datesToUtcIsoStrings()', () {
      test('should return list of proper strings when valid dates are given', () {
        var date = DateTime.now();
        var result = DateUtil.datesToUtcIsoStrings([date]);

        expect(result, isA<List>());
        expect(result, isNotEmpty);
        expect(result[0], date.toUtc().toIso8601String());
      });

      test('should return an empty string for each empty date', () {
        var date = DateTime.now();
        var result = DateUtil.datesToUtcIsoStrings([date, null]);

        expect(result, isA<List>());
        expect(result, hasLength(2));
        expect(result[0], date.toUtc().toIso8601String());
        expect(result[1], isEmpty);
      });

      test('should return empty list when null is given', () {
        var result = DateUtil.datesToUtcIsoStrings(null);

        expect(result, isA<List>());
        expect(result, isEmpty);
      });
    });

    group('datesFromUtcIsoStrings()', () {
      test('should return dates when valid strings are given', () {
        var result = DateUtil.datesFromUtcIsoStrings(['2020-04-22T02:45:32.804Z']);

        expect(result, isA<List>());
        expect(result, isNotEmpty);
        expect(result[0], isA<DateTime>());
        expect(result[0].year, 2020);
        expect(result[0].month, 4);
        expect(result[0].day, 22);
      });

      test('should return null for each empty string', () {
        var result = DateUtil.datesFromUtcIsoStrings(['2020-04-22T02:45:32.804Z', '']);

        expect(result, isA<List>());
        expect(result, hasLength(2));
        expect(result[0], isA<DateTime>());
        expect(result[1], isNull);
      });

      test('should return null for each invalid string', () {
        var result = DateUtil.datesFromUtcIsoStrings(['2020-04-22T02:45:32.804Z', 'abc']);

        expect(result, isA<List>());
        expect(result, hasLength(2));
        expect(result[0], isA<DateTime>());
        expect(result[1], isNull);
      });

      test('should return empty list when null is given', () {
        var result = DateUtil.datesFromUtcIsoStrings(null);

        expect(result, isA<List>());
        expect(result, isEmpty);
      });
    });
  });
}

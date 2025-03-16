import 'package:chronology/chronology.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart';

void main() {
  setUp(() {
    initializeTimeZones();
  });

  group('datetime with era', () {
    test('Given datetime set 01-01-2568 (buddhist era) '
        'When set era buddhist '
        'Then datetime set 01-01-2568', () {
      final dateTimeWithEra = EraDateTime(
        year: 2568,
        month: 1,
        day: 1,
        era: Era.buddhist,
      );
      expect(dateTimeWithEra, isA<EraDateTime>());
      expect(dateTimeWithEra.year, 2568);
      expect(dateTimeWithEra.month, 1);
      expect(dateTimeWithEra.day, 1);
      expect(dateTimeWithEra.era, Era.buddhist);
      expect(dateTimeWithEra.weekday, DateTime.wednesday);
    });

    test('Given datetime set 29-02-2567 (avoid leap year)'
        'When set era buddhist '
        'Then datetime set 29-02-2567', () {
      final dateTimeWithEra = EraDateTime(
        year: 2567,
        month: 2,
        day: 29,
        era: Era.buddhist,
      );
      expect(dateTimeWithEra, isA<EraDateTime>());
      expect(dateTimeWithEra.year, 2567);
      expect(dateTimeWithEra.month, 2);
      expect(dateTimeWithEra.day, 29);
    });

    test('Given datetime set 15-06-2568 14:30:45.500100 (buddhist era) '
        'When set era buddhist '
        'Then datetime set 15-06-2568 14:30:45.500100', () {
      final dateTimeWithEra = EraDateTime(
        year: 2568,
        month: 6,
        day: 15,
        hour: 14,
        minute: 30,
        second: 45,
        millisecond: 500,
        microsecond: 100,
        era: Era.buddhist,
      );

      expect(dateTimeWithEra.year, 2568);
      expect(dateTimeWithEra.hour, 14);
      expect(dateTimeWithEra.minute, 30);
      expect(dateTimeWithEra.second, 45);
      expect(dateTimeWithEra.millisecond, 500);
      expect(dateTimeWithEra.microsecond, 100);
      expect(dateTimeWithEra.location.name, 'UTC');
      expect(dateTimeWithEra.era, Era.buddhist);
    });

    test('Given datetime set 01-01-2568 (buddhist era) '
        'When add 1 day '
        'Then datetime set 02-01-2568', () {
      final dateTimeWithEra = EraDateTime(
        year: 2568,
        month: 1,
        day: 1,
        era: Era.buddhist,
      );

      final added = dateTimeWithEra.add(const Duration(days: 1));
      expect(added.day, 2);
      expect(added.month, 1);
      expect(added.year, 2568);
    });

    test('Given datetime set 01-01-2568 (buddhist era) '
        'When subtract 24 hours '
        'Then datetime set 31-12-2567', () {
      final dateTimeWithEra = EraDateTime(
        year: 2568,
        month: 1,
        day: 1,
        era: Era.buddhist,
      );

      final subtracted = dateTimeWithEra.subtract(const Duration(hours: 24));
      expect(subtracted.day, 31);
      expect(subtracted.month, 12);
      expect(subtracted.year, 2567);
    });

    test('Given datetime set 01-01-2568 and 02-01-2568 (buddhist era) '
        'When compare dates '
        'Then first date is before second date', () {
      final date1 = EraDateTime(
        year: 2568,
        month: 1,
        day: 1,
        era: Era.buddhist,
      );

      final date2 = EraDateTime(
        year: 2568,
        month: 1,
        day: 2,
        era: Era.buddhist,
      );

      expect(date1.isBefore(date2), true);
      expect(date2.isAfter(date1), true);
      expect(date1.isAtSameMomentAs(date1), true);
      expect(date1.compareTo(date2), lessThan(0));
    });

    test('Given datetime set 01-01-2568 (buddhist era) '
        'When convert to DateTime '
        'Then datetime set 01-01-2025', () {
      final dateTimeEra = EraDateTime(
        year: 2568,
        month: 1,
        day: 1,
        era: Era.buddhist,
      );

      final dateTime = dateTimeEra.toDateTime();
      expect(dateTime, isA<DateTime>());
      expect(dateTime.year, 2025); // 2568 - 543 (Buddhist era gap)
    });

    test('Given datetime set 02-01-2568 and 01-01-2568 (buddhist era) '
        'When calculate difference '
        'Then difference is 1 day', () {
      final date = EraDateTime(year: 2568, month: 1, day: 2, era: Era.buddhist);
      final otherDate = EraDateTime(
        year: 2568,
        month: 1,
        day: 1,
        era: Era.buddhist,
      );

      final difference = date.difference(otherDate);
      expect(difference, isA<Duration>());
      expect(difference.inDays, 1);
      expect(difference.inHours, 24);
      expect(difference.inMinutes, 1440);
      expect(difference.inSeconds, 86400);
      expect(difference.inMilliseconds, 86400000);
      expect(difference.inMicroseconds, 86400000000);
    });

    test(
      'Given datetime set 02-01-2567 (buddhist era) and 01-01-2024 (common era) '
      'When calculate difference '
      'Then difference is 1 day',
      () {
        final date = EraDateTime(
          year: 2567,
          month: 1,
          day: 2,
          era: Era.buddhist,
        );
        final otherDate = EraDateTime(
          year: 2567 - Era.buddhist.commonEraYearGap,
          month: 1,
          day: 1,
          era: Era.common,
        );

        final difference = date.difference(otherDate);
        expect(difference, isA<Duration>());
        expect(difference.inDays, 1);
        expect(difference.inHours, 24);
        expect(difference.inMinutes, 1440);
        expect(difference.inSeconds, 86400);
        expect(difference.inMilliseconds, 86400000);
        expect(difference.inMicroseconds, 86400000000);
      },
    );

    test('Given datetime set to now '
        'When use timestamp factory constructor '
        'Then datetime is set to now in UTC and common era', () {
      final dateTime = EraDateTime.timestamp();
      expect(dateTime, isA<EraDateTime>());
      expect(dateTime.location.name, 'UTC');
      expect(dateTime.era, Era.common);
    });

    test('Given datetime set to now '
        'When use now factory constructor '
        'Then datetime is set to now in UTC and common era', () {
      final dateTime = EraDateTime.now();
      expect(dateTime, isA<EraDateTime>());
      expect(dateTime.location.name, 'UTC');
      expect(dateTime.era, Era.common);
    });

    test('Given datetime set to now in America/New_York '
        'When use now factory constructor with location and era '
        'Then datetime is set to now in America/New_York and buddhist era', () {
      final dateTimeWithLocation = EraDateTime.now(
        location: getLocation('America/New_York'),
        era: Era.buddhist,
      );
      expect(dateTimeWithLocation.location.name, 'America/New_York');
      expect(dateTimeWithLocation.era, Era.buddhist);
    });

    test(
      'Given datetime set 15-06-2568 14:30:45.500100 in Asia/Bangkok (buddhist era) '
      'When use withLocation factory constructor '
      'Then datetime is set 15-06-2568 14:30:45.500100 in Asia/Bangkok and buddhist era',
      () {
        final dateTime = EraDateTime.withLocation(
          location: getLocation('Asia/Bangkok'),
          year: 2568,
          month: 6,
          day: 15,
          hour: 14,
          minute: 30,
          second: 45,
          millisecond: 500,
          microsecond: 100,
          era: Era.buddhist,
        );

        expect(dateTime.location.name, 'Asia/Bangkok');
        expect(dateTime.year, 2568);
        expect(dateTime.month, 6);
        expect(dateTime.day, 15);
        expect(dateTime.hour, 14);
        expect(dateTime.minute, 30);
        expect(dateTime.second, 45);
        expect(dateTime.millisecond, 500);
        expect(dateTime.microsecond, 100);
        expect(dateTime.era, Era.buddhist);
      },
    );

    test('Given datetime set to now in Asia/Bangkok (buddhist era) '
        'When use fromDateTime factory constructor '
        'Then datetime is set to now in Asia/Bangkok and buddhist era', () {
      final now = DateTime.now();
      final dateTime = EraDateTime.fromDateTime(
        dateTime: now,
        era: Era.buddhist,
        location: getLocation('Asia/Bangkok'),
      );

      expect(dateTime.year, now.year + Era.buddhist.commonEraYearGap);
      expect(dateTime.month, now.month);
      expect(dateTime.day, now.day);
      expect(dateTime.hour, now.hour);
      expect(dateTime.minute, now.minute);
      expect(dateTime.second, now.second);
      expect(dateTime.millisecond, now.millisecond);
      expect(dateTime.microsecond, now.microsecond);
      expect(dateTime.era, Era.buddhist);
      expect(dateTime.location.name, 'Asia/Bangkok');
    });

    test(
      'Given datetime set 01-01-2568 12:00 in different timezones (buddhist era) '
      'When use withLocation factory constructor '
      'Then datetime is set 01-01-2568 12:00 in respective timezones',
      () {
        final bangkok = getLocation('Asia/Bangkok');
        final tokyo = getLocation('Asia/Tokyo');
        final newYork = getLocation('America/New_York');

        final dateTimeBangkok = EraDateTime.withLocation(
          location: bangkok,
          year: 2568,
          month: 1,
          day: 1,
          hour: 12,
          era: Era.buddhist,
        );

        final dateTimeTokyo = EraDateTime.withLocation(
          location: tokyo,
          year: 2568,
          month: 1,
          day: 1,
          hour: 12,
          era: Era.buddhist,
        );

        final dateTimeNewYork = EraDateTime.withLocation(
          location: newYork,
          year: 2568,
          month: 1,
          day: 1,
          hour: 12,
          era: Era.buddhist,
        );

        expect(dateTimeBangkok.location.name, 'Asia/Bangkok');
        expect(dateTimeTokyo.location.name, 'Asia/Tokyo');
        expect(dateTimeNewYork.location.name, 'America/New_York');
      },
    );

    test('Given datetime set to maximum values '
        'When use withLocation factory constructor '
        'Then datetime is set to maximum values', () {
      final maxDateTime = EraDateTime.withLocation(
        location: UTC,
        year: 9999,
        month: 12,
        day: 31,
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 999,
        era: Era.common,
      );

      expect(maxDateTime.year, 9999);
      expect(maxDateTime.month, 12);
      expect(maxDateTime.day, 31);
      expect(maxDateTime.hour, 23);
      expect(maxDateTime.minute, 59);
      expect(maxDateTime.second, 59);
      expect(maxDateTime.millisecond, 999);
      expect(maxDateTime.microsecond, 999);
    });

    test('Given datetime set to minimum values '
        'When use withLocation factory constructor '
        'Then datetime is set to minimum values', () {
      final minDateTime = EraDateTime.withLocation(
        location: UTC,
        year: 1,
        month: 1,
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
        era: Era.common,
      );

      expect(minDateTime.year, 1);
      expect(minDateTime.month, 1);
      expect(minDateTime.day, 1);
      expect(minDateTime.hour, 0);
      expect(minDateTime.minute, 0);
      expect(minDateTime.second, 0);
      expect(minDateTime.millisecond, 0);
      expect(minDateTime.microsecond, 0);
    });
  });

  test('Given datetime set 01-01-2568 (buddhist era) '
      'When calculate milliseconds and microseconds since epoch '
      'Then values match DateTime object', () {
    final dateTimeWithEra = EraDateTime(
      year: 2568,
      month: 1,
      day: 1,
      era: Era.buddhist,
    );
    final sinceEpoch = dateTimeWithEra.toDateTime().millisecondsSinceEpoch;
    expect(sinceEpoch, dateTimeWithEra.millisecondsSinceEpoch);

    final sinceMicroEpoch = dateTimeWithEra.toDateTime().microsecondsSinceEpoch;
    expect(sinceMicroEpoch, dateTimeWithEra.microsecondsSinceEpoch);
  });
}

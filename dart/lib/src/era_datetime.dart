// Copyright (c) 2025, the chronology project author.
// All rights reserved. Use of this source code is governed
// by a MIT license that can be found in the LICENSE file.

import 'package:timezone/timezone.dart';

part 'era_datetime.info.dart';

/// A class that represents a date and time in a specific era.
class EraDateTime {
  /// Factory constructor for creating a [DateTimeEra] instance with a now datetime at UTC timezone.
  factory EraDateTime.timestamp({Era era = Era.common}) {
    return EraDateTime.now(location: UTC);
  }

  /// Factory constructor for creating a [DateTimeEra] instance with a now datetime with a specific location.
  factory EraDateTime.now({Era era = Era.common, Location? location}) {
    final utcNow = DateTime.timestamp();
    return EraDateTime.withLocation(
      location: location ?? UTC,
      year: utcNow.year,
      month: utcNow.month,
      day: utcNow.day,
      hour: utcNow.hour,
      minute: utcNow.minute,
      second: utcNow.second,
      millisecond: utcNow.millisecond,
      microsecond: utcNow.microsecond,
      era: era,
    );
  }

  /// Factory constructor for creating a [EraTZDateTime] instance with a specific location.
  factory EraDateTime.withLocation({
    required Location location,
    required int year,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    Era era = Era.common,
  }) {
    return EraDateTime(
      location: location,
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
      microsecond: microsecond,
      era: era,
    );
  }

  /// Factory constructor for creating a [EraTZDateTime] instance with a specific location.
  factory EraDateTime({
    required int year,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    Era era = Era.common,
    Location? location,
  }) {
    /// Calculate the yearGap based on the selected era.
    final yearGap = year - era.commonEraYearGap;

    /// Create a DateTime object based on whether the time is location or UTC.
    final utcDateTime = TZDateTime(
      location ?? UTC,
      yearGap,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );

    /// Return a new DateTimeEra instance.
    return EraDateTime._internal(utcDateTime, era);
  }

  /// Factory constructor for creating a [EraTZDateTime] instance with a [DateTime] object.
  factory EraDateTime.fromDateTime({
    required DateTime dateTime,
    Era era = Era.common,
    Location? location,
  }) {
    final tzUtcDateTime = TZDateTime.from(dateTime.toUtc(), location ?? UTC);
    return EraDateTime.withLocation(
      location: tzUtcDateTime.location,
      year: tzUtcDateTime.year + era.commonEraYearGap,
      month: tzUtcDateTime.month,
      day: tzUtcDateTime.day,
      hour: tzUtcDateTime.hour,
      minute: tzUtcDateTime.minute,
      second: tzUtcDateTime.second,
      millisecond: tzUtcDateTime.millisecond,
      microsecond: tzUtcDateTime.microsecond,
      era: era,
    );
  }

  /// Internal constructor for creating a [EraTZDateTime] instance with a [DateTime] and [Era].
  EraDateTime._internal(this._ceTzDateTime, this._selectedEra);

  /// The underlying [TZDateTime] object representing the common era date and time.
  final TZDateTime _ceTzDateTime;

  /// The selected [Era] for this [DateTimeEra] instance.
  final Era _selectedEra;

  /// Getters for various date and time components, adjusted for the selected era.
  int get year => _ceTzDateTime.year + _selectedEra.commonEraYearGap;
  int get month => _ceTzDateTime.month;
  int get day => _ceTzDateTime.day;
  int get hour => _ceTzDateTime.hour;
  int get minute => _ceTzDateTime.minute;
  int get second => _ceTzDateTime.second;
  int get millisecond => _ceTzDateTime.millisecond;
  int get microsecond => _ceTzDateTime.microsecond;
  int get millisecondsSinceEpoch => _ceTzDateTime.millisecondsSinceEpoch;
  int get microsecondsSinceEpoch => _ceTzDateTime.microsecondsSinceEpoch;
  int get weekday => _ceTzDateTime.weekday;
  Location get location => _ceTzDateTime.location;
  Era get era => _selectedEra;

  /// Methods for adding and subtracting durations from the [EraDateTime].
  EraDateTime add(Duration duration) =>
      EraDateTime._internal(_ceTzDateTime.add(duration), _selectedEra);
  EraDateTime subtract(Duration duration) =>
      EraDateTime._internal(_ceTzDateTime.subtract(duration), _selectedEra);

  /// Comparison methods for [EraDateTime] instances.
  int compareTo(EraDateTime other) =>
      _ceTzDateTime.compareTo(other._ceTzDateTime);
  Duration difference(EraDateTime other) =>
      _ceTzDateTime.difference(other._ceTzDateTime);

  /// Methods to check the temporal relationship between two [EraDateTime] instances.
  bool isAfter(EraDateTime other) => _ceTzDateTime.isAfter(other._ceTzDateTime);
  bool isAtSameMomentAs(EraDateTime other) =>
      _ceTzDateTime.isAtSameMomentAs(other._ceTzDateTime);
  bool isBefore(EraDateTime other) =>
      _ceTzDateTime.isBefore(other._ceTzDateTime);

  /// Returns the [DateTime] (common era) object.
  TZDateTime toDateTime() => _ceTzDateTime;
}

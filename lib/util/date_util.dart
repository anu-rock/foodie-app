class DateUtil {
  /// Converts a local [DateTime] into a standardized timestamp
  /// (ISO 8601 representation of [DateTime]'s UTC version).
  ///
  /// Useful for saving a [DateTime] to database.
  static String dateToUtcIsoString(DateTime date) {
    if (date == null) {
      return '';
    }

    return date.toUtc().toIso8601String();
  }

  /// Converts a list of local [DateTime]s into a list of standardized timestamps
  /// (ISO 8601 representations of each [DateTime]'s UTC version).
  ///
  /// Useful for saving a list of [DateTime]s to database.
  static List<String> datesToUtcIsoStrings(List<DateTime> dates) {
    if (dates == null) {
      return [];
    }

    return dates.map<String>((d) => dateToUtcIsoString(d)).toList();
  }

  /// Converts a standardized timestamp (ISO 8601 representation
  /// of a [DateTime]'s UTC version) to local [DateTime].
  ///
  /// Useful for reading a [DateTime] from database.
  static DateTime dateFromUtcIsoString(String date) {
    if (date == null || date.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(date).toLocal();
    } on FormatException {
      return null;
    }
  }

  /// Converts a list of standardized timestamps (ISO 8601 representations
  /// of each [DateTime]'s UTC version) to a list of local [DateTime]s.
  ///
  /// Useful for reading a list of [DateTime]s from database.
  static List<DateTime> datesFromUtcIsoStrings(List<String> dates) {
    if (dates == null) {
      return [];
    }

    return dates.map<DateTime>((d) => dateFromUtcIsoString(d)).toList();
  }
}

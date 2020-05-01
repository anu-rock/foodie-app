/// A collection of utility methods for working with strings.
class StringUtil {
  /// Checks whether given string is null or empty string.
  static bool isNullOrEmpty(String str) {
    return str == null || str.isEmpty;
  }

  /// Returns the specified replacement string if given string is null or empty,
  /// or the given string itself if not.
  static String ifNullOrEmpty(String str, String replacement) {
    if (isNullOrEmpty(str)) {
      return replacement;
    }
    return str;
  }

  /// Truncates the given string such that if it is larger than `maxLen`
  /// characters, it is truncated and, optionally, appended with an ellipses.
  /// Otherwise, the given string is returned unchanged.
  static String truncateString({
    String str,
    int maxLen = 25,
    bool endWithEllipses = true,
  }) {
    if (isNullOrEmpty(str)) {
      throw ArgumentError('str cannot be empty or null.');
    }

    if (str.length <= maxLen) {
      return str;
    }

    return str.replaceRange(maxLen, null, endWithEllipses ? '...' : '');
  }
}

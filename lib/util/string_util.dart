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
}

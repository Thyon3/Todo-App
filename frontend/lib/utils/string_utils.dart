class StringUtils {
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  static String removeExtraSpaces(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static bool isNullOrEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  static String pluralize(int count, String singular, [String? plural]) {
    if (count == 1) return singular;
    return plural ?? '${singular}s';
  }

  static String getInitials(String name, {int maxChars = 2}) {
    if (name.isEmpty) return '';
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0].substring(0, maxChars.clamp(0, words[0].length)).toUpperCase();
    }
    return words
        .take(maxChars)
        .map((word) => word.isNotEmpty ? word[0] : '')
        .join()
        .toUpperCase();
  }
}

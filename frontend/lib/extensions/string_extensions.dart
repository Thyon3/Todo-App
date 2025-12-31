extension StringExtensions on String {
  bool get isNullOrEmpty => trim().isEmpty;

  bool get isNotNullOrEmpty => trim().isNotEmpty;

  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  String removeExtraSpaces() {
    return trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  bool containsIgnoreCase(String other) {
    return toLowerCase().contains(other.toLowerCase());
  }

  bool equalsIgnoreCase(String other) {
    return toLowerCase() == other.toLowerCase();
  }

  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  String toCamelCase() {
    final words = split(RegExp(r'[_\s]'));
    if (words.isEmpty) return this;
    return words.first +
        words.skip(1).map((word) => word.capitalize()).join();
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }

  bool get isNumeric {
    return RegExp(r'^-?[0-9]+$').hasMatch(this);
  }
}

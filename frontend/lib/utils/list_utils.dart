class ListUtils {
  static List<T> chunk<T>(List<T> list, int chunkSize) {
    final chunks = <T>[];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.addAll(
        list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize),
      );
    }
    return chunks;
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static Map<K, List<T>> groupBy<T, K>(List<T> list, K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final item in list) {
      final key = keySelector(item);
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(item);
    }
    return map;
  }

  static T? findFirst<T>(List<T> list, bool Function(T) predicate) {
    for (final item in list) {
      if (predicate(item)) return item;
    }
    return null;
  }

  static List<T> sortBy<T, K extends Comparable>(
    List<T> list,
    K Function(T) keySelector, {
    bool ascending = true,
  }) {
    final sorted = List<T>.from(list);
    sorted.sort((a, b) {
      final comparison = keySelector(a).compareTo(keySelector(b));
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }
}

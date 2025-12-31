import 'package:flutter/foundation.dart';

class PerformanceUtils {
  static Future<T> debounce<T>(
    Future<T> Function() operation, {
    Duration duration = const Duration(milliseconds: 500),
  }) async {
    await Future.delayed(duration);
    return await operation();
  }

  static void measurePerformance(String operationName, VoidCallback operation) {
    final stopwatch = Stopwatch()..start();
    operation();
    stopwatch.stop();
    if (kDebugMode) {
      print('$operationName took ${stopwatch.elapsedMilliseconds}ms');
    }
  }

  static Future<T> measureAsyncPerformance<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    final result = await operation();
    stopwatch.stop();
    if (kDebugMode) {
      print('$operationName took ${stopwatch.elapsedMilliseconds}ms');
    }
    return result;
  }

  static List<T> paginateList<T>(List<T> list, int page, int pageSize) {
    final startIndex = page * pageSize;
    if (startIndex >= list.length) return [];
    final endIndex = (startIndex + pageSize).clamp(0, list.length);
    return list.sublist(startIndex, endIndex);
  }
}

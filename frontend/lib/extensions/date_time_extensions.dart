extension DateTimeExtensions on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isToday() {
    final now = DateTime.now();
    return isSameDay(now);
  }

  bool isTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(tomorrow);
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  bool isThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return isAfter(weekStart.subtract(const Duration(days: 1))) &&
        isBefore(weekEnd.add(const Duration(days: 1)));
  }

  bool isThisMonth() {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  bool isThisYear() {
    final now = DateTime.now();
    return year == now.year;
  }

  DateTime startOfDay() {
    return DateTime(year, month, day);
  }

  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  DateTime startOfWeek() {
    return subtract(Duration(days: weekday - 1)).startOfDay();
  }

  DateTime endOfWeek() {
    return add(Duration(days: 7 - weekday)).endOfDay();
  }

  int get daysUntil {
    final now = DateTime.now().startOfDay();
    final target = startOfDay();
    return target.difference(now).inDays;
  }

  int get daysSince {
    final now = DateTime.now().startOfDay();
    final target = startOfDay();
    return now.difference(target).inDays;
  }
}

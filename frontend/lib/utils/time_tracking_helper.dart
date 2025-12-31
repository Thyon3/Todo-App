class TimeTrackingHelper {
  // Time tracking for tasks (Pomodoro technique, time spent)
  
  // Start time tracking for a task
  static Map<String, dynamic> startTracking(String taskId) {
    return {
      'taskId': taskId,
      'startTime': DateTime.now().toIso8601String(),
      'isActive': true,
    };
  }

  // Stop time tracking
  static Map<String, dynamic> stopTracking(Map<String, dynamic> session) {
    final startTime = DateTime.parse(session['startTime']);
    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);

    return {
      'taskId': session['taskId'],
      'startTime': session['startTime'],
      'endTime': endTime.toIso8601String(),
      'duration': duration.inSeconds,
      'isActive': false,
    };
  }

  // Calculate total time spent on a task
  static int calculateTotalTime(List<Map<String, dynamic>> sessions) {
    int totalSeconds = 0;
    for (final session in sessions) {
      if (session['duration'] != null) {
        totalSeconds += session['duration'] as int;
      }
    }
    return totalSeconds;
  }

  // Format duration to human-readable string
  static String formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    } else if (seconds < 3600) {
      final minutes = (seconds / 60).floor();
      return '$minutes min';
    } else {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).floor();
      return '${hours}h ${minutes}m';
    }
  }

  // Pomodoro timer (25 min work, 5 min break)
  static const int pomodoroWorkDuration = 25 * 60; // 25 minutes
  static const int pomodoroShortBreak = 5 * 60; // 5 minutes
  static const int pomodoroLongBreak = 15 * 60; // 15 minutes

  static Map<String, dynamic> startPomodoro(String taskId) {
    return {
      'taskId': taskId,
      'type': 'work',
      'startTime': DateTime.now().toIso8601String(),
      'duration': pomodoroWorkDuration,
      'pomodoroCount': 1,
    };
  }

  static Map<String, dynamic> startBreak(int pomodoroCount) {
    final isLongBreak = pomodoroCount % 4 == 0;
    return {
      'type': isLongBreak ? 'long_break' : 'short_break',
      'startTime': DateTime.now().toIso8601String(),
      'duration': isLongBreak ? pomodoroLongBreak : pomodoroShortBreak,
    };
  }
}

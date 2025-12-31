import '../models/task_model.dart';

class HabitTracker {
  // Track habits and streaks
  
  // Check if user completed tasks on a given day
  static bool hasCompletedTasksOnDate(
    List<TaskModel> tasks,
    DateTime date,
  ) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    return tasks.any((task) {
      if (task.status != TaskStatus.completed) return false;
      
      final taskDate = DateTime(
        task.updatedAt.year,
        task.updatedAt.month,
        task.updatedAt.day,
      );
      
      return taskDate == dateOnly;
    });
  }

  // Calculate current streak
  static int calculateStreak(List<TaskModel> tasks) {
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    while (true) {
      if (hasCompletedTasksOnDate(tasks, currentDate)) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        // Check if today hasn't had completions yet
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final currentDateOnly = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );
        
        if (currentDateOnly == todayDate && streak == 0) {
          // Today hasn't had completions, but streak continues if yesterday had
          currentDate = currentDate.subtract(const Duration(days: 1));
          if (!hasCompletedTasksOnDate(tasks, currentDate)) {
            break;
          }
        } else {
          break;
        }
      }
    }
    
    return streak;
  }

  // Get longest streak
  static int getLongestStreak(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0;
    
    final sortedTasks = tasks
        .where((t) => t.status == TaskStatus.completed)
        .toList()
      ..sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
    
    if (sortedTasks.isEmpty) return 0;
    
    int longestStreak = 1;
    int currentStreak = 1;
    DateTime? lastDate;
    
    for (final task in sortedTasks) {
      final taskDate = DateTime(
        task.updatedAt.year,
        task.updatedAt.month,
        task.updatedAt.day,
      );
      
      if (lastDate != null) {
        final difference = taskDate.difference(lastDate).inDays;
        
        if (difference == 1) {
          currentStreak++;
          longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
        } else if (difference > 1) {
          currentStreak = 1;
        }
      }
      
      lastDate = taskDate;
    }
    
    return longestStreak;
  }

  // Get completion calendar (last 30 days)
  static Map<DateTime, int> getCompletionCalendar(List<TaskModel> tasks) {
    final calendar = <DateTime, int>{};
    final now = DateTime.now();
    
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final dateOnly = DateTime(date.year, date.month, date.day);
      
      final count = tasks.where((task) {
        if (task.status != TaskStatus.completed) return false;
        
        final taskDate = DateTime(
          task.updatedAt.year,
          task.updatedAt.month,
          task.updatedAt.day,
        );
        
        return taskDate == dateOnly;
      }).length;
      
      calendar[dateOnly] = count;
    }
    
    return calendar;
  }

  // Get weekly completion stats
  static Map<String, int> getWeeklyStats(List<TaskModel> tasks) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    final stats = <String, int>{
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday': 0,
      'Saturday': 0,
      'Sunday': 0,
    };
    
    for (final task in tasks) {
      if (task.status != TaskStatus.completed) continue;
      
      if (task.updatedAt.isAfter(weekStart)) {
        final dayName = _getDayName(task.updatedAt.weekday);
        stats[dayName] = (stats[dayName] ?? 0) + 1;
      }
    }
    
    return stats;
  }

  static String _getDayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday - 1];
  }

  // Achievements/badges based on streaks
  static List<Map<String, dynamic>> getAchievements(
    int currentStreak,
    int longestStreak,
    int totalCompleted,
  ) {
    final achievements = <Map<String, dynamic>>[];
    
    if (currentStreak >= 7) {
      achievements.add({
        'title': '7-Day Warrior',
        'description': '7 days streak!',
        'icon': '🔥',
        'unlocked': true,
      });
    }
    
    if (currentStreak >= 30) {
      achievements.add({
        'title': 'Monthly Master',
        'description': '30 days streak!',
        'icon': '⭐',
        'unlocked': true,
      });
    }
    
    if (totalCompleted >= 100) {
      achievements.add({
        'title': 'Century Club',
        'description': '100 tasks completed!',
        'icon': '💯',
        'unlocked': true,
      });
    }
    
    if (longestStreak >= 50) {
      achievements.add({
        'title': 'Streak Legend',
        'description': '50 days longest streak!',
        'icon': '🏆',
        'unlocked': true,
      });
    }
    
    return achievements;
  }
}

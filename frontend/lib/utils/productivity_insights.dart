import '../models/task_model.dart';

class ProductivityInsights {
  // Generate productivity insights and recommendations
  
  static Map<String, dynamic> analyzeProductivity(List<TaskModel> tasks) {
    final insights = <String, dynamic>{};
    
    // Completion rate
    final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).length;
    final completionRate = tasks.isNotEmpty ? (completedTasks / tasks.length * 100).round() : 0;
    insights['completionRate'] = completionRate;
    
    // Average completion time
    final completedWithDates = tasks.where((t) => 
      t.status == TaskStatus.completed && t.dueDate != null
    ).toList();
    
    if (completedWithDates.isNotEmpty) {
      final totalDays = completedWithDates.fold<int>(0, (sum, task) {
        return sum + task.updatedAt.difference(task.createdAt).inDays;
      });
      insights['avgCompletionDays'] = (totalDays / completedWithDates.length).round();
    }
    
    // Best performing day of week
    final tasksByDay = <int, int>{};
    for (final task in tasks.where((t) => t.status == TaskStatus.completed)) {
      final day = task.updatedAt.weekday;
      tasksByDay[day] = (tasksByDay[day] ?? 0) + 1;
    }
    
    if (tasksByDay.isNotEmpty) {
      final bestDay = tasksByDay.entries.reduce((a, b) => a.value > b.value ? a : b);
      insights['bestDayOfWeek'] = _getDayName(bestDay.key);
      insights['bestDayCount'] = bestDay.value;
    }
    
    // Peak productivity time
    final tasksByHour = <int, int>{};
    for (final task in tasks.where((t) => t.status == TaskStatus.completed)) {
      final hour = task.updatedAt.hour;
      tasksByHour[hour] = (tasksByHour[hour] ?? 0) + 1;
    }
    
    if (tasksByHour.isNotEmpty) {
      final peakHour = tasksByHour.entries.reduce((a, b) => a.value > b.value ? a : b);
      insights['peakProductivityHour'] = peakHour.key;
      insights['peakProductivityPeriod'] = _getTimePeriod(peakHour.key);
    }
    
    // Current streak
    insights['currentStreak'] = _calculateStreak(tasks);
    
    // Recommendations
    insights['recommendations'] = _generateRecommendations(tasks, insights);
    
    return insights;
  }

  static String _getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  static String _getTimePeriod(int hour) {
    if (hour < 6) return 'Late Night (12am-6am)';
    if (hour < 12) return 'Morning (6am-12pm)';
    if (hour < 18) return 'Afternoon (12pm-6pm)';
    return 'Evening (6pm-12am)';
  }

  static int _calculateStreak(List<TaskModel> tasks) {
    final completedTasks = tasks
        .where((t) => t.status == TaskStatus.completed)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    
    if (completedTasks.isEmpty) return 0;
    
    int streak = 0;
    DateTime currentDate = DateTime.now();
    
    for (final task in completedTasks) {
      final taskDate = DateTime(
        task.updatedAt.year,
        task.updatedAt.month,
        task.updatedAt.day,
      );
      
      final currentDateOnly = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );
      
      if (taskDate == currentDateOnly || 
          taskDate == currentDateOnly.subtract(const Duration(days: 1))) {
        streak++;
        currentDate = taskDate;
      } else {
        break;
      }
    }
    
    return streak;
  }

  static List<String> _generateRecommendations(
    List<TaskModel> tasks,
    Map<String, dynamic> insights,
  ) {
    final recommendations = <String>[];
    
    final completionRate = insights['completionRate'] ?? 0;
    if (completionRate < 50) {
      recommendations.add('Try breaking down large tasks into smaller subtasks');
      recommendations.add('Set realistic deadlines to improve completion rate');
    }
    
    final overdueTasks = tasks.where((t) => 
      t.isOverdue && t.status != TaskStatus.completed
    ).length;
    
    if (overdueTasks > 3) {
      recommendations.add('You have $overdueTasks overdue tasks. Prioritize them first!');
    }
    
    final highPriorityPending = tasks.where((t) => 
      t.priority == TaskPriority.high && t.status != TaskStatus.completed
    ).length;
    
    if (highPriorityPending > 5) {
      recommendations.add('Too many high priority tasks. Review and adjust priorities.');
    }
    
    if (insights.containsKey('bestDayOfWeek')) {
      recommendations.add(
        'Your most productive day is ${insights['bestDayOfWeek']}. '
        'Schedule important tasks on this day!'
      );
    }
    
    if (insights.containsKey('currentStreak') && insights['currentStreak'] > 7) {
      recommendations.add('Great job! You\'re on a ${insights['currentStreak']}-day streak! 🔥');
    }
    
    return recommendations;
  }

  // Gamification scores
  static int calculateProductivityScore(List<TaskModel> tasks) {
    int score = 0;
    
    // Points for completed tasks
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
    score += completed * 10;
    
    // Bonus for high priority completions
    final highPriorityCompleted = tasks.where((t) => 
      t.priority == TaskPriority.high && t.status == TaskStatus.completed
    ).length;
    score += highPriorityCompleted * 5;
    
    // Bonus for tasks with subtasks
    final tasksWithSubtasks = tasks.where((t) => 
      t.completionPercentage == 100 && t.status == TaskStatus.completed
    ).length;
    score += tasksWithSubtasks * 15;
    
    // Penalty for overdue tasks
    final overdue = tasks.where((t) => 
      t.isOverdue && t.status != TaskStatus.completed
    ).length;
    score -= overdue * 5;
    
    return score.clamp(0, double.infinity).toInt();
  }
}

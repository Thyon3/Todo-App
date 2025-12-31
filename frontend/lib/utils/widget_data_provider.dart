import '../models/task_model.dart';

class WidgetDataProvider {
  // Provide data for home screen widgets (Android/iOS)
  
  static Map<String, dynamic> getTodayTasksWidgetData(List<TaskModel> tasks) {
    final todayTasks = tasks.where((t) => 
      t.isDueToday && t.status != TaskStatus.completed
    ).toList();
    
    return {
      'count': todayTasks.length,
      'tasks': todayTasks.take(5).map((t) => {
        'id': t.id,
        'title': t.title,
        'priority': t.priority.name,
      }).toList(),
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> getProgressWidgetData(List<TaskModel> tasks) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
    final percentage = total > 0 ? ((completed / total) * 100).round() : 0;
    
    return {
      'total': total,
      'completed': completed,
      'pending': total - completed,
      'percentage': percentage,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> getQuickStatsWidgetData(List<TaskModel> tasks) {
    final overdue = tasks.where((t) => 
      t.isOverdue && t.status != TaskStatus.completed
    ).length;
    
    final dueToday = tasks.where((t) => 
      t.isDueToday && t.status != TaskStatus.completed
    ).length;
    
    final highPriority = tasks.where((t) => 
      t.priority == TaskPriority.high && t.status != TaskStatus.completed
    ).length;
    
    return {
      'overdue': overdue,
      'dueToday': dueToday,
      'highPriority': highPriority,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> getStreakWidgetData(int currentStreak) {
    return {
      'streak': currentStreak,
      'emoji': currentStreak > 0 ? '🔥' : '💤',
      'message': _getStreakMessage(currentStreak),
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  static String _getStreakMessage(int streak) {
    if (streak == 0) return 'Start your streak today!';
    if (streak == 1) return 'Great start!';
    if (streak < 7) return 'Keep it up!';
    if (streak < 30) return 'You\'re on fire!';
    return 'Unstoppable!';
  }

  // Generate widget configuration
  static Map<String, dynamic> getWidgetConfig() {
    return {
      'updateInterval': 15, // minutes
      'showNotifications': true,
      'theme': 'auto', // auto, light, dark
      'compactMode': false,
    };
  }
}

import '../models/task_model.dart';

class AnalyticsHelper {
  static Map<String, dynamic> getTaskStatistics(List<TaskModel> tasks) {
    final total = tasks.length;
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
    final pending = tasks.where((t) => t.status == TaskStatus.pending).length;
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final overdue = tasks.where((t) => t.isOverdue && t.status != TaskStatus.completed).length;

    return {
      'total': total,
      'completed': completed,
      'pending': pending,
      'inProgress': inProgress,
      'overdue': overdue,
      'completionRate': total > 0 ? (completed / total * 100).round() : 0,
    };
  }

  static Map<TaskPriority, int> getTasksByPriority(List<TaskModel> tasks) {
    return {
      TaskPriority.low: tasks.where((t) => t.priority == TaskPriority.low).length,
      TaskPriority.medium: tasks.where((t) => t.priority == TaskPriority.medium).length,
      TaskPriority.high: tasks.where((t) => t.priority == TaskPriority.high).length,
    };
  }

  static Map<String, int> getTasksByCategory(List<TaskModel> tasks) {
    final Map<String, int> result = {};
    for (final task in tasks) {
      final categoryId = task.categoryId ?? 'uncategorized';
      result[categoryId] = (result[categoryId] ?? 0) + 1;
    }
    return result;
  }

  static List<TaskModel> getProductiveDays(List<TaskModel> tasks, int days) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    
    return tasks.where((task) {
      return task.status == TaskStatus.completed &&
          task.updatedAt.isAfter(startDate);
    }).toList();
  }

  static double getAverageCompletionTime(List<TaskModel> completedTasks) {
    if (completedTasks.isEmpty) return 0;
    
    var totalHours = 0.0;
    for (final task in completedTasks) {
      final duration = task.updatedAt.difference(task.createdAt);
      totalHours += duration.inHours;
    }
    
    return totalHours / completedTasks.length;
  }
}

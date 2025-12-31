import '../models/task_model.dart';

class TaskSorter {
  static List<TaskModel> sortByPriority(
    List<TaskModel> tasks, {
    bool ascending = false,
  }) {
    final sorted = List<TaskModel>.from(tasks);
    sorted.sort((a, b) {
      final comparison = b.priority.index.compareTo(a.priority.index);
      return ascending ? -comparison : comparison;
    });
    return sorted;
  }

  static List<TaskModel> sortByDueDate(
    List<TaskModel> tasks, {
    bool ascending = true,
  }) {
    final sorted = List<TaskModel>.from(tasks);
    sorted.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      
      final comparison = a.dueDate!.compareTo(b.dueDate!);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  static List<TaskModel> sortByTitle(
    List<TaskModel> tasks, {
    bool ascending = true,
  }) {
    final sorted = List<TaskModel>.from(tasks);
    sorted.sort((a, b) {
      final comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  static List<TaskModel> sortByCreatedDate(
    List<TaskModel> tasks, {
    bool ascending = false,
  }) {
    final sorted = List<TaskModel>.from(tasks);
    sorted.sort((a, b) {
      final comparison = a.createdAt.compareTo(b.createdAt);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  static List<TaskModel> sortByCompletionPercentage(
    List<TaskModel> tasks, {
    bool ascending = false,
  }) {
    final sorted = List<TaskModel>.from(tasks);
    sorted.sort((a, b) {
      final comparison = a.completionPercentage.compareTo(b.completionPercentage);
      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  static List<TaskModel> sortSmart(List<TaskModel> tasks) {
    final sorted = List<TaskModel>.from(tasks);
    sorted.sort((a, b) {
      // Overdue tasks first
      if (a.isOverdue && !b.isOverdue) return -1;
      if (!a.isOverdue && b.isOverdue) return 1;
      
      // Then by priority
      if (a.priority != b.priority) {
        return b.priority.index.compareTo(a.priority.index);
      }
      
      // Then by due date
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }
      
      return 0;
    });
    return sorted;
  }
}

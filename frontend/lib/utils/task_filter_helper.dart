import '../models/task_model.dart';

class TaskFilterHelper {
  static List<TaskModel> filterByDateRange(
    List<TaskModel> tasks,
    DateTime start,
    DateTime end,
  ) {
    return tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isAfter(start.subtract(const Duration(days: 1))) &&
          task.dueDate!.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  static List<TaskModel> filterByKeywords(
    List<TaskModel> tasks,
    List<String> keywords,
  ) {
    return tasks.where((task) {
      final searchText =
          '${task.title} ${task.description} ${task.tags.join(' ')}'
              .toLowerCase();
      return keywords.any((keyword) =>
          searchText.contains(keyword.toLowerCase()));
    }).toList();
  }

  static List<TaskModel> filterByCompletion(
    List<TaskModel> tasks,
    bool completed,
  ) {
    return tasks
        .where((task) =>
            (task.status == TaskStatus.completed) == completed)
        .toList();
  }

  static List<TaskModel> filterOverdue(List<TaskModel> tasks) {
    return tasks
        .where((task) =>
            task.isOverdue && task.status != TaskStatus.completed)
        .toList();
  }

  static List<TaskModel> filterDueToday(List<TaskModel> tasks) {
    return tasks.where((task) => task.isDueToday).toList();
  }

  static List<TaskModel> filterByMultipleCriteria({
    required List<TaskModel> tasks,
    TaskPriority? priority,
    String? categoryId,
    TaskStatus? status,
    bool? hasReminder,
  }) {
    var filtered = tasks;

    if (priority != null) {
      filtered = filtered.where((t) => t.priority == priority).toList();
    }

    if (categoryId != null) {
      filtered = filtered.where((t) => t.categoryId == categoryId).toList();
    }

    if (status != null) {
      filtered = filtered.where((t) => t.status == status).toList();
    }

    if (hasReminder != null) {
      filtered = filtered.where((t) => t.hasReminder == hasReminder).toList();
    }

    return filtered;
  }
}
